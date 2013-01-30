Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab3A3Jdi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 04:33:38 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:58158 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552Ab3A3Jde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 04:33:34 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Matt Porter <mporter@ti.com>
Subject: Re: [PATCH v6 03/10] ARM: edma: add AM33XX support to the private EDMA API
Date: Wed, 30 Jan 2013 09:32:58 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-1-generic; KDE/4.3.2; x86_64; ; )
Cc: Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Chris Ball <cjb@laptop.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Dan Williams <djbw@fb.com>, Rob Herring <rob.herring@calxeda.com>,
        Padma Venkat <padma.kvr@gmail.com>
References: <1359529229-22207-1-git-send-email-mporter@ti.com> <1359529229-22207-4-git-send-email-mporter@ti.com>
In-Reply-To: <1359529229-22207-4-git-send-email-mporter@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301300932.58732.arnd@arndb.de>
X-Provags-ID: V02:K0:Hwa28OO2Dsss6knu5+4+3ZiFaW1pQr3bbAl61JwqUUM
 ec07xmDaftZhsrDFuZaFOR8MJu7mrHQxEpZAjsqMBLEb7RO7/g
 TITZuiXTYzf3X/BsGQFcA+ZVYkkk+aOuF4av6trcP1TvXidAtJ
 3YNc44PjqsTn4Fso6yJPae0FWKQ6s/llpKqC4ZCyIBnZm3ze1Z
 KKm/MLv72gPr5TMZKt1m9NCooQakzv1Xpzgw3pm2b+wQg/3tEu
 0f6TrIugoO58Wp7JGqwL+DU6Wztx8LK3o0IjOdiMB91HTkygGu
 NiczXQidtqTAJ2w/HiZTVu3CVHuRb0wIC1ewOUcznQ3+ZmCmtb
 +L7Hy5Bhk9eo9JXi3cWg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 January 2013, Matt Porter wrote:
> +               dma_cap_set(DMA_SLAVE, edma_filter_info.dma_cap);
> +               of_dma_controller_register(dev->of_node,
> +                                          of_dma_simple_xlate,
> +                                          &edma_filter_info);
> +       }

How do you actually deal with the problem mentioned by Padma, that
the filter function does not know which edma instance it is looking
at? If you assume that there can only be a single edma instance in
the system, that is probably a limitation that should be documented
somewhere, and ideally the probe() function should check for that.

	Arnd
