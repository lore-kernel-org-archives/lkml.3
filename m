Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932Ab3LCJUL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 04:20:11 -0500
Received: from mail-oa0-f44.google.com ([209.85.219.44]:54266 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217Ab3LCJUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 04:20:02 -0500
MIME-Version: 1.0
In-Reply-To: <CAAfyv37Vie1vZK2XQ1cfVq6eVnSuaBLfykk6pU8fwEyqvPF4BA@mail.gmail.com>
References: <1386059589-4030-1-git-send-email-marek.belisko@open-nandra.com>
	<529D9D43.6040101@ti.com>
	<CAAfyv37Vie1vZK2XQ1cfVq6eVnSuaBLfykk6pU8fwEyqvPF4BA@mail.gmail.com>
Date: Tue, 3 Dec 2013 10:20:00 +0100
Message-ID: <CAAfyv35gVVNydrk8vifSyidpFjEXjGiT4-i2dgN5Un2=FuHaqQ@mail.gmail.com>
Subject: Re: [PATCH] omap: twl-common: Fix musb-hdrc device name.
From: Belisko Marek <marek.belisko@gmail.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Tony Lindgren <tony@atomide.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 3, 2013 at 10:08 AM, Belisko Marek <marek.belisko@gmail.com> wrote:
> Hi,
>
> On Tue, Dec 3, 2013 at 9:58 AM, Kishon Vijay Abraham I <kishon@ti.com> wrote:
>> Hi,
>>
>> On Tuesday 03 December 2013 02:03 PM, Marek Belisko wrote:
>>> Without this change when booting omap3 device (gta04) with board file
>>> leads to follwing errors:
>>>
>>> [    1.203308] musb-hdrc musb-hdrc.0.auto: unable to find phy
>>> [    1.209075] HS USB OTG: no transceiver configured
>>> [    1.214019] musb-hdrc musb-hdrc.0.auto: musb_init_controller failed with status -517
>>>
>>> and usb isn't working.
>>>
>>> This is probably regression caused by commit: 6c27f939
>>
>> I think a better fix would be to have this merged..
>> https://lkml.org/lkml/2013/7/26/91
> Yes I see but how this could help with current situation? Ho you then
> specify device number?
I was too fast with reply sorry. I can see whole series and it is of
course correct solution. But as I said
can we except to be merged to 3.13. If not Tony can you pick my patch.

> This patch is fixing 3.13-rcx regression.
>
>>>
>>> Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
>>> ---
>>>  arch/arm/mach-omap2/twl-common.c |    2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/arch/arm/mach-omap2/twl-common.c b/arch/arm/mach-omap2/twl-common.c
>>> index b0d54da..3640ce0 100644
>>> --- a/arch/arm/mach-omap2/twl-common.c
>>> +++ b/arch/arm/mach-omap2/twl-common.c
>>> @@ -92,7 +92,7 @@ void __init omap_pmic_late_init(void)
>>>
>>>  #if defined(CONFIG_ARCH_OMAP3)
>>>  struct phy_consumer consumers[] = {
>>> -     PHY_CONSUMER("musb-hdrc.0", "usb"),
>>> +     PHY_CONSUMER("musb-hdrc.0.auto", "usb"),
>>
>> the index '0' might vary for some boards leading it to again break musb.
> If you run grep for musb-hdrc :
> arch/arm/mach-omap2/board-3430sdp.c: usb_bind_phy("musb-hdrc.0.auto",
> 0, "twl4030_usb");
> arch/arm/mach-omap2/board-devkit8000.c:
> usb_bind_phy("musb-hdrc.0.auto", 0, "twl4030_usb");
> arch/arm/mach-omap2/board-overo.c: usb_bind_phy("musb-hdrc.0.auto", 0,
> "twl4030_usb");
> arch/arm/mach-omap2/board-omap3beagle.c:
> usb_bind_phy("musb-hdrc.0.auto", 0, "twl4030_usb");
> arch/arm/mach-omap2/board-omap3touchbook.c:
> usb_bind_phy("musb-hdrc.0.auto", 0, "twl4030_usb");
> arch/arm/mach-omap2/board-cm-t35.c: usb_bind_phy("musb-hdrc.0.auto",
> 0, "twl4030_usb");
> arch/arm/mach-omap2/board-omap3stalker.c:
> usb_bind_phy("musb-hdrc.0.auto", 0, "twl4030_usb");
> arch/arm/mach-omap2/board-omap3logic.c:
> usb_bind_phy("musb-hdrc.0.auto", 0, "twl4030_usb");
> arch/arm/mach-omap2/board-2430sdp.c: usb_bind_phy("musb-hdrc.0.auto",
> 0, "twl4030_usb");
> arch/arm/mach-omap2/board-ldp.c: usb_bind_phy("musb-hdrc.0.auto", 0,
> "twl4030_usb");
> arch/arm/mach-omap2/board-rx51.c: usb_bind_phy("musb-hdrc.0.auto", 0,
> "twl4030_usb");
> arch/arm/mach-omap2/board-omap3pandora.c:
> usb_bind_phy("musb-hdrc.0.auto", 0, "twl4030_usb");
>
> Until mentioned patch isn't merged and PHY_CONSUMER isn't updated I
> think this is correct solution.
>>
>> Thanks
>> Kishon
>
> BR,
>
> marek
>
> --
> as simple and primitive as possible
> -------------------------------------------------
> Marek Belisko - OPEN-NANDRA
> Freelance Developer
>
> Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
> Tel: +421 915 052 184
> skype: marekwhite
> twitter: #opennandra
> web: http://open-nandra.com

BR,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
twitter: #opennandra
web: http://open-nandra.com
