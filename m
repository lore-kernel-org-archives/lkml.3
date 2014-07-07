Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111AbaGGRkm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 13:40:42 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:33397 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbaGGRkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 13:40:41 -0400
MIME-Version: 1.0
In-Reply-To: <20140707081456.GH28884@atomide.com>
References: <1404493320-5606-1-git-send-email-xerofoify@gmail.com>
	<20140707081456.GH28884@atomide.com>
Date: Mon, 7 Jul 2014 13:40:40 -0400
Message-ID: <CAPDOMVjpqWL-BVUPKig+2d7921105A03c1BX6164RkC=vuXBGQ@mail.gmail.com>
Subject: Re: [PATCH] mach-omap1: Fix call to omap_cfg_reg
From: Nick Krause <xerofoify@gmail.com>
To: Tony Lindgren <tony@atomide.com>
Cc: balbi@ti.com, Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Tony,
This seems to be a false positive then.Please reply if it is so I can remove the
Fix me message.
Cheers Nick

On Mon, Jul 7, 2014 at 4:14 AM, Tony Lindgren <tony@atomide.com> wrote:
> * Nicholas Krause <xerofoify@gmail.com> [140704 10:03]:
>> This patch fixes the call to ompa_cfg_reg(USB2_SPEED) in the case
>> that the cpu is a omap16xx and the nwires are not equal to 3.
>
> This is most likely unsafe to do as the pin is probably
> shared with some other device and we have to rely for
> the bootloader to do the right thing for the board.
>
> Regards,
>
> Tony
>
>> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
>> ---
>>  arch/arm/mach-omap1/usb.c | 3 +--
>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/arch/arm/mach-omap1/usb.c b/arch/arm/mach-omap1/usb.c
>> index 4118db5..17e3139 100644
>> --- a/arch/arm/mach-omap1/usb.c
>> +++ b/arch/arm/mach-omap1/usb.c
>> @@ -504,8 +504,7 @@ static u32 __init omap1_usb2_init(unsigned nwires, unsigned alt_pingroup)
>>               omap_cfg_reg(W9_USB2_TXEN);
>>               omap_cfg_reg(W5_USB2_SE0);
>>               if (nwires != 3)
>> -                     omap_cfg_reg(Y5_USB2_RCV);
>> -             // FIXME omap_cfg_reg(USB2_SPEED);
>> +                     omap_cfg_reg(USB2_SPEED)
>>       } else {
>>               pr_debug("usb%d cpu unrecognized\n", 1);
>>               return 0;
>> --
>> 1.9.1
>>
