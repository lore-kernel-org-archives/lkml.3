Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340AbaE0Nh3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 09:37:29 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:54049 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019AbaE0Nh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 09:37:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, Paul Bolle <pebolle@tiscali.nl>,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        spear-devel@list.st.com, linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH v5 3/5] ARM: Conceal DEBUG_LL_UART_NONE from unsupported platforms
Date: Tue, 27 May 2014 15:37:12 +0200
Message-ID: <8143025.UYbkItXldM@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53848F7C.6020508@linaro.org>
References: <1398355246-29571-1-git-send-email-daniel.thompson@linaro.org> <6624276.NBS809VbNB@wuerfel> <53848F7C.6020508@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:j9MteLcMT0D0IoZra3mVhP1Zx4QWlonqHAbL1sdO3H1
 AtJe44tCNv8e4erChiyJMCGINCgvDXmuGUIyHWjeSTiu5AIGyl
 vEnyW7DdTkxw4nUdyUM04XzwbRHAdd/zoMsE2TtEzPe9yyim5x
 h5JNJiz+5kTlw77mLWsVYi5zWjAKu8eeExfNTq+LQor3yQDJ4u
 J1AMLRt7vWrVCszMlSGgaqjdcPJjbqfddNOjAmF3UxDtq59gsV
 lYWq5YiaJ83Zp7j5g8Oiak7kVAw7Tif2M/kr9XjnOd5qlMFCLR
 fNYDTTKOKXPzpWJd7Z8aJZcxlgbrfwlNh7OwtP7NtenvhndvRO
 Wl2eyzzkrVY91w04BUBY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 May 2014 14:13:32 Daniel Thompson wrote:
> On 26/05/14 14:39, Arnd Bergmann wrote:
> >>> diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
> >>> index eab8ecb..4c8d7db 100644
> >>> --- a/arch/arm/Kconfig.debug
> >>> +++ b/arch/arm/Kconfig.debug
> >>> @@ -842,7 +842,18 @@ choice
> >>>  
> >>>       config DEBUG_LL_UART_NONE
> >>>               bool "No low-level debugging UART"
> >>> -             depends on !ARCH_MULTIPLATFORM
> >>> +             depends on ARCH_AT91 || \
> >>> +                     ARCH_CLPS711X || \
> >>> +                     ARCH_FOOTBRIDGE || \
> >>> +                     ARCH_KS8695 || \
> >>> +                     ARCH_NETX || \
> >>> +                     ARCH_OMAP1 || \
> >>> +                     ARCH_SA1100 || \
> >>> +                     ARCH_S3C24XX || \
> >>> +                     ARCH_S3C64XX || \
> >>> +                     ARCH_S5P64X0 || \
> >>> +                     ARCH_S5PC100 || \
> >>> +                     ARCH_S5PV210
> >>>               help
> >>>                 Say Y here if your platform doesn't provide a UART option
> >>>                 above. This relies on your platform choosing the right UART
> >>
> >> ARCH_S3C24XX has been moved over in linux-next to use debug/s3c24xx.S.
> >> A few others will likely move soon (AT91, CLPS711x, S5PV210), as the
> >> platforms get moved to ARCH_MULTIPLATFORM.
> 
> The list in my patch came from:
> 
> sundance$ find arch/arm -name "debug-macro.S"
> arch/arm/mach-at91/include/mach/debug-macro.S
> arch/arm/mach-clps711x/include/mach/debug-macro.S
> arch/arm/mach-footbridge/include/mach/debug-macro.S
> arch/arm/mach-ks8695/include/mach/debug-macro.S
> arch/arm/mach-netx/include/mach/debug-macro.S
> arch/arm/mach-omap1/include/mach/debug-macro.S
> arch/arm/mach-s3c64xx/include/mach/debug-macro.S
> arch/arm/mach-s5p64x0/include/mach/debug-macro.S
> arch/arm/mach-s5pc100/include/mach/debug-macro.S
> arch/arm/mach-s5pv210/include/mach/debug-macro.S
> arch/arm/mach-sa1100/include/mach/debug-macro.S
> 
> In other words this patch lists of all platforms where
> DEBUG_LL_UART_NONE should not result in failure to compile the kernel.

I see the same list, this is only half the story though.

> This list doesn't seem to have changed in linux-next.
> 
> >> As an alternative to your patch, we could decide to move the remaining
> >> files as well.
> > 
> > Follow-up: I also noticed that AT91, CLPS711X, FOOTBRIDGE and all the SAMSUNG
> > platforms already have an entry in the list, so DEBUG_LL_UART_NONE is redundant
> > for them. The below change should be enough.
> > 
> > For AT91 this is actually better because the old AT91X40 support doesn't
> > have working DEBUG_LL support. This gets handled correctly by 
> > AT91_DEBUG_LL_DBGU0/AT91_DEBUG_LL_DBGU1, but not DEBUG_LL_UART_NONE.
> 
> I'm very happy to update my patch to follow this one. However since it
> will render the corresponding debug-macro.S unreachable by KBuild I like
> to nuke the file as well. Good idea?

No. See the description under config DEBUG_LL_UART_NONE:

                  Say Y here if your platform doesn't provide a UART option
                  above. This relies on your platform choosing the right UART
                  definition internally in order for low-level debugging to
                  work.

The platforms I listed do have "a UART option above", e.g.

        config AT91_DEBUG_LL_DBGU0
                bool "Kernel low-level debugging on rm9200, 9260/9g20, 9261/9g10 and 9rl"
                depends on HAVE_AT91_DBGU0

Most of the platforms that have an option like this put the file into
include/debug, as is required for ARCH_MULTIPLATFORM. The ones that are
not converted to ARCH_MULTIPLATFORM can have it in either place, see

config DEBUG_LL_INCLUDE
        string
        default "debug/8250.S" if DEBUG_LL_UART_8250 || DEBUG_UART_8250
        default "debug/pl01x.S" if DEBUG_LL_UART_PL01X || DEBUG_UART_PL01X
	...
        default "debug/zynq.S" if DEBUG_ZYNQ_UART0 || DEBUG_ZYNQ_UART1
        default "mach/debug-macro.S"

Anything that is not explicitly listed under DEBUG_LL_INCLUDE will default
to "mach/debug-macro.S", and the list does not (have to) match the choice
statements in "Kernel low-level debugging port".

	Arnd
