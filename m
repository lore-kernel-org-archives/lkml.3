Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080Ab3FLPLM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 11:11:12 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:49579 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310Ab3FLPLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 11:11:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH 6/6] ARM: dts: Add pcie controller node for Samsung EXYNOS5440 SoC
Date: Wed, 12 Jun 2013 17:10:58 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "'Jason Gunthorpe'" <jgunthorpe@obsidianresearch.com>,
        linux-arm-kernel@lists.infradead.org,
        "'Thomas Petazzoni'" <thomas.petazzoni@free-electrons.com>,
        linux-samsung-soc@vger.kernel.org,
        "'Siva Reddy Kallam'" <siva.kallam@samsung.com>,
        "'Surendranath Gurivireddy Balla'" <suren.reddy@samsung.com>,
        linux-pci@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        "'Thierry Reding'" <thierry.reding@avionic-design.de>,
        linux-kernel@vger.kernel.org,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "'Andrew Murray'" <andrew.murray@arm.com>
References: <00c001ce277b$92b26ab0$b8174010$%han@samsung.com> <201306101722.10146.arnd@arndb.de> <002e01ce6668$f785dc20$e6919460$@samsung.com>
In-Reply-To: <002e01ce6668$f785dc20$e6919460$@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306121710.58601.arnd@arndb.de>
X-Provags-ID: V02:K0:Q+RMVSXxt1+dcvrhky614pBJFlFQtbrU3BXiXJ1/tVa
 BSsivqlst5lpvrv3HkkXPSIci06iWEV02gT9Dnuw8sDH16Koih
 vQ4wSYTrtR3Km5h+HOkWi0Q/5YFfwSvQs5mKR8eFFRzBWU447o
 wtTSLks2zEtRBrLYB9r74tiTOJHsId0x454l465LNPEycpz4Iq
 KhGpmRUMAxCSsUgqVmX8PCJyST2Yz+m2ZvS99UVIafo81XHGk4
 yb/xcZssrrPTD01PNtIXcl/HuX2RVLGoyNPPSf+dsxE01zzIit
 0PU9Xu8mga1PQOHST4i5Jd2cx/BchZ7gw+J70xk4tikQ9W8bUU
 EAc0Q51urj9VP1MOTnGg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 June 2013, Jingoo Han wrote:
> > > +           ranges = <0x00000800 0 0x40000000 0x40000000 0 0x00200000   /* configuration space */
> > > +                     0x81000000 0 0          0x40200000 0 0x00004000   /* downstream I/O */
> > > +                     0x82000000 0 0          0x40204000 0 0x10000000>; /* non-prefetchable memory */
> > > +   };
> > 
> ...
> > Also, shouldn't your memory space end on a 256MB boundary, rather than
> > extend up to 0x50203fff?
> 
> According to the manual of Exynos PCIe, each memory space for Exynos PCIe
> can support 512MB, including I/O, CFG regions.
> 
> Is there any problem when over 256MB boundary is used?
> Please let me know. :)

No, that's not a problem, but I think you should have the window span
the entire space that is provided in hardware. If there are 512 MB total, why
not use them?

You could use 

	ranges = <0x82000000 0 0          0x40204000 0 0x1fdfc000>;

to pass a range for the memory space that extends all the way until
0x5fffffff.

	Arnd
