Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645AbbALQGt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 11:06:49 -0500
Received: from 8bytes.org ([81.169.241.247]:46328 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751608AbbALQGr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 11:06:47 -0500
Date: Mon, 12 Jan 2015 17:06:46 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Li, Zhen-Hua" <zhen-hual@hp.com>, dwmw2@infradead.org,
        indou.takao@jp.fujitsu.com, bhe@redhat.com, dyoung@redhat.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, kexec@lists.infradead.org,
        alex.williamson@redhat.com, ddutile@redhat.com,
        ishii.hironobu@jp.fujitsu.com, bhelgaas@google.com, doug.hatch@hp.com,
        jerry.hoemann@hp.com, tom.vaden@hp.com, li.zhang6@hp.com,
        lisa.mitchell@hp.com, billsumnerlinux@gmail.com, rwright@hp.com
Subject: Re: [PATCH v8 02/10] iommu/vt-d: Items required for kdump
Message-ID: <20150112160646.GF6343@8bytes.org>
References: <1421046388-27925-1-git-send-email-zhen-hual@hp.com>
 <1421046388-27925-3-git-send-email-zhen-hual@hp.com>
 <20150112152207.GC6343@8bytes.org>
 <20150112152919.GA16162@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150112152919.GA16162@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 10:29:19AM -0500, Vivek Goyal wrote:
> Kdump has the notion of backup region. Where certain parts of old kernels
> memory can be moved to a different location (first 640K on x86 as of now)
> and new kernel can make use of this memory now.
> 
> So we will have to just make sure that no parts of this old page table
> fall into backup region.

Uuh, looks like the 'iommu-with-kdump-issue' isn't complicated enough
yet ;)
Sadly, your above statement is true for all hardware-accessible data
structures in IOMMU code. I think about how we can solve this, is there
an easy way to allocate memory that is not in any backup region?

Thanks,

	Joerg

