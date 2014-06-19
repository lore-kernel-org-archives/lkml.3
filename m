Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757889AbaFSSlO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 14:41:14 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:56360 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756850AbaFSSlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 14:41:12 -0400
MIME-Version: 1.0
In-Reply-To: <20140619052910.GP5500@mwanda>
References: <1403144681-6902-1-git-send-email-xerofoify@gmail.com>
	<20140619052910.GP5500@mwanda>
Date: Thu, 19 Jun 2014 14:41:11 -0400
Message-ID: <CAPDOMViz=cte8_YkxFMLSZmsgC5LysDMoNCokB8f4A3YKmDhSg@mail.gmail.com>
Subject: Re: [PATCH] staging: rtl8192e: check return value of dev_skb_alloc
From: Nick Krause <xerofoify@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, devel@driverdev.osuosl.org,
        ben@decadent.org.uk, lisa@xenapiadmin.com,
        Valentina Manea <valentina.manea.m@gmail.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey  guys,
Sorry about no reply,
my power supply died last night,
have to get a new one. I will be RMAing
the old old in order to get a packup in
case this PSU dies.
Cheers Nick


On Thu, Jun 19, 2014 at 1:29 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Wed, Jun 18, 2014 at 10:24:41PM -0400, Nicholas Krause wrote:
>> Checks if dev_skb_alloc returns Null in function, fw_download_code.
>> If the return value of dev_skb_alloc is NULL return false and exit
>> this function.
>> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
>> ---
>>  drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c b/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
>> index 1a95d1f..38ae236 100644
>> --- a/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
>> +++ b/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
>> @@ -62,6 +62,8 @@ static bool fw_download_code(struct net_device *dev, u8 *code_virtual_address,
>>
>>               skb  = dev_alloc_skb(frag_length + 4);
>>               memcpy((unsigned char *)(skb->cb), &dev, sizeof(dev));
>> +             if (!skb)
>> +                     return !rt_status;
>
> What's this !rt_status?  Just return false.
>
> regards,
> dan carpenter
>
