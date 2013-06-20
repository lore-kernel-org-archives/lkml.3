Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965293Ab3FTKRd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 06:17:33 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:53304 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964966Ab3FTKRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 06:17:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH V6 3/3] ARM: dts: Add pcie controller node for Samsung EXYNOS5440 SoC
Date: Thu, 20 Jun 2013 12:16:36 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "'Tomasz Figa'" <tomasz.figa@gmail.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        linux-samsung-soc@vger.kernel.org, linux-pci@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Andrew Murray'" <andrew.murray@arm.com>,
        "'Thomas Petazzoni'" <thomas.petazzoni@free-electrons.com>,
        "'Thierry Reding'" <thierry.reding@avionic-design.de>,
        "'Jason Gunthorpe'" <jgunthorpe@obsidianresearch.com>,
        "'Surendranath Gurivireddy Balla'" <suren.reddy@samsung.com>,
        "'Siva Reddy Kallam'" <siva.kallam@samsung.com>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>
References: <00c201ce6d85$83b072a0$8b1157e0$@samsung.com> <3250954.dVh4O1LchK@flatron> <00c501ce6d8f$af1bf900$0d53eb00$@samsung.com>
In-Reply-To: <00c501ce6d8f$af1bf900$0d53eb00$@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306201216.37248.arnd@arndb.de>
X-Provags-ID: V02:K0:wSqllInhZV2F7/RULYMUHsAJf04LFIzVDQsNIzHiO8P
 mLf43tewiU00zr9un9upm/DL4q2l4FWBFFc0yrBT8kE2/Q0Pam
 Zh0/v/vIJ6jeyV47LJI/pT29unXiEi+M9jRPDmlf9d0ojd072x
 tD/ppd+wCoshOgdGDsLbaBg5CRqGzbl7vWgRHXkGvNYP1bZF9E
 Ho3M1RXBF/bUgMF5jiAToxTAMb93JN6deTyXoDoIo0WHW+Lwa3
 MwU7bGkdbpXoyg5fyzAz4jroeQ3Pko1bCF/j2CXsM+YBRBKQyy
 1HtBD6nAkLUr1HkH6vkJbn89geMqkFhQyBrLDYW2dIIfdTGhLS
 vhH8SdmMT6cb0VU28rb8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 June 2013, Jingoo Han wrote:
> 2. patch adding label to the pinctrl node (which is a prerequisite) and
>     board-specific properties of PCIe nodes.
>    [PATCH] ARM: dts: Add pcie controller node for exynos5440-ssdk5440
> 
> arch/arm/boot/dts/exynos5440-ssdk5440.dts
> +
> +       pcie0@290000 {
> +               reset-gpio = <&pin_ctrl 5 0>;
> +       };
> +
> +       pcie1@2a0000 {
> +               reset-gpio = <&pin_ctrl 22 0>;
> +       };
> 
> arch/arm/boot/dts/exynos5440.dtsi
> -       pinctrl {
> +       pin_ctrl: pinctrl {
> 

Note that you don't really have to use a label, you can also refer
to the pinctrl node by its full path, which is just "/pinctrl"
or "/pinctrl@e0000".

	Arnd
