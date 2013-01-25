Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481Ab3AYD6y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 22:58:54 -0500
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:54510 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389Ab3AYD6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 22:58:52 -0500
Date: Fri, 25 Jan 2013 12:59:12 +0900
From: Takuya Yoshikawa <yoshikawa_takuya_b1@lab.ntt.co.jp>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, gleb@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] kvm: IOMMU read-only mapping support
Message-Id: <20130125125912.9d72faa5.yoshikawa_takuya_b1@lab.ntt.co.jp>
In-Reply-To: <5101FBE8.9000206@linux.vnet.ibm.com>
References: <20130124220027.11061.76400.stgit@bling.home>
	<20130125101704.b76b049d.yoshikawa_takuya_b1@lab.ntt.co.jp>
	<5101FBE8.9000206@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jan 2013 11:28:40 +0800
Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com> wrote:

> > I think I can naturally update my patch after this gets merged.
> > 
> 
> Please wait.

The patch I mentioned above won't change anything.  Just cleans up
set_memory_region().  The only possible change which we discussed
before was whether we call iommu_map() on a flags change.

> The commit c972f3b1 changed the write-protect behaviour - it does
> wirte-protection only when dirty flag is set.
> [ I did not see this commit when we discussed the problem before. ]

I'll look at the commit later, after the lunch break.

> Further more, i notice that write-protect is not enough, when do sync
> shadow page:
> 
> FNAME(sync_page):
> 
> 		host_writable = sp->spt[i] & SPTE_HOST_WRITEABLE;
> 
> 		set_spte(vcpu, &sp->spt[i], pte_access,
> 			 PT_PAGE_TABLE_LEVEL, gfn,
> 			 spte_to_pfn(sp->spt[i]), true, false,
> 			 host_writable);
> 
> It sets spte based on the old value that means the readonly flag check
> is missed. We need to call kvm_arch_flush_shadow_all under this case.

So the change needed will be in arch/x86.
	in arch_commit_* one.

Right?

Note: I'm not touching arch_* memory slot APIs now because ARM KVM
is coming now.  So no problem, the flags will be passed as before.

	Takuya
