Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778AbbALQQR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 11:16:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54088 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753027AbbALQQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 11:16:15 -0500
Date: Mon, 12 Jan 2015 11:15:38 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: "Li, Zhen-Hua" <zhen-hual@hp.com>, dwmw2@infradead.org,
        indou.takao@jp.fujitsu.com, bhe@redhat.com, dyoung@redhat.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, kexec@lists.infradead.org,
        alex.williamson@redhat.com, ddutile@redhat.com,
        ishii.hironobu@jp.fujitsu.com, bhelgaas@google.com, doug.hatch@hp.com,
        jerry.hoemann@hp.com, tom.vaden@hp.com, li.zhang6@hp.com,
        lisa.mitchell@hp.com, billsumnerlinux@gmail.com, rwright@hp.com
Subject: Re: [PATCH v8 02/10] iommu/vt-d: Items required for kdump
Message-ID: <20150112161538.GB16162@redhat.com>
References: <1421046388-27925-1-git-send-email-zhen-hual@hp.com>
 <1421046388-27925-3-git-send-email-zhen-hual@hp.com>
 <20150112152207.GC6343@8bytes.org>
 <20150112152919.GA16162@redhat.com>
 <20150112160646.GF6343@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150112160646.GF6343@8bytes.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 05:06:46PM +0100, Joerg Roedel wrote:
> On Mon, Jan 12, 2015 at 10:29:19AM -0500, Vivek Goyal wrote:
> > Kdump has the notion of backup region. Where certain parts of old kernels
> > memory can be moved to a different location (first 640K on x86 as of now)
> > and new kernel can make use of this memory now.
> > 
> > So we will have to just make sure that no parts of this old page table
> > fall into backup region.
> 
> Uuh, looks like the 'iommu-with-kdump-issue' isn't complicated enough
> yet ;)
> Sadly, your above statement is true for all hardware-accessible data
> structures in IOMMU code. I think about how we can solve this, is there
> an easy way to allocate memory that is not in any backup region?

Hmm..., there does not seem to be any easy way to do this. In fact, as of
now, kernel does not even know where is backup region. All these details are
managed by user space completely (except for new kexec_file_load() syscall).

That means we are left with ugly options now.

- Define per arch kexec backup regions in kernel and export it to user
  space and let kexec-tools make use of that deinition (instead of
  defining its own). That way memory allocation code in kernel can look
  at this backup area and skip it for certain allocations.

Thanks
Vivek
