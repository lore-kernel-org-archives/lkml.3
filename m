Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112Ab3AVRv6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 12:51:58 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:16847 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755113Ab3AVRvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 12:51:15 -0500
Date: Tue, 22 Jan 2013 12:48:03 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Steven L. Kinney" <steven.kinney@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Joerg Roedel <joro@8bytes.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Andi Kleen <ak@linux.intel.com>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Kosina <jkosina@suse.cz>, Bjorn Helgaas <bhelgaas@google.com>,
        Myron Stowe <myron.stowe@redhat.com>, Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH 0/3] AMD IOMMUv2 Performance Counter patches
Message-ID: <20130122174803.GF8365@phenom.dumpdata.com>
References: <1358799658-6236-1-git-send-email-steven.kinney@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358799658-6236-1-git-send-email-steven.kinney@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 02:20:55PM -0600, Steven L. Kinney wrote:
> From: "Steven L. Kinney" <steven.kinney@amd.com>
> 
> These patches implement the AMD IOMMUv2.5 Performance Counter functionality
> via custom perf PMU and implement static counting for various IOMMU
> translations.  The patches address three areas of functionality:
> 
> 1) 	Add a PCI quirk for the enablement of IOMMUv2 EFR PC within a specific
> 	AMD family/model in which BIOS has not enabled.  Based on code 
> 	implemented by Andreas Herrmann at AMD Dresden.
> 2)	Extend the AMD IOMMU initialization to include IOMMUv2 PC enablement
> 	and access to IOMMUv2 counter registers.  For all AMD family/models
> 	that implement IOMMUv2.5 functionality.
> 3)	Code the perf IOMMUv2 PMU to manage IOMMUv2 perf events, which call
> 	the function(s) extending the AMD IOMMU core driver.  For all AMD
> 	family/models that implement IOMMUv2.5 functionality.
> 
> The command-line, to invoke the iommuv2 PMU, is:
> 
> perf stat -e iommuv2/config=[data],config1=[data]/{u,r} [command]
> 
> For information regarding AMD IOMMU v2.5 PC configuration, see the public
> specification.

Is there a name for it? I see
http://support.amd.com/us/Processor_TechDocs/48882.pdf
but that looks to be for v2.0?
> 
> Steven L. Kinney (3):
>   AMD x86 quirks: Quirk for enabling IOMMUv2 PC feature
>   AMD IOMMUv2 PC resource management hooks
>   AMD IOMMUv2 PC perf PMU implementation
> 
>  arch/x86/kernel/cpu/Makefile                 |    1 +
>  arch/x86/kernel/cpu/perf_event_amd_iommuv2.c |  429 ++++++++++++++++++++++++++
>  arch/x86/kernel/cpu/perf_event_amd_iommuv2.h |   42 +++
>  arch/x86/kernel/quirks.c                     |   17 +
>  drivers/iommu/Kconfig                        |   10 +
>  drivers/iommu/amd_iommu_init.c               |   99 ++++++
>  drivers/iommu/amd_iommu_types.h              |   12 +
>  include/linux/pci_ids.h                      |    2 +
>  8 files changed, 612 insertions(+)
>  create mode 100644 arch/x86/kernel/cpu/perf_event_amd_iommuv2.c
>  create mode 100644 arch/x86/kernel/cpu/perf_event_amd_iommuv2.h
> 
> -- 
> 1.7.9.5
> 
> 
> _______________________________________________
> iommu mailing list
> iommu@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/iommu
