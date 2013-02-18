Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599Ab3BRPJ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 10:09:59 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:57623 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664Ab3BRPJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 10:09:56 -0500
Date: Mon, 18 Feb 2013 16:12:06 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: David Woodhouse <dwmw2@infradead.org>
Cc: "Sankaran, Rajesh" <rajesh.sankaran@intel.com>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH] intel/iommu: force writebuffer-flush quirk on Gen 4
 Chipsets
Message-ID: <20130218151206.GO5813@phenom.ffwll.local>
Mail-Followup-To: David Woodhouse <dwmw2@infradead.org>,
	"Sankaran, Rajesh" <rajesh.sankaran@intel.com>,
	Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
	DRI Development <dri-devel@lists.freedesktop.org>,
	LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
References: <1358794139-4820-1-git-send-email-daniel.vetter@ffwll.ch>
 <1358880935.5523.147.camel@shinybook.infradead.org>
 <CAKMK7uFLi5VeOBpDRctJ3AW_0fk3YPqcwnDokOTpGCioaWOqCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKMK7uFLi5VeOBpDRctJ3AW_0fk3YPqcwnDokOTpGCioaWOqCA@mail.gmail.com>
X-Operating-System: Linux phenom 3.7.0-rc4+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 07:40:05PM +0100, Daniel Vetter wrote:
> On Tue, Jan 22, 2013 at 7:55 PM, David Woodhouse <dwmw2@infradead.org> wrote:
> > On Mon, 2013-01-21 at 19:48 +0100, Daniel Vetter wrote:
> >> We already have the quirk entry for the mobile platform, but also
> >> reports on some desktop versions. So be paranoid and set it
> >> everywhere.
> >>
> >> References: http://www.mail-archive.com/dri-devel@lists.freedesktop.org/msg33138.html
> >> Cc: stable@vger.kernel.org
> >> Cc: David Woodhouse <dwmw2@infradead.org>
> >> Reported-and-tested-by: Mihai Moldovan <ionic@ionic.de>
> >> Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> >> ---
> >>  drivers/iommu/intel-iommu.c |    8 +++++++-
> >>  1 file changed, 7 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
> >> index 9743769..19854bf 100644
> >> --- a/drivers/iommu/intel-iommu.c
> >> +++ b/drivers/iommu/intel-iommu.c
> >> @@ -4215,13 +4215,19 @@ static void __devinit quirk_iommu_rwbf(struct pci_dev *dev)
> >>  {
> >>       /*
> >>        * Mobile 4 Series Chipset neglects to set RWBF capability,
> >> -      * but needs it:
> >> +      * but needs it. Same seems to hold for the desktop versions.
> >>        */
> >>       printk(KERN_INFO "DMAR: Forcing write-buffer flush capability\n");
> >>       rwbf_quirk = 1;
> >>  }
> >>
> >>  DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2a40, quirk_iommu_rwbf);
> >> +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2e00, quirk_iommu_rwbf);
> >> +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2e10, quirk_iommu_rwbf);
> >> +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2e20, quirk_iommu_rwbf);
> >> +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2e30, quirk_iommu_rwbf);
> >> +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2e40, quirk_iommu_rwbf);
> >> +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2e90, quirk_iommu_rwbf);
> >>
> >>  #define GGC 0x52
> >>  #define GGC_MEMORY_SIZE_MASK (0xf << 8)
> >
> > Again, I'm really unhappy about doing this kind of thing based on
> > hearsay. This should have a specific reference (with URL) to a published
> > erratum. Rajesh?
> 
> Any updates here? I'd like to include this for 3.9 -next with cc:
> stable to finally allow distros to enable DMAR/IOMMU support by
> default on Intel hw. The current state of affairs is simply
> embarrassing imo :(

Whatever, I want to get this off my table, so merged to drm-intel-fixes
for 3.9.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
