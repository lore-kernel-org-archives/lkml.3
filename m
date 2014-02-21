Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297AbaBUBai (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 20:30:38 -0500
Received: from mail-ve0-f172.google.com ([209.85.128.172]:50740 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754337AbaBUBag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 20:30:36 -0500
MIME-Version: 1.0
In-Reply-To: <20140218205925.11014.14973.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140218205925.11014.14973.stgit@bhelgaas-glaptop.roam.corp.google.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 20 Feb 2014 18:30:15 -0700
Message-ID: <CAErSpo7z9-gTGLHT8gOGC-KHek-kzNBtWVMWQEU8DWn3PekmTw@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] Remove dead code
To: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Cc: "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        Joerg Roedel <joro@8bytes.org>, Sudeep Dutt <sudeep.dutt@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "open list:INTEL IOMMU (VT-d)" <iommu@lists.linux-foundation.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Aaron F Brown <aaron.f.brown@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 1:59 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> This is v2 of my rework of part of Stephen's patch [1].  My v1 posting,
> with a little discussion, is here [2].
>
> This removes SR-IOV migration support, which seems to be unused.
>
> Changes since v1:
>   - Drop the removal of MMIO exclusivity.
>   - Add a few includes of <linux/irqreturn.h>.  The SR-IOV migration
>     support included irqreturn.h via linux/pci.h, and a few drivers relied
>     on that.  So this v2 series updates those drivers to include
>     irqreturn.h directly.
>
> Unless there's objection, I'd like to merge all these through my PCI tree
> for v3.15.

I applied these to my pci/dead-code branch, which is now in -next, for v3.15.

> Bjorn
>
> [1] http://lkml.kernel.org/r/20131227132710.7190647c@nehalam.linuxnetplumber.net
> [2] https://lkml.kernel.org/r/20140130192011.25426.45702.stgit@bhelgaas-glaptop.roam.corp.google.com
>
> ---
>
> Bjorn Helgaas (4):
>       misc: mic: Add include of <linux/irqreturn.h>
>       mei: Add include of <linux/irqreturn.h>
>       iommu/amd: Add include of <linux/irqreturn.h>
>       PCI: Remove unused SR-IOV VF Migration support
>
>
>  Documentation/PCI/pci-iov-howto.txt |    4 -
>  drivers/iommu/amd_iommu_types.h     |    1
>  drivers/misc/mei/hw-me.h            |    1
>  drivers/misc/mic/card/mic_device.h  |    1
>  drivers/misc/mic/host/mic_device.h  |    1
>  drivers/pci/iov.c                   |  119 -----------------------------------
>  drivers/pci/pci.h                   |    4 -
>  include/linux/pci.h                 |    4 -
>  8 files changed, 4 insertions(+), 131 deletions(-)
