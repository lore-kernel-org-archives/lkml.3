Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756288Ab3AOIyE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 03:54:04 -0500
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:33012
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752205Ab3AOIyC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 03:54:02 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 2
X-BigFish: VS2(zzc89bh1432Izz1ee6h1de0h1202h1e76h1d1ah1d2ah1082kzz8275bhz2dh2a8h668h839h93fhd25he5bhf0ah1288h12a5h12a9h12bdh1354h137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h1155h)
Message-ID: <50F5190D.9050700@freescale.com>
Date: Tue, 15 Jan 2013 16:53:33 +0800
From: Huang Shijie <b32955@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Matthieu CASTET <matthieu.castet@parrot.com>
CC: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dedekind1@gmail.com" <dedekind1@gmail.com>
Subject: Re: [PATCH] mtd: apply tPROG delay for ONFI nand's page program
References: <1358147853-31826-1-git-send-email-b32955@freescale.com> <50F3FA09.3080405@parrot.com>
In-Reply-To: <50F3FA09.3080405@parrot.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年01月14日 20:28, Matthieu CASTET 写道:
> Huang Shijie a écrit :
>> With some latest Micron's onfi nand(such as MT29F64G08CBABAWP),
>> I find that if we do not apply the tPROG delay as the datasheet tells us,
>> the page program may fails. You will read out the all 0xff from this page
>> in this case.
>>
>> This patch adds the tPROG delay for page program when it is an onfi nand.
>>
>> Signed-off-by: Huang Shijie<b32955@freescale.com>
>> ---
>>   drivers/mtd/nand/nand_base.c |    4 ++++
>>   1 files changed, 4 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
>> index 8323ac9..b628dd5 100644
>> --- a/drivers/mtd/nand/nand_base.c
>> +++ b/drivers/mtd/nand/nand_base.c
>> @@ -841,6 +841,10 @@ static int nand_wait(struct mtd_info *mtd, struct nand_chip *chip)
>>   	 */
>>   	ndelay(100);
>>
>> +	/* Apply the tPROG delay for ONFI nand program. */
>> +	if (chip->onfi_version&&  state == FL_WRITING)
>> +		udelay(le16_to_cpu(chip->onfi_params.t_prog));
>> +
>>   	if ((state == FL_ERASING)&&  (chip->options&  NAND_IS_AND))
>>   		chip->cmdfunc(mtd, NAND_CMD_STATUS_MULTI, -1, -1);
>>   	else
> It looks wrong : why should be wait tPROG before using status command to monitor
> program end ?
>
> tPROG is the Page program time (Measured from the falling edge of SR[6] to the
> rising edge of SR[6]), but because we monitor SR[6] with status command, we
> already wait for that time.
>
thanks. you are right. Please ignore this patch.
> Are you sure that it is not a bug in your nand driver with status command ?
>
>
I will try to find the bug in the driver.

thanks
Huang Shijie
> Matthieu
>


