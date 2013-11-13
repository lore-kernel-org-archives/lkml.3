Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751220Ab3KMViV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 16:38:21 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:36555 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895Ab3KMViM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 16:38:12 -0500
MIME-Version: 1.0
In-Reply-To: <20131106110518.6806.79333.sendpatchset@w520>
References: <20131106110508.6806.48070.sendpatchset@w520>
	<20131106110518.6806.79333.sendpatchset@w520>
Date: Wed, 13 Nov 2013 13:38:11 -0800
X-Google-Sender-Auth: 3tqVBIKO-3EruVrejpDEmyama24
Message-ID: <CANcMJZDJPbctuYgG0Wr64htUeak-XLf3EYK0vz-BbG320UkFGg@mail.gmail.com>
Subject: Re: [PATCH v2 01/03] clocksource: Add Kconfig entries for CMT, MTU2,
 TMU and STI
From: John Stultz <john.stultz@linaro.org>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        khilman@linaro.org, arnd@arndb.de, linux-sh@vger.kernel.org,
        daniel.lezcano@linaro.org, horms@verge.net.au, olof@lixom.net,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 6, 2013 at 3:05 AM, Magnus Damm <magnus.damm@gmail.com> wrote:
> From: Magnus Damm <damm@opensource.se>
>
> Add Kconfig entries for CMT, MTU2, TMU and STI to
> drivers/clocksource/Kconfig. This will allow us to
> get rid of duplicated entires in architecture code
> such as arch/sh and arch/arm/mach-shmobile.
>
> Signed-off-by: Magnus Damm <damm@opensource.se>
> ---
>
>  drivers/clocksource/Kconfig |   30 ++++++++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
>
> --- 0001/drivers/clocksource/Kconfig
> +++ work/drivers/clocksource/Kconfig    2013-11-05 19:49:47.000000000 +0900
> @@ -110,3 +110,33 @@ config VF_PIT_TIMER
>         bool
>         help
>           Support for Period Interrupt Timer on Freescale Vybrid Family SoCs.
> +
> +if COMPILE_TEST || ARM || SUPERH
> +menu "Timer drivers"
> +
> +config SH_TIMER_CMT
> +       bool "CMT timer driver"
> +       default y if ARM || (SUPERH && SYS_SUPPORTS_CMT)
> +       help
> +         This enables build of the CMT timer driver.
> +
> +config SH_TIMER_MTU2
> +       bool "MTU2 timer driver"
> +       default y if ARM || (SUPERH && SYS_SUPPORTS_MTU2)
> +       help
> +         This enables build of the MTU2 timer driver.
> +
> +config SH_TIMER_TMU
> +       bool "TMU timer driver"
> +       default y if ARM || (SUPERH && SYS_SUPPORTS_TMU)
> +       help
> +         This enables build of the TMU timer driver.
> +
> +config EM_TIMER_STI
> +       bool "STI timer driver"
> +       default y if ARM
> +       help
> +         This enables build of the STI timer driver.


So since I do want to avoid adding user-selectable configs if
possible, here are some concrete thoughts on this patch, trying to
provide an example from my more abstract rants down thread. :)

1) Why does the user have to chose something here?  Can the option be
set based on other platform details?

2) The help text for these options are basically tautological and
could be better. Consider what is it that your really asking the user
to decide here? What tradeoffs do they have to consider?  What is the
actual hardware here? CMT/TMU/MTU2/STI? This is just acronym soup.
These should be included in the help text.

3) If all of these options are disabled, will the affected system boot?

4) Do you have a list of systems that actually use these drivers? Can
you be any more restrictive then config ARM?

thanks
-john
