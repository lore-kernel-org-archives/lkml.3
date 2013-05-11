Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751376Ab3EKE20 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 00:28:26 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:54041 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888Ab3EKE2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 00:28:24 -0400
Message-ID: <518DC8E6.5000606@nvidia.com>
Date: Fri, 10 May 2013 22:28:22 -0600
From: Stephen Warren <swarren@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Christian Daudt <csd@broadcom.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>, Chris Ball <cjb@laptop.org>,
        Olof Johansson <olof@lixom.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wei WANG <wei_wang@realsil.com.cn>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Arnd Bergmann <arnd@arndb.de>, "Mike A. Chan" <mikechan@google.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mmc@vger.kernel.org, csd_b@daudt.org
Subject: Re: [PATCH] ARM: mmc: bcm281xx SDHCI driver
References: <1368078942-31265-1-git-send-email-csd@broadcom.com>
In-Reply-To: <1368078942-31265-1-git-send-email-csd@broadcom.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2013 11:55 PM, Christian Daudt wrote:
> Add SDHCI driver for the Broadcom 281xx SoCs. Also
> add bindings for it into bcm281xx dts files.
> Still missing:
>  - power managemement

> diff --git a/drivers/mmc/host/sdhci-bcm-kona.c b/drivers/mmc/host/sdhci-bcm-kona.c

> +	/*
> +	 * Back-to-Back register write needs a delay of 1ms at bootup (min 10uS)
> +	 * Back-to-Back writes to same register needs delay when SD bus clock
> +	 * is very low w.r.t AHB clock, mainly during boot-time and during card
> +	 * insert-removal.
> +	 */
> +	udelay(1000);
> +	sdhci_writel(host, val, KONA_SDHOST_CORECTRL);

This sounds very similar to the workaround in
drivers/mmc/host/sdhci-bcm2835.c. Is this the same IP block supported by
that driver? Perhaps not, since bcm2835 apparently needs other WARs such
as always using 32-bit IO and hence needing custom read/write w/b
functions to do read-modify-write which isn't here?
