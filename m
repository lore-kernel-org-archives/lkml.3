Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927Ab3AVS1K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 13:27:10 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:55020 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754512Ab3AVS1F convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 13:27:05 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -8
X-BigFish: VPS-8(zz98dI9371Id6eah542I1432I111aIzz1ee6h1de0h1202h1e76h1d1ah1d2ahzz17326ah5eeeK8275bh8275dhz2dh668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1155h)
X-WSS-ID: 0MH1HWT-02-DUY-02
X-M-MSG: 
From: "Kinney, Steven" <Steven.Kinney@amd.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        Joerg Roedel <joro@8bytes.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Andi Kleen <ak@linux.intel.com>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Kosina <jkosina@suse.cz>, Bjorn Helgaas <bhelgaas@google.com>,
        Myron Stowe <myron.stowe@redhat.com>, Thomas Renninger <trenn@suse.de>
Subject: RE: [PATCH 0/3] AMD IOMMUv2 Performance Counter patches
Thread-Topic: [PATCH 0/3] AMD IOMMUv2 Performance Counter patches
Thread-Index: AQHN+BTd2MGm39Q80UedfkAxzGs3D5hWBayA//+gDwA=
Date: Tue, 22 Jan 2013 18:26:55 +0000
Message-ID: <57D41218901B4442B4AFF404D21591163BBB25@sausexdag02.amd.com>
References: <1358799658-6236-1-git-send-email-steven.kinney@amd.com>
 <20130122174803.GF8365@phenom.dumpdata.com>
In-Reply-To: <20130122174803.GF8365@phenom.dumpdata.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.226.128.2]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Konrad,

                      Thanks for your response.  When writing the driver, at AMD, I am provided an internal IOMMUv2.x specification that may not be out in the public as of yet; I am following up on this and will comment on the availability concerning this version.   Also, I checked the v2.0 of the IOMMU Specification, specifically the following:

MMIO Offset [40-7F][0-F]08h IOMMU Counter Source Register - Table 64: Architectural Counter Input Group : This is the CSource and the format can be found in /sys/bus/event_sources/devices/iommuv2/forrmat/
MMIO Offset [40-7F][0-F]20h IOMMU DeviceID Match Register - For the following three registers, the config value defines the Match and config1 value defines the Mask; see the specification v2.0 for details; also see sys/...../format for details.
MMIO Offset [40-7F][0-F]10h IOMMU PASID Match Register - 
MMIO Offset [40-7F][0-F]18h IOMMU Domain Match Register - 

The one caveat between the v2.0 and v2.5 concerns a slight expansion of the CSource register Input Group, but any event defined within v2.0 will execute properly regarding the driver patch(es) sent to the kernel community.

Please let me know, in any way, how I can better this driver code and I will make it so.  Also, Will have an answer for you regarding AMD IOMMUv2.5 ASAP.

Thanks again for your comments, appreciated.

-----Original Message-----
From: Konrad Rzeszutek Wilk [mailto:konrad.wilk@oracle.com] 
Sent: Tuesday, January 22, 2013 11:48 AM
To: Kinney, Steven
Cc: Thomas Gleixner; Ingo Molnar; H. Peter Anvin; x86@kernel.org; Joerg Roedel; Kukjin Kim; Peter Zijlstra; Stephen Warren; Greg Kroah-Hartman; linux-kernel@vger.kernel.org; iommu@lists.linux-foundation.org; Cyrill Gorcunov; Sebastian Andrzej Siewior; Andi Kleen; Paul Mackerras; Arnaldo Carvalho de Melo; Jiri Kosina; Bjorn Helgaas; Myron Stowe; Thomas Renninger
Subject: Re: [PATCH 0/3] AMD IOMMUv2 Performance Counter patches

On Mon, Jan 21, 2013 at 02:20:55PM -0600, Steven L. Kinney wrote:
> From: "Steven L. Kinney" <steven.kinney@amd.com>
> 
> These patches implement the AMD IOMMUv2.5 Performance Counter 
> functionality via custom perf PMU and implement static counting for 
> various IOMMU translations.  The patches address three areas of functionality:
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
> For information regarding AMD IOMMU v2.5 PC configuration, see the 
> public specification.

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


