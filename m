Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934700AbaFSVMU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 17:12:20 -0400
Received: from mail-ve0-f175.google.com ([209.85.128.175]:47713 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934434AbaFSVMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 17:12:19 -0400
MIME-Version: 1.0
In-Reply-To: <1403211188.2753.9.camel@joe-AO725>
References: <1403209102-10633-1-git-send-email-xerofoify@gmail.com>
	<CAPDOMVhBHa3QqFY+5T+noCxKkffN6Mo0PrN1_1ZRV22RNXUKXg@mail.gmail.com>
	<1403211188.2753.9.camel@joe-AO725>
Date: Thu, 19 Jun 2014 17:12:18 -0400
Message-ID: <CAPDOMVgacNsgNAM+e+GNJd17Rpae+j8h3KGizDoS2Edfu-q=gw@mail.gmail.com>
Subject: Re: [PATCH] staging: rtl8192 Check for Null return from dev_skb_alloc
From: Nick Krause <xerofoify@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, lisa@xenapiadmin.com,
        Valentina Manea <valentina.manea.m@gmail.com>, ben@decadent.org.uk,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Joe,
I need to read my patches more carefully.
Nick :)


On Thu, Jun 19, 2014 at 4:53 PM, Joe Perches <joe@perches.com> wrote:
> On Thu, 2014-06-19 at 16:20 -0400, Nick Krause wrote:
>> Hey Guys,
>> So Sorry about wasting your time with bad patchs.
>> I feel bad about that. I hope this patch is O.K.
>> now. :(
>
> Oh, one other thing...
>
>> > diff --git a/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c b/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
> []
>> > @@ -36,7 +36,6 @@ static bool fw_download_code(struct net_device *dev, u8 *code_virtual_address,
>> >                              u32 buffer_len)
>> >  {
>> >         struct r8192_priv *priv = rtllib_priv(dev);
>> > -       bool                rt_status = true;
>> >         u16                 frag_threshold;
>> >         u16                 frag_length, frag_offset = 0;
>> >         int                 i;
> []
>> > @@ -99,7 +100,7 @@ static bool fw_download_code(struct net_device *dev, u8 *code_virtual_address,
>> >
>> >         write_nic_byte(dev, TPPoll, TPPoll_CQ);
>> >
>> > -       return rt_status;
>> > +       return false;
>
> This should be:
>
>         return true;
>
>
>
