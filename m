Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756436Ab3FGQVO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 12:21:14 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:38052 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753453Ab3FGQVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 12:21:12 -0400
Date: Fri, 7 Jun 2013 10:20:50 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Jingoo Han <jg1.han@samsung.com>,
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
Subject: Re: [PATCH 6/6] ARM: dts: Add pcie controller node for Samsung
 EXYNOS5440 SoC
Message-ID: <20130607162050.GA31895@obsidianresearch.com>
References: <00c001ce277b$92b26ab0$b8174010$%han@samsung.com>
 <20130408165626.GA30824@obsidianresearch.com>
 <000c01ce6360$237a7040$6a6f50c0$@samsung.com>
 <1880458.2ksb8qtzHh@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1880458.2ksb8qtzHh@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.195
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 01:59:43PM +0200, Arnd Bergmann wrote:
> On Friday 07 June 2013 18:19:40 Jingoo Han wrote:
> > Hi Jason Gunthorpe,
> > 
> > I implemented 'Single domain' with Exynos PCIe for last two months;
> > however, it cannot work properly due to the hardware restriction.
> > Each MEM region is hard-wired.
> > 
> > Thus, I will send Exynos PCIe V3 patch as 'Separate domains'.
> 
> Yes, I think that is best, if the hardware is clearly designed as
> separate domains, this is what we should do by default in the
> driver. For the Marvell case with its 10 separate ports, much
> more address space would be wasted by having one domain per
> port and that hardware let us work around it by remapping the
> physical address space windows. For Exynos there is much less to
> lose and I too cannot see how it would be done in the first
> place.

Sounds fair to me.

But when we talk about multiple domains we don't mean a disjoint range
bus bus numbers, as your other email shows:

00:00.0 PCI bridge: Samsung Electronics Co Ltd Device a549 (rev 01) (prog-if 00 [Normal decode])
10:00.0 PCI bridge: Samsung Electronics Co Ltd Device a549 (rev 01) (prog-if 00 [Normal decode])

We mean multiple domains, it should look like this:

0000:00:00.0 PCI bridge: Samsung Electronics Co Ltd Device a549 (rev 01) (prog-if 00 [Normal decode])
0001:00:00.0 PCI bridge: Samsung Electronics Co Ltd Device a549 (rev 01) (prog-if 00 [Normal decode])

ie lspci -D.

Each domain gets a unique bus number range, config space, io range,
etc. This is much clearer to everyone than trying to pretend there is
only one domain when the HW is actually multi-domain.

Jason
