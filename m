Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729AbaENKe5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 06:34:57 -0400
Received: from 8bytes.org ([85.214.48.195]:45511 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754617AbaENKey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 06:34:54 -0400
Date: Wed, 14 May 2014 12:34:50 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org,
        bhelgaas@google.com, acooks@gmail.com, linux-kernel@vger.kernel.org,
        linux@horizon.com
Subject: Re: [PATCH v3 08/15] iommu/amd: Use pci_find_dma_isolation_root()
 for IOMMU groups
Message-ID: <20140514103449.GE6026@8bytes.org>
References: <20140510145619.2997.429.stgit@bling.home>
 <20140510150311.2997.62903.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140510150311.2997.62903.stgit@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed May 14 12:34:53 2014
X-DSPAM-Confidence: 0.9983
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 537346cd20861899515852
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 10, 2014 at 09:03:11AM -0600, Alex Williamson wrote:
> The expectation is that the kernel and IVRS will produce the same
> result for topology based aliases while the kernel will also include
> device specific DMA quirks.

Is that expectation really true? There are PCIe devices out there that
don't use their own device-id for requests but another one that isn't
even visible as a PCI device (so the kernel has no pci_dev structure for
it). The IVRS table contains such information, but I am not sure whether
the PCI core finds the right requestor-id for those devices.

I've seen this on PCIe cards that where the vendor just used an PCI-X
chip with a PCIe-to-PCI-X bridge on the card. The PCI-X device is
visible for the OS but uses the requestor-id of the invisible bridge.


	Joerg


