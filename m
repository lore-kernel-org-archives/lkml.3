Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442Ab3EOH5E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 03:57:04 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:23437
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757107Ab3EOH5B convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 03:57:01 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 4
X-BigFish: VS4(z3121kz98dIc89bh936eI1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6h1082kzz8275bhz2dh2a8h668h839h93fhe5bhf0ah1288h12a5h12a9h12bdh1354h137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19c3h1ad9h1b0ah1d0ch1d2eh1d3fh1889i1155h)
Message-ID: <51934054.1080106@freescale.com>
Date: Wed, 15 May 2013 15:59:16 +0800
From: Huang Shijie <b32955@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: <dedekind1@gmail.com>
CC: <dwmw2@infradead.org>, <computersforpeace@gmail.com>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] mtd: add a new field to mtd_info{}
References: <1367562104-8955-1-git-send-email-b32955@freescale.com>	 <1367562104-8955-2-git-send-email-b32955@freescale.com> <1368604064.13665.22.camel@sauron.fi.intel.com>
In-Reply-To: <1368604064.13665.22.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年05月15日 15:47, Artem Bityutskiy 写道:
> On Fri, 2013-05-03 at 14:21 +0800, Huang Shijie wrote:
>> In order to implement the NAND boot for some Freescale's chips, such as
>> imx23/imx28/imx50/imx6, we use a tool (called kobs-ng) to burn the uboot
>> and some metadata to nand chip. And the ROM code will use the metadata to
>> configrate the BCH, and to find the uboot.
>>
>> The ECC information(ecc step size, ecc strength) which is used to configrate
>> the BCH is part of the metadata. The kobs-ng can gets the ecc strength from
>> the sys node /sys/*/ecc_strength now. But it can not gets the ecc step size.
>>
>> This patch adds a new field to store the ecc step size in mtd_info{}, and
>> it makes preparation for the next patches.
>>
>> Signed-off-by: Huang Shijie<b32955@freescale.com>
>> ---
>>   include/linux/mtd/mtd.h |    3 +++
>>   1 files changed, 3 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/linux/mtd/mtd.h b/include/linux/mtd/mtd.h
>> index 183a304..b93035f 100644
>> --- a/include/linux/mtd/mtd.h
>> +++ b/include/linux/mtd/mtd.h
>> @@ -173,6 +173,9 @@ struct mtd_info {
>>   	/* ECC layout structure pointer - read only! */
>>   	struct nand_ecclayout *ecclayout;
>>
>> +	/* the ecc step size. */
>> +	unsigned int ecc_size;
> It would really be nice to harmonize the naming and probably stick to
> ecc_step everywhere. To me things looks confusing, because ecc_size is
> actually ECC step size, and not the size of ECC codes.
>
ok. I will use ecc_step as the name.

thanks
Huang Shijie


