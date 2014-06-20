Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935078AbaFTQbo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 12:31:44 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:33387 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934702AbaFTQbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 12:31:43 -0400
MIME-Version: 1.0
In-Reply-To: <1403213133.2753.20.camel@joe-AO725>
References: <1403206156-3702-1-git-send-email-xerofoify@gmail.com>
	<1403213133.2753.20.camel@joe-AO725>
Date: Fri, 20 Jun 2014 12:31:42 -0400
Message-ID: <CAPDOMVhGcgyeMGV1EWMEau0QHUoKtLcFC-BtE2yWWHveXciQVw@mail.gmail.com>
Subject: Re: [PATCH] staging: rtl8192e: check return value of dev_skb_alloc
From: Nick Krause <xerofoify@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Valentina Manea <valentina.manea.m@gmail.com>, lisa@xenapiadmin.com,
        ben@decadent.org.uk, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is old I thought I fixed it and resent.
Cheers Nick

On Thu, Jun 19, 2014 at 5:25 PM, Joe Perches <joe@perches.com> wrote:
> On Thu, 2014-06-19 at 15:29 -0400, Nicholas Krause wrote:
>
>> diff --git a/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c b/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
> []
>> @@ -59,7 +58,8 @@ static bool fw_download_code(struct net_device *dev, u8 *code_virtual_address,
>>                       bLastIniPkt = 1;
>>
>>               }
>> -
>> +             if (!skb)
>> +                     return false;
>>               skb  = dev_alloc_skb(frag_length + 4);
>
> Nick.
>
> You may have compiled this, but it's obvious you
> haven't tested it.
>
> Please stop sending patches until you can verify what
> you're doing with the code.
>
> Please train a few more of your neurons for coding.
>
> It takes some time and some practice but please don't
> practice on linux-kernel.
>
> Use google to find some other suitable forums like
> http://cboard.cprogramming.com/c-programming/
>
> Back to your patch:
>
>         if (!skb)
>                 return false;
>
> must go _after_
>
>         skb = dev_alloc_skb(frag_length + 4);
>
>
>
