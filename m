Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbaJUFtZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 01:49:25 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:59437 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbaJUFtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 01:49:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Scott Branden <sbranden@broadcom.com>
Cc: Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        bcm-kernel-feedback-list@broadcom.com,
        Mike Turquette <mturquette@linaro.org>, Alex Elder <elder@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Antti Palosaari <crope@iki.fi>, JD Zheng <jdzheng@broadcom.com>,
        Ray Jui <rjui@broadcom.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Jonathan Richardson <jonathar@broadcom.com>
Subject: Re: [PATCH v5 1/6] ARM: cygnus: Initial support for Broadcom Cygnus SoC
Date: Tue, 21 Oct 2014 07:48:37 +0200
Message-ID: <38587325.kaAxCWAsmL@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <544593E1.90608@broadcom.com>
References: <1413341936-17606-2-git-send-email-sbranden@broadcom.com> <4779079.vI0gT0iWvg@wuerfel> <544593E1.90608@broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:FqyHP/r5jyv3bTOBN4q9/EnXjsCwrj08VpwU3I1CqJR
 gNJ5UWsYN8PfpxPpizbimuiHanHbvinVdEmyZoSbTGn6Chbauw
 QHEGSjE6pejtArDeQAzZK+IEowYUH8TwKsfI4W8XZUb1FzwAwK
 EeeuitapLjjmCYKYYMwNPcvmhcrkbYE+SQfWZ36AN7rgNo/Ezq
 fotSlgQ2hkKMzvAy42HImsBHLFDBhXtqsygXorKTbNF0u6/IPx
 n1zmhgCqa+ddZ2Z3UnyDxQDz0vKurcT9wCCe+T8u4RzVWpdomY
 S75pOKSh7MhXY3qo7WNekHuHn1NNRZEsTtcroHIH9XbP2AOTa4
 Xop8qRJN59ty1wgdx4JQ=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 20 October 2014 15:59:45 Scott Branden wrote:
> On 14-10-20 12:55 PM, Arnd Bergmann wrote:
> > On Tuesday 14 October 2014 19:58:51 Scott Branden wrote:
> >>   if ARCH_BCM
> >>
> >> +menu "iProc SoC based Machine types"
> >> +       config ARCH_BCM_IPROC
> >> +               bool
> >> +               select ARM_GIC
> >> +               select CACHE_L2X0
> >> +               select HAVE_ARM_SCU if SMP
> >> +               select HAVE_ARM_TWD if SMP
> >> +               select ARM_GLOBAL_TIMER
> >> +
> >> +               select CLKSRC_MMIO
> >> +               select ARCH_REQUIRE_GPIOLIB
> >> +               select ARM_AMBA
> >> +               select PINCTRL
> >> +               help
> >> +                 This enables support for systems based on Broadcom IPROC architected SoCs.
> >> +                 The IPROC complex contains one or more ARM CPUs along with common
> >> +                 core periperals. Application specific SoCs are created by adding a
> >> +                 uArchitecture containing peripherals outside of the IPROC complex.
> >> +                 Currently supported SoCs are Cygnus.
> >> +
> >> +       config ARCH_BCM_CYGNUS
> >> +               bool "Broadcom Cygnus Support" if ARCH_MULTI_V7
> >
> > You still have a three-level menu structure. Please fix.
> 
> Hi Arnd, we have ARCH_BCM->ARCH_BCM_CYGNUS.
> 
> ARCH_BCM_IPROC is silent and selected by ARCH_BCM_CYGNUS.  This was the 
> change made between v3 and v5.
> 
> Is there something else to be done here?
> 

You have

	"Broadcom SoC Support" 
		"iProc SoC based Machine types"
			 "Broadcom Cygnus Support"

Get rid of one of them.

	Arnd
