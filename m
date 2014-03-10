Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564AbaCJOBw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 10:01:52 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:37387 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbaCJOBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 10:01:50 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@kernel.org
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v4 0/5] KVM: x86: flush tlb out of mmu-lock after write protection
Date: Mon, 10 Mar 2014 22:01:44 +0800
Message-Id: <1394460109-3150-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14031014-7014-0000-0000-0000047B18ED
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is splited from my previous patchset:
[PATCH v3 00/15] KVM: MMU: locklessly write-protect
that can be found at:
https://lkml.org/lkml/2013/10/23/265

Changelog v4 :
- add more comments for patch 5 and thank for Marcelo's review

Xiao Guangrong (5):
  Revert "KVM: Simplify kvm->tlbs_dirty handling"
  KVM: MMU: properly check last spte in fast_page_fault()
  KVM: MMU: lazily drop large spte
  KVM: MMU: flush tlb if the spte can be locklessly modified
  KVM: MMU: flush tlb out of mmu lock when write-protect the sptes

 arch/x86/kvm/mmu.c         | 72 ++++++++++++++++++++++++++++++----------------
 arch/x86/kvm/mmu.h         | 14 +++++++++
 arch/x86/kvm/paging_tmpl.h |  7 ++---
 arch/x86/kvm/x86.c         | 20 ++++++++++---
 include/linux/kvm_host.h   |  4 +--
 virt/kvm/kvm_main.c        |  5 +++-
 6 files changed, 85 insertions(+), 37 deletions(-)

-- 
1.8.1.4

