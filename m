Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111AbaENXk2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 19:40:28 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:35479 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887AbaENXk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 19:40:26 -0400
MIME-Version: 1.0
In-Reply-To: <20140509151735.8321.22017.stgit@bling.home>
References: <20140509151735.8321.22017.stgit@bling.home>
Date: Thu, 15 May 2014 07:40:25 +0800
Message-ID: <CAJtEV7YYB4W_+nZeMgiqZVDV+M4OyFJVBic09z=KbMjOpihnTQ@mail.gmail.com>
Subject: Re: [PATCH v2 00/15] PCI/iommu: Fix DMA alias problems
From: Andrew Cooks <acooks@gmail.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: "open list:PCI SUBSYSTEM" <linux-pci@vger.kernel.org>,
        "open list:INTEL IOMMU (VT-d)" <iommu@lists.linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex

On Fri, May 9, 2014 at 11:28 PM, Alex Williamson
<alex.williamson@redhat.com> wrote:
> ....
>
> Original description:
>
> This series attempts to fix a couple issues we've had outstanding in
> the PCI/IOMMU code for a while.  The first issue is with devices that
> use the wrong requester ID for DMA transactions.  We already have a
> sort of half-baked attempt to fix this for several Ricoh devices, but
> the fix only helps them be useful through IOMMU groups, not the
> general DMA case.  There are also several Marvell devices which use
> use a different wrong requester ID and don't even fit into the DMA
> source idea.  This series creates a DMA alias iterator that will
> step through each possible alias of a device, allowing IOMMUs to
> insert mappings for both the device and its aliases.
>
> Hand-in-hand with this is our broken pci_find_upstream_pcie_bridge()
> function, which is known to blowup when it finds itself suddenly at
> a PCIe device without crossing a PCIe-to-PCI bridge (as identified by
> the PCIe capability).  It also likes to make the invalid assumption
> that a PCIe device never has its requester ID masked by any usptream
> bus.  We can fix this using the above new DMA alias iterator, since
> that's effectively what this function was meant to do.
>

There are two cases where the DMA requester id seems to use the wrong
slot (as opposed to function) in the patch I attached to
https://bugzilla.kernel.org/show_bug.cgi?id=42679
The original bug reports are listed in the patch.

Unfortunately, I wasn't able to get test feedback on those two cases,
but I'm wondering...
Did I understand correctly that a slot alias is something that could be needed?
If so, is it a variation of the PCIe-to-PCI bridge case that's already
covered or will it require a different approach?

Thanks,

a.
