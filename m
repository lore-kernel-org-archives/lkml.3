Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443AbbALPS7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 10:18:59 -0500
Received: from 8bytes.org ([81.169.241.247]:45815 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753031AbbALPS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 10:18:57 -0500
Date: Mon, 12 Jan 2015 16:18:55 +0100
From: Joerg Roedel <joro@8bytes.org>
To: "Li, Zhen-Hua" <zhen-hual@hp.com>
Cc: dwmw2@infradead.org, indou.takao@jp.fujitsu.com, bhe@redhat.com,
        vgoyal@redhat.com, dyoung@redhat.com, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        kexec@lists.infradead.org, alex.williamson@redhat.com,
        ddutile@redhat.com, ishii.hironobu@jp.fujitsu.com, bhelgaas@google.com,
        doug.hatch@hp.com, jerry.hoemann@hp.com, tom.vaden@hp.com,
        li.zhang6@hp.com, lisa.mitchell@hp.com, billsumnerlinux@gmail.com,
        rwright@hp.com
Subject: Re: [PATCH v8 01/10] iommu/vt-d: Update iommu_attach_domain() and
 its callers
Message-ID: <20150112151855.GB6343@8bytes.org>
References: <1421046388-27925-1-git-send-email-zhen-hual@hp.com>
 <1421046388-27925-2-git-send-email-zhen-hual@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421046388-27925-2-git-send-email-zhen-hual@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 03:06:19PM +0800, Li, Zhen-Hua wrote:
> Allow specification of the domain-id for the new domain.
> This patch only adds the 'did' parameter to iommu_attach_domain()
> and modifies all of its callers to specify the default value of -1
> which says "no did specified, allocate a new one".

I think its better to keep the old iommu_attach_domain() interface in
place and introduce a new function (like iommu_attach_domain_with_id()
or something) which has the additional parameter. Then you can rewrite
iommu_attach_domain():

	iommu_attach_domai(...)
	{
		return iommu_attach_domain_with_id(..., -1);
	}

This way you don't have to update all the callers of
iommu_attach_domain() and the interface is more readable.


	Joerg

