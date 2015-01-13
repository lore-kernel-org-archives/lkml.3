Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751640AbbAMLw4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 06:52:56 -0500
Received: from 8bytes.org ([81.169.241.247]:52671 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751046AbbAMLwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 06:52:54 -0500
Date: Tue, 13 Jan 2015 12:52:53 +0100
From: Joerg Roedel <joro@8bytes.org>
To: "Li, ZhenHua" <zhen-hual@hp.com>
Cc: dwmw2@infradead.org, indou.takao@jp.fujitsu.com, bhe@redhat.com,
        vgoyal@redhat.com, dyoung@redhat.com, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        kexec@lists.infradead.org, alex.williamson@redhat.com,
        ddutile@redhat.com, ishii.hironobu@jp.fujitsu.com, bhelgaas@google.com,
        doug.hatch@hp.com, jerry.hoemann@hp.com, tom.vaden@hp.com,
        li.zhang6@hp.com, lisa.mitchell@hp.com, billsumnerlinux@gmail.com,
        rwright@hp.com
Subject: Re: [PATCH v8 02/10] iommu/vt-d: Items required for kdump
Message-ID: <20150113115252.GH6343@8bytes.org>
References: <1421046388-27925-1-git-send-email-zhen-hual@hp.com>
 <1421046388-27925-3-git-send-email-zhen-hual@hp.com>
 <20150112152207.GC6343@8bytes.org>
 <54B4D36D.8030204@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54B4D36D.8030204@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 04:12:29PM +0800, Li, ZhenHua wrote:

> Current status:
> 1. Use old root entry table,
> 2. Copy old context entry tables.
> 3. Copy old page tables.
> 4. Allocate new page table when device driver is loading.
> 
> I remember the progress we discussed was this. Checking the old mails,
> founding we did not clearly discuss about the old page tables, only
> agrred with allocating new page tables when device driver is loading.
> 
> To me, both of these two options are fine, copying old page tables, or
> re-use the old ones. My debugging shows both of them works fine.
> 
> If we use the old page tables, the patchset will use less code.
> Functions copy_page_addr, copy_page_table are no longer needed, and
> functions copy_context_entry and copy_context_entry_table will be
> reduced to several lines. The patchset will be much simpler.

Yes, please do it this way. There is no point in copying the old
page-tables. We never make changes to them, so they can stay where they
are.

The problem with the backup region still exists, but it is not
specific to IOMMUs. This problem and should be addressed seperatly.


	Joerg

