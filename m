Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984AbaDQJFp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 05:05:45 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:38745 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331AbaDQJFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 05:05:43 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@kernel.org
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v5 0/5] KVM: x86: flush tlb out of mmu-lock after write protection
Date: Thu, 17 Apr 2014 17:06:11 +0800
Message-Id: <1397725576-6617-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14041709-5140-0000-0000-000004F02371
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since Marcelo has agreed the comments improving in the off-line mail, i
consider this is his Ack. :) Please let me know If i misunderstood it.

This patchset is splited from my previous patchset:
[PATCH v3 00/15] KVM: MMU: locklessly write-protect
that can be found at:
https://lkml.org/lkml/2013/10/23/265

Changelog v5:
- improve some comments addressing Marcelo's suggestion

Changelog v4:
- add more comments for patch 5 and thank for Marcelo's review

Xiao Guangrong (5):
  Revert "KVM: Simplify kvm->tlbs_dirty handling"
  KVM: MMU: properly check last spte in fast_page_fault()
  KVM: MMU: lazily drop large spte
  KVM: MMU: flush tlb if the spte can be locklessly modified
  KVM: MMU: flush tlb out of mmu lock when write-protect the sptes

 arch/x86/kvm/mmu.c         | 72 ++++++++++++++++++++++++++++++----------------
 arch/x86/kvm/mmu.h         | 33 +++++++++++++++++++++
 arch/x86/kvm/paging_tmpl.h |  7 ++---
 arch/x86/kvm/x86.c         | 20 ++++++++++---
 include/linux/kvm_host.h   |  4 +--
 virt/kvm/kvm_main.c        |  5 +++-
 6 files changed, 104 insertions(+), 37 deletions(-)

-- 
1.8.1.4

