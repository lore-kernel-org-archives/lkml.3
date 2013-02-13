Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567Ab3BMSkK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 13:40:10 -0500
Received: from mail-ia0-f169.google.com ([209.85.210.169]:36659 "EHLO
	mail-ia0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892Ab3BMSkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 13:40:06 -0500
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <1358880935.5523.147.camel@shinybook.infradead.org>
References: <1358794139-4820-1-git-send-email-daniel.vetter@ffwll.ch>
	<1358880935.5523.147.camel@shinybook.infradead.org>
Date: Wed, 13 Feb 2013 19:40:05 +0100
Message-ID: <CAKMK7uFLi5VeOBpDRctJ3AW_0fk3YPqcwnDokOTpGCioaWOqCA@mail.gmail.com>
Subject: Re: [PATCH] intel/iommu: force writebuffer-flush quirk on Gen 4 Chipsets
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: David Woodhouse <dwmw2@infradead.org>
Cc: "Sankaran, Rajesh" <rajesh.sankaran@intel.com>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 7:55 PM, David Woodhouse <dwmw2@infradead.org> wrote:
> On Mon, 2013-01-21 at 19:48 +0100, Daniel Vetter wrote:
>> We already have the quirk entry for the mobile platform, but also
>> reports on some desktop versions. So be paranoid and set it
>> everywhere.
>>
>> References: http://www.mail-archive.com/dri-devel@lists.freedesktop.org/msg33138.html
>> Cc: stable@vger.kernel.org
>> Cc: David Woodhouse <dwmw2@infradead.org>
>> Reported-and-tested-by: Mihai Moldovan <ionic@ionic.de>
>> Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
>> ---
>>  drivers/iommu/intel-iommu.c |    8 +++++++-
>>  1 file changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
>> index 9743769..19854bf 100644
>> --- a/drivers/iommu/intel-iommu.c
>> +++ b/drivers/iommu/intel-iommu.c
>> @@ -4215,13 +4215,19 @@ static void __devinit quirk_iommu_rwbf(struct pci_dev *dev)
>>  {
>>       /*
>>        * Mobile 4 Series Chipset neglects to set RWBF capability,
>> -      * but needs it:
>> +      * but needs it. Same seems to hold for the desktop versions.
>>        */
>>       printk(KERN_INFO "DMAR: Forcing write-buffer flush capability\n");
>>       rwbf_quirk = 1;
>>  }
>>
>>  DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2a40, quirk_iommu_rwbf);
>> +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2e00, quirk_iommu_rwbf);
>> +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2e10, quirk_iommu_rwbf);
>> +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2e20, quirk_iommu_rwbf);
>> +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2e30, quirk_iommu_rwbf);
>> +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2e40, quirk_iommu_rwbf);
>> +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2e90, quirk_iommu_rwbf);
>>
>>  #define GGC 0x52
>>  #define GGC_MEMORY_SIZE_MASK (0xf << 8)
>
> Again, I'm really unhappy about doing this kind of thing based on
> hearsay. This should have a specific reference (with URL) to a published
> erratum. Rajesh?

Any updates here? I'd like to include this for 3.9 -next with cc:
stable to finally allow distros to enable DMAR/IOMMU support by
default on Intel hw. The current state of affairs is simply
embarrassing imo :(
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
