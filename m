Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155AbaAHKT6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 05:19:58 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:60111 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbaAHKTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 05:19:55 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Roger Quadros <rogerq@ti.com>
Cc: bcousson@baylibre.com, tony@atomide.com, balbi@ti.com,
        linux-omap@vger.kernel.org, linux-usb@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, "Kristo, Tero" <t-kristo@ti.com>
Subject: Re: [PATCH v4 1/5] mfd: omap-usb-host: Update DT clock binding information
Date: Wed, 08 Jan 2014 11:19:28 +0100
Message-ID: <4812867.NuB3hNkV9d@wuerfel>
User-Agent: KMail/4.11 rc1 (Linux/3.10.0-5-generic; KDE/4.11.2; x86_64; ; )
In-Reply-To: <52CD23E0.8030400@ti.com>
References: <1389161742-10533-1-git-send-email-rogerq@ti.com> <20140108090808.GB16313@earth.universe> <52CD23E0.8030400@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:2S8FDdu/Uo0PSLHB14BgNZIqY144Rr13rbwmDesHX0U
 Fm/7TELq22krCMLr7Q060vW97eT50j1dGW2qhLlfGzWQbeBj+j
 l6PzADqT6UZJI7m83+mBPGFwerAF3oph9TMDYJmy9SzzoC8jxE
 iWSGW2sh3qjbdnG6PDIBOk5BZahm1ED5T4HZQ6CA9Ql767W5ew
 niqEZCnHzFSG679HQPPFMYaDSAESU5RIC04NCipDg3BetXwaaC
 LFqCTOJQAmo6aJVrXCNNei7U+RrKAmf+R/QhuHa/DQteFgqyBF
 8qnSOQRXaedBOnq33AzuoVMWkmt4WuyLu92MGf4gUvA2rNxbpK
 s3/+ivaqDshFB5XiiFXQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 January 2014 15:39:36 Roger Quadros wrote:
> > What about the other clocks acquired in drivers/mfd/omap-usb-host.c? Shouldn't
> > all of those be provided by via the DT phandle?
> > 
> 
> All those clocks are identically named across the OMAP SoCs and are unique for each
> SoC, so providing DT phandle for all of them is not required.
> 
> The init_60m_fclk was renamed to l3init_60m_fclk in OMAP5, and hence the need for
> this binding.

What do you mean it was renamed? Is it a different version of the omap-usb-host
device then?

> > Should the clk_get be changed to of_clk_get()/of_clk_get_by_name() in the
> > driver? This would potentially remove the need of the init_60m_fclk name.
> > 
> 
> If we use of_clk_xxx() then we'll need to update DT nodes for OMAP4 and OMAP3 as
> well to explicitly provide the clock phandle. For now we make use of the fact that
> SoC clock data names the clock rightly i.e. "init_60m_fclk".

I'm getting the feeling that init_60m_fclk is not the name of the clock input
of the omap-usb-host device at all, but rather the name of a signal on the
omap soc, which would not be an appropriate identifier for the binding.

	Arnd
