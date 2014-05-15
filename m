Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848AbaEOSEc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 14:04:32 -0400
Received: from mail-qg0-f51.google.com ([209.85.192.51]:48491 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811AbaEOSEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 14:04:30 -0400
MIME-Version: 1.0
In-Reply-To: <1400176691-26058-3-git-send-email-elder@linaro.org>
References: <1400176691-26058-1-git-send-email-elder@linaro.org> <1400176691-26058-3-git-send-email-elder@linaro.org>
From: Florian Fainelli <f.fainelli@gmail.com>
Date: Thu, 15 May 2014 11:03:49 -0700
Message-ID: <CAGVrzca20+3kmJjyGv8Pr-qNNV4n0hhADL6GWvcYVDUL4q28Hg@mail.gmail.com>
Subject: Re: [PATCH v3 RESEND 2/5] ARM: add SMP support for Broadcom mobile SoCs
To: Alex Elder <elder@linaro.org>
Cc: Matt Porter <mporter@linaro.org>, Christian Daudt <bcm@fixthebug.org>,
        Russell King <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, sboyd@codeaurora.org,
        bcm-kernel-feedback-list@broadcom.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex,

2014-05-15 10:58 GMT-07:00 Alex Elder <elder@linaro.org>:
> This patch adds SMP support for BCM281XX and BCM21664 family SoCs.
>
> This feature is controlled with a distinct config option such that a
> SMP-enabled multi-v7 binary can be configured to run these SoCs in
> uniprocessor mode.  Since this SMP functionality is used for
> multiple Broadcom mobile chip families the config option is called
> ARCH_BCM_MOBILE_SMP (for lack of a better name).
>
> On SoCs of this type, the secondary core is not held in reset on
> power-on.  Instead it loops in a ROM-based holding pen.  To release
> it, one must write into a special register a jump address whose
> low-order bits have been replaced with a secondary core's id, then
> trigger an event with SEV.  On receipt of an event, the ROM code
> will examine the register's contents, and if the low-order bits
> match its cpu id, it will clear them and write the value back to the
> register just prior to jumping to the address specified.
>
> The location of the special register is defined in the device tree
> using a "secondary-boot-reg" property in a node whose "enable-method"
> matches.
>
> Derived from code originally provided by Ray Jui <rjui@broadcom.com>
>
> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
>  arch/arm/mach-bcm/Kconfig   |  18 +++-
>  arch/arm/mach-bcm/Makefile  |   3 +
>  arch/arm/mach-bcm/platsmp.c | 201 ++++++++++++++++++++++++++++++++++++++++++++

Could we make that name a little bit more specific to the mobile SoCs?
There are other BCM SoCs either currently supported in this directory
(BCM5310X), or making their way to be supported (brcmstb, bcm63xx),
and those share nothing with the Mobile SoC SMP code.

Maybe we should create another level directory within mach-bcm...
-- 
Florian
