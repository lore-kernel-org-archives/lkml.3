Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910AbaDWQAO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 12:00:14 -0400
Received: from moutng.kundenserver.de ([212.227.17.13]:56132 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754479AbaDWQAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 12:00:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: wim@iguana.be, dbaryshkov@gmail.com, dwmw2@infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH 3/5] ARM: sunxi: Select restart drivers
Date: Wed, 23 Apr 2014 18:00:03 +0200
Message-ID: <5061177.3hiLYCoYmE@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1398265476-29373-4-git-send-email-maxime.ripard@free-electrons.com>
References: <1398265476-29373-1-git-send-email-maxime.ripard@free-electrons.com> <1398265476-29373-4-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:8Dt86Xnbwlt+09qrk+jCVUsFOkaXDT5jT8OtVR1VyAR
 GZhCjkZBCCwEcdKWrbAtUsRq62eTNEAuylhZrMfaZ07khcf3RH
 38v63bA91Pcb85On36jHnbx6YV6OI9ab/A++fPcCpb01svfFPY
 NqAG3M4uwB7dcGkZfIq9yuJu7PhzGJAjLB0XztlrMCPaqR/DKq
 c8rbeOsFPEANoFDPlEtAb4nVwoLX/M6aR5uUzVqX+/B34c0Ezv
 hBONFgDx3wYpcdT1kIMo8BlxEt4HkDWxsx/zgrBjSPYhin3c5W
 Aq1kN7pKHR+xGbf2kLUKlD5nLPNVWC7pdt/6QimiviaWbKH9KA
 W7D2kR5jIjXem/sa9wVQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 April 2014 17:04:34 Maxime Ripard wrote:
> Make sure we have the restart hooks in the kernel by selecting them in Kconfig.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>  arch/arm/mach-sunxi/Kconfig | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/arm/mach-sunxi/Kconfig b/arch/arm/mach-sunxi/Kconfig
> index b57d7d53b9d3..5fe80cc9b524 100644
> --- a/arch/arm/mach-sunxi/Kconfig
> +++ b/arch/arm/mach-sunxi/Kconfig
> @@ -9,6 +9,10 @@ config ARCH_SUNXI
>         select HAVE_ARM_ARCH_TIMER
>         select PINCTRL
>         select PINCTRL_SUNXI
> +       select POWER_RESET
> +       select POWER_RESET_SUN6I
> +       select POWER_SUPPLY
>         select RESET_CONTROLLER
>         select SUN4I_TIMER
>         select SUN5I_HSTIMER
> +       select SUNXI_WATCHDOG

I think you can't select SUNXI_WATCHDOG without also selecting WATCHDOG
first. I would prefer not to do that however, and leave it up to the
defconfig to enable it, loading the reset/watchdog driver as a module
seems entirely reasonable in a multiplatform distro kernel.

	Arnd
