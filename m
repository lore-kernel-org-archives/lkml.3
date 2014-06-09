Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100AbaFISJI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 14:09:08 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:51626 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758AbaFISJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 14:09:04 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Andrew Bresticker <abrestic@chromium.org>,
        Inderpal Singh <inderpal.s@samsung.com>,
        Thomas Abraham <thomas.ab@samsung.com>, olof@lixom.net,
        Tushar Behera <trblinux@gmail.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        linux-samsung-soc@vger.kernel.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ARM: EXYNOS: mcpm: Don't rely on firmware's secondary_cpu_start
References: <1402090985-8061-1-git-send-email-dianders@chromium.org>
	<1402096465-13218-1-git-send-email-dianders@chromium.org>
Date: Mon, 09 Jun 2014 11:09:02 -0700
In-Reply-To: <1402096465-13218-1-git-send-email-dianders@chromium.org> (Doug
	Anderson's message of "Fri, 6 Jun 2014 16:14:25 -0700")
Message-ID: <7htx7uq7k1.fsf@paris.lan>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doug Anderson <dianders@chromium.org> writes:

> On exynos mcpm systems the firmware is hardcoded to jump to an address
> in SRAM (0x02073000) when secondary CPUs come up.  By default the
> firmware puts a bunch of code at that location.  That code expects the
> kernel to fill in a few slots with addresses that it uses to jump back
> to the kernel's entry point for secondary CPUs.
>
> Originally (on prerelease hardware) this firmware code contained a
> bunch of workarounds to deal with boot ROM bugs.  However on all
> shipped hardware we simply use this code to redirect to a kernel
> function for bringing up the CPUs.
>
> Let's stop relying on the code provided by the bootloader and just
> plumb in our own (simple) code jump to the kernel.  This has the nice
> benefit of fixing problems due to the fact that older bootloaders
> (like the one shipped on the Samsung Chromebook 2) might have put
> slightly different code into this location.
>
> Once suspend/resume is implemented for systems using exynos-mcpm we'll
> need to make sure we reinstall our fixed up code after resume.  ...but
> that's not anything new since IRAM (and thus the address of the
> mcpm_entry_point) is lost across suspend/resume anyway.
>
> Signed-off-by: Doug Anderson <dianders@chromium.org>

Acked-by: Kevin Hilman <khilman@linaro.org>
Tested-by: Kevin Hilman <khilman@linaro.org>

I confirm that this patch (plus the enable CCI hack[1]) allows me to see
all 8 cores when booting linux-next on my Chromebook2.

Kevin

[1] While waiting for the forth-coming patch from Andrew to enable the
    CCI port for the boot cluster), I do this from u-boot before starting
    the kernel (based on earlier email from Doug):

    mw.l 10d25000 3  # Enable CCI from U-Boot
