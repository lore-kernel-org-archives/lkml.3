Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751226AbaAYCpA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 21:45:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46739 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788AbaAYCo6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 21:44:58 -0500
Date: Sat, 25 Jan 2014 10:44:18 +0800
From: Baoquan He <bhe@redhat.com>
To: Bill Sumner <bill.sumner@hp.com>
Cc: dwmw2@infradead.org, indou.takao@jp.fujitsu.com, joro@8bytes.org,
        iommu@lists.linux-foundation.org, kexec@lists.infradead.org,
        alex.williamson@redhat.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, ddutile@redhat.com,
        ishii.hironobu@jp.fujitsu.com, bhelgaas@google.com, doug.hatch@hp.com,
        zhenhua@hp.com
Subject: Re: [PATCHv3 0/6] Crashdump Accepting Active IOMMU
Message-ID: <20140125024418.GA1549@dhcp-17-102.nay.redhat.com>
References: <1389391652-52422-1-git-send-email-bill.sumner@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389391652-52422-1-git-send-email-bill.sumner@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tested this patchset on my local HP Z420 workstation, and it works very
well.

Hi Bill,

Thanks for your effort.

There are several concerns from me.

Firstly, I think the patch log need be rearanged. Patchset cover letter
can contain information to express why, how briefly. If you think this
is very useful, it can be split and put into patch log.

Then for each patch, patch log should be accurate and summary to
describe why and how this patch really does. If you feel several patches
have the corelation, they may need to be merged.

Secondly, each patch could get a seperate subject which tells what this
patch really does. Even they are merged to kernel git tree, each of them
is a independent commit. People can take to use or depend only one of
them. Actually, I don't like current patch subject.

Thirdly, this patchset will be part of intel-iommu, though they only
works for kdump kernel. As a subsystem, the style need be consistent. I
like the debug method which introduces a struct pr_debug, however
maintainers may not like it. Because a debug utility may bloat code and
affect people's review. Personally I like refined code, the less the
easier to review. Or put it as a independent patch at the end of the
patchset, let maintainer decide whether it's OK to pull in.

Sorry to say so much, I think this solution is truly the right way. As
you know, it's a big problem for kdump when intel-iommu is active in 1st
kernel. Because of this bug, many machines with intel-iommu have to be
set intel-iommu=off, the performance is affected very much.

Baoquan
Thanks

On 01/10/14 at 03:07pm, Bill Sumner wrote:
> v2->v3:
> 1. Commented-out "#define DEBUG 1" to eliminate debug messages
> 2. Updated the comments about changes in each version in all patches in the set.
> 3. Fixed: one-line added to Copy-Translations" patch to initialize the iovad
>           struct as recommended by Baoquan He [bhe@redhat.com]
>           init_iova_domain(&domain->iovad, DMA_32BIT_PFN);
> 
> v1->v2:
> The following series implements a fix for:
> A kdump problem about DMA that has been discussed for a long time. That is,
> when a kernel panics and boots into the kdump kernel, DMA started by the 
> panicked kernel is not stopped before the kdump kernel is booted and the 
> kdump kernel disables the IOMMU while this DMA continues.  This causes the
> IOMMU to stop translating the DMA addresses as IOVAs and begin to treat them 
> as physical memory addresses -- which causes the DMA to either:
> (1) generate DMAR errors or (2) generate PCI SERR errors or (3) transfer  
> data to or from incorrect areas of memory. Often this causes the dump to fail.
> 
 
