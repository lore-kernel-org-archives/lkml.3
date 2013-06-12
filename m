Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749Ab3FLO54 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 10:57:56 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:65484 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754688Ab3FLO5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 10:57:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH V3 1/3] Add PCIe driver for Samsung Exynos
Date: Wed, 12 Jun 2013 16:57:26 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: devicetree-discuss@lists.ozlabs.org,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "'Jason Gunthorpe'" <jgunthorpe@obsidianresearch.com>,
        linux-samsung-soc@vger.kernel.org,
        "'Siva Reddy Kallam'" <siva.kallam@samsung.com>,
        linux-pci@vger.kernel.org,
        "'Thierry Reding'" <thierry.reding@avionic-design.de>,
        linux-kernel@vger.kernel.org,
        "'Surendranath Gurivireddy Balla'" <suren.reddy@samsung.com>,
        "'Andrew Murray'" <andrew.murray@arm.com>,
        linux-arm-kernel@lists.infradead.org
References: <000d01ce6360$9504e7e0$bf0eb7a0$@samsung.com> <36071399.7aY6jgGn2d@wuerfel> <002401ce6718$d6bbc8f0$84335ad0$@samsung.com>
In-Reply-To: <002401ce6718$d6bbc8f0$84335ad0$@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306121657.26441.arnd@arndb.de>
X-Provags-ID: V02:K0:20KqHEcmedPNqMhS3mAym8JTrMQcjUyr030Ao9VsS5h
 5FMVPJYNJVVLwHAu8GMm7a/c8Ujco6P9q4BFz/81vuXX3zLlgr
 qFpSEeSeS44haz4V5mYFBrBvoWzARiwXMS+zoDNTBs2lUT91/L
 eT4b0gBGDhiJfxW6dNgcBJEowItwT+e/tu5cYiajcD/rXDeW9l
 4jCYSx+6w19cTPV5++ca6weiDbtRAGtfZCHKzVNCaieqlos5q3
 y52ZojaAIRbYUeUKJJT+voioCLocuDhKIxzQIYKSQx1NMdesce
 lOyWpP3q8Bt6GcQzPvlvM+P0cmugqZBuJfMy9M7FIcJdFk9WgQ
 uLyXTwWdZUJpyGibh5mE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 June 2013, Jingoo Han wrote:
> On Friday, June 07, 2013 7:53 PM, Arnd Bergmann wrote:
> > On Friday 07 June 2013 18:22:50 Jingoo Han wrote:
> > 
> > > +- ranges: ranges for the PCI memory and I/O regions
> > > +- reset-gpio: gpio pin number of power good signal
> > 
> > The 'reset-gpio' property seems incorrect. I think this should either
> > use the gpio binding or the reset-controller binding. Specifying
> > bare numbers to use as gpio pins does not work, since the number
> > space for Linux internal gpio numbers is not necessarily the same
> > as used by the hardware.
> 
> As you mentioned, other Exynos SoCs such as Exynos5250 set
> GPIO properties in DT, as below:
> (./arch/arm/boot/dts/exynos5250-smdk5250.dts)
> 	hdmi {
> 		hpd-gpio = <&gpx3 7 0>;
> 	};
> 	usb@12110000 {
> 		samsung,vbus-gpio = <&gpx2 6 0>;
> 	};
> 
> However, the situation of Exynos5440 GPIO is different.
> The following bare numbers of GPIO work properly on Exynos5440.
> (./arch/arm/boot/dts/exynos5440-ssdk5440.dts)
> 	pcie0@40000000 {
> 		reset-gpio = <5>;
> 	}
> 	pcie0@40000000 {
> 		reset-gpio = <22>;
> 	}
> 
> Thomas Abraham is the author of pinctrl driver for EXYNOS5440.
> (./drivers/pinctrl/pinctrl-exynos5440.c)
> 
> Thomas Abraham or Kukjin Kim, can you confirm this?
> If I am wrong, please let me know kindly. :)

This is not about the code working at the moment, it is about
it being correct. The current method you are using would stop
working if something changes in the pinctrl code, and would
not be portable to other SoCs.

	Arnd
