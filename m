Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965920AbaKNPdr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 10:33:47 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:59007 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965593AbaKNPdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 10:33:44 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Antoine Tenart <antoine.tenart@free-electrons.com>
Cc: sebastian.hesselbarth@gmail.com, Peter.Chen@freescale.com, balbi@ti.com,
        p.zabel@pengutronix.de, alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 03/13] ARM: Berlin: select the reset controller
Date: Fri, 14 Nov 2014 16:33:27 +0100
Message-ID: <3287202.nx0cnO5WUI@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1415978763-27345-4-git-send-email-antoine.tenart@free-electrons.com>
References: <1415978763-27345-1-git-send-email-antoine.tenart@free-electrons.com> <1415978763-27345-4-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:beMzQsEh8aI73nPiyL0fvVuOSdkBAFuQDCMcnl+SeF6
 ovobm8nlYRffoL2SJRL5nk3wi5IR8RsQB/9VcFRY+8FZDvu4M1
 gcm6+tadsNOFI8wLYdlmPRetiFDUxzTzPmsPjllRUHdea94pgv
 +EoMHXvViLiGISI3mf1Z2LI49s2AajNHxlo3FitAy8HVGPd+F4
 OY86Zlq3GXpdGsEYF1vc9mVcTvHuBdlwFQ6tr/RtFhDKlOyINS
 XZa79ts/5psOaRFfL1SBAiGW1Ou1tqKKvxYJhexw5J96CZpkFY
 xoo1j4wDV4hk/3qncVOdAbaCNc0yi+E4QuJ89satWiXDNTOspU
 oAdJXeT3HErYwY013j44=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 November 2014 16:25:53 Antoine Tenart wrote:
>  menuconfig ARCH_BERLIN
>         bool "Marvell Berlin SoCs" if ARCH_MULTI_V7
> +       select ARCH_HAS_RESET_CONTROLLER
>         select ARCH_REQUIRE_GPIOLIB
>         select ARM_GIC
>         select GENERIC_IRQ_CHIP
>         select DW_APB_ICTL
>         select DW_APB_TIMER_OF
>         select PINCTRL
> +       select RESET_CONTROLLER

RESET_CONTROLLER is meant to be user-selectable, don't add a 'select' here,
but instead make the driver 'depends on RESET_CONTROLLER'.

	Arnd
