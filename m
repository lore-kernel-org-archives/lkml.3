Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901AbaAaJKM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 04:10:12 -0500
Received: from mga09.intel.com ([134.134.136.24]:47699 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410AbaAaJKJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 04:10:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,756,1384329600"; 
   d="scan'208";a="467708025"
From: "Brown, Aaron F" <aaron.f.brown@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
CC: "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        Arjan van de Ven <arjan@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [E1000-devel] [PATCH 0/2] Remove dead code
Thread-Topic: [E1000-devel] [PATCH 0/2] Remove dead code
Thread-Index: AQHPHfClu3RgmFazZUuNyVHLjAAKjZqejAWQ
Date: Fri, 31 Jan 2014 09:10:06 +0000
Message-ID: <309B89C4C689E141A5FF6A0C5FB2118B7314C430@ORSMSX101.amr.corp.intel.com>
References: <20140130192011.25426.45702.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20140130192011.25426.45702.stgit@bhelgaas-glaptop.roam.corp.google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Bjorn Helgaas [mailto:bhelgaas@google.com]
> Sent: Thursday, January 30, 2014 11:21 AM
> To: linux-pci@vger.kernel.org
> Cc: e1000-devel@lists.sourceforge.net; Arjan van de Ven; linux-
> kernel@vger.kernel.org
> Subject: [E1000-devel] [PATCH 0/2] Remove dead code
> 
> This is a rework of part of Stephen's patch [1].
> 
> This removes the MMIO exclusivity support that was added as part of an
> e1000e bug hunt.
> 
> The e1000e driver still uses pci_request_selected_regions_exclusive(), but
> there are no callers of pci_request_region_exclusive() and
> pci_request_regions_exclusive().  I thought it was cleaner to remove the
> whole thing than to leave parts of it in place.  But I could easily be
> convinced to leave part or all of this in place if people think it's still
> useful.

Thanks Bjorn, I have added these to Jeff's queue.

> 
> It also removes SR-IOV migration support, which is completely unused, as
> far as I can tell.
> 
> [1]
> http://lkml.kernel.org/r/20131227132710.7190647c@nehalam.linuxnetplumber.n
> et
> 
> ---
> 
> Bjorn Helgaas (2):
>       PCI: Remove unused MMIO exclusivity support
>       PCI: Remove unused SR-IOV VF Migration support
> 
> 
>  Documentation/PCI/pci-iov-howto.txt        |    4 -
>  Documentation/kernel-parameters.txt        |    4 -
>  arch/x86/mm/init.c                         |    2
>  drivers/net/ethernet/intel/e1000e/netdev.c |    3 -
>  drivers/pci/iov.c                          |  119 -----------------------
> -----
>  drivers/pci/pci-sysfs.c                    |    3 -
>  drivers/pci/pci.c                          |  112 +++--------------------
> ---
>  drivers/pci/pci.h                          |    4 -
>  include/linux/ioport.h                     |    5 -
>  include/linux/pci.h                        |    7 --
>  kernel/resource.c                          |   54 -------------
>  11 files changed, 14 insertions(+), 303 deletions(-)
> 
> --------------------------------------------------------------------------
> ----
> WatchGuard Dimension instantly turns raw network data into actionable
> security intelligence. It gives you real-time visual feedback on key
> security issues and trends.  Skip the complicated setup - simply import a
> virtual appliance and go from zero to informed in seconds.
> http://pubads.g.doubleclick.net/gampad/clk?id=123612991&iu=/4140/ostg.clkt
> rk
> _______________________________________________
> E1000-devel mailing list
> E1000-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/e1000-devel
> To learn more about Intel&#174; Ethernet, visit
> http://communities.intel.com/community/wired
