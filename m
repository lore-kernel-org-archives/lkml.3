Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236AbaKTLux (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 06:50:53 -0500
Received: from smtp.citrix.com ([66.165.176.89]:2355 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754735AbaKTLug (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 06:50:36 -0500
X-IronPort-AV: E=Sophos;i="5.07,423,1413244800"; 
   d="scan'208";a="193231392"
From: David Vrabel <david.vrabel@citrix.com>
To: <linux-kernel@vger.kernel.org>
CC: David Vrabel <david.vrabel@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>,
        <xen-devel@lists.xenproject.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCHv4 0/4]: dma, x86, xen: reduce SWIOTLB usage in Xen guests
Date: Thu, 20 Nov 2014 11:50:21 +0000
Message-ID: <1416484225-28054-1-git-send-email-david.vrabel@citrix.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On systems where DMA addresses and physical addresses are not 1:1
(such as Xen PV guests), the generic dma_get_required_mask() will not
return the correct mask (since it uses max_pfn).

Some device drivers (such as mptsas, mpt2sas) use
dma_get_required_mask() to set the device's DMA mask to allow them to use
only 32-bit DMA addresses in hardware structures.  This results in
unnecessary use of the SWIOTLB if DMA addresses are more than 32-bits,
impacting performance significantly.

This series allows Xen PV guests to override the default
dma_get_required_mask() with one that calculates the DMA mask from the
maximum MFN (and not the PFN).

Changes in v4:
- Assume 64-bit mask is required.

Changes in v3:
- fix off-by-one in xen_dma_get_required_mask()
- split ia64 changes into separate patch.

Changes in v2:
- split x86 and xen changes into separate patches

David

