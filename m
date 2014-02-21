Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444AbaBUOPM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 09:15:12 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:61398 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192AbaBUOPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 09:15:09 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Alistair Popple <alistair@popple.id.au>
Cc: linux-mmc@vger.kernel.org, cjb@laptop.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 1/7] IBM Akebono: Add a SDHCI platform driver
Date: Fri, 21 Feb 2014 15:14:30 +0100
Message-ID: <1773685.WfxOP0FuHM@wuerfel>
User-Agent: KMail/4.11.3 (Linux/3.11.0-15-generic; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1392964293-13687-2-git-send-email-alistair@popple.id.au>
References: <1392964293-13687-1-git-send-email-alistair@popple.id.au> <1392964293-13687-2-git-send-email-alistair@popple.id.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:6OhmR0M3pnQvxaWOW2P+u/7uas6JJy5omUjqt2Tnq0h
 rgcL2aWeyUiozC+XcHsGKvp0avdd9UkXLpYLBJHfGXgI59klP0
 jC7IPCheRRPZ1fs9q3JjQL52RYnN12og1BlskSvMKrs7JDfUBd
 tIKG4ND4QdsAm3wiihk17pyGaKRAKDDeY3GhZmAp9po1i0Z4mg
 qay/7Pq9J3YKGBbkkeAjMMu3w18qHdf/5Wb2y7ABkOKTrR5zXb
 94Jjlmj9P1sOSCy/9fuyXid2By1rw+wC1Zx9n+kFQwiU0VJ125
 duxnf6fvUT7CrBrGUqCpPK8xuFnzL5djs7MQ+56gncE8Gjidmo
 Win4cCbeO57MjxCDFycs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 February 2014 17:31:27 Alistair Popple wrote:

>  
> +config MMC_SDHCI_OF_476GTR
> +	tristate "SDHCI OF support for the IBM PPC476GTR SoC"
> +	depends on MMC_SDHCI_PLTFM
> +	depends on PPC_OF
> +	help
> +	  This selects the Secure Digital Host Controller Interface (SDHCI)
> +	  found on the PPC476GTR SoC.
> +
> +	  If you have a controller with this interface, say Y or M here.
> +
> +	  If unsure, say N.

Your driver doesn't actually do anything beyond what is in the common
sdhci-pltfm.c infrastructure. IMHO you really shoulnd't need a SoC
specific abstraction for it at all and instead add a generic
platform driver registration into sdhci-pltfm.c. I'd suggest
you use "generic-sdhci" (similar to what we do for usb-ohci and usb-ehci
now) as the compatible string and change your device tree to claim
compatibility with that and your soc-specific string.

	Arnd
