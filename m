Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945901AbaDQNOD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 09:14:03 -0400
Received: from top.free-electrons.com ([176.31.233.9]:55643 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932081AbaDQNOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 09:14:01 -0400
Date: Thu, 17 Apr 2014 15:13:57 +0200
From: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: linus.walleij@linaro.org, alexandre.belloni@free-electrons.com,
        zmxu@marvell.com, jszhang@marvell.com,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 3/5] ARM: berlin: add the pinctrl dependency for
 the Marvell Berlin SoCs
Message-ID: <20140417131357.GA31034@kwain>
References: <1397135274-10764-1-git-send-email-antoine.tenart@free-electrons.com>
 <1397135274-10764-4-git-send-email-antoine.tenart@free-electrons.com>
 <5347B065.8060001@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5347B065.8060001@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastian,

On Fri, Apr 11, 2014 at 11:05:41AM +0200, Sebastian Hesselbarth wrote:
> On 04/10/2014 03:07 PM, Antoine Ténart wrote:
> >Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
> >---
> >  arch/arm/mach-berlin/Kconfig | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> >diff --git a/arch/arm/mach-berlin/Kconfig b/arch/arm/mach-berlin/Kconfig
> >index d3c5f14dc142..291f1cac6c3d 100644
> >--- a/arch/arm/mach-berlin/Kconfig
> >+++ b/arch/arm/mach-berlin/Kconfig
> >@@ -4,6 +4,8 @@ config ARCH_BERLIN
> >  	select GENERIC_IRQ_CHIP
> >  	select DW_APB_ICTL
> >  	select DW_APB_TIMER_OF
> >+	select PINCTRL
> >+	select PINCTRL_BERLIN
> 
> As said in the review of the previous patch, drop PINCTRL here
> and select it in the PINCTRL_BERLIN Kconfig. Also, you'll need
> PINCTRL_BERLIN_BG2 and PINCTRL_BERLIN_BG2Q as we don't want to
> bloat each Berlin kernel with both drivers.

Regarding PINCTRL, I can't drop it, pin-controller drivers depend on it.
drivers/pinctrl/Kconfig begins with:
	if PINCTRL

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
