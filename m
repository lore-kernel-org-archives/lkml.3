Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935751Ab3IELRJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 07:17:09 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:50028 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935671Ab3IELRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 07:17:07 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.34 with qID r85BGouN019517, This message is accepted by code: ctloc85258
Message-ID: <52286822.9090402@realsil.com.cn>
Date: Thu, 5 Sep 2013 19:16:50 +0800
From: wwang <wei_wang@realsil.com.cn>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: <sameo@linux.intel.com>, <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <rogerable@realtek.com>,
        <devel@linuxdriverproject.org>
Subject: Re: [PATCH] mfd: rtsx: Modify rts5249_optimize_phy
References: <1378374338-11455-1-git-send-email-wei_wang@realsil.com.cn> <20130905104820.GL6329@mwanda>
In-Reply-To: <20130905104820.GL6329@mwanda>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.29.41.8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年09月05日 18:48, Dan Carpenter 写道:
> On Thu, Sep 05, 2013 at 05:45:38PM +0800, wei_wang@realsil.com.cn wrote:
>> From: Wei WANG <wei_wang@realsil.com.cn>
>>
>> In some platforms, specially Thinkpad series, rts5249 won't be
>> initialized properly. So we need adjust some phy parameters to
>> improve the compatibility issue.
>>
>> Signed-off-by: Wei WANG <wei_wang@realsil.com.cn>
>> ---
>>   drivers/mfd/rts5249.c |   25 +++++++++++++++++++++++--
>>   1 file changed, 23 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/mfd/rts5249.c b/drivers/mfd/rts5249.c
>> index 3b835f5..e3c6dc1 100644
>> --- a/drivers/mfd/rts5249.c
>> +++ b/drivers/mfd/rts5249.c
>> @@ -130,13 +130,34 @@ static int rts5249_optimize_phy(struct rtsx_pcr *pcr)
>>   {
>>   	int err;
>>   
>> -	err = rtsx_pci_write_phy_register(pcr, PHY_REG_REV, 0xFE46);
>> +	err = rtsx_pci_write_phy_register(pcr, PHY_REG_REV, 0xFC6C);
>
> How are we supposed to review this change?  What happened to 0xFE46?
> What are all these magic numbers?  I understand that this fixes an issue
> for think pads but does it break something else?
>
> regards,
> dan carpenter
>
> .
>
Hi Dan:

These numbers are used to configure the parameters of our internal 
analog circuit. Those new values have been tested for quite a long time 
with our Windows driver. So it's guaranteed and won't break other platforms.

BR,
Wei
