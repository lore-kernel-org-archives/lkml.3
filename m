Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932327AbaIRQkH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 12:40:07 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:48161 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932092AbaIRQkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 12:40:05 -0400
From: Liang Chen <liangchen.linux@gmail.com>
To: pbonzini@redhat.com
Cc: rkrcmar@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Liang Chen <liangchen.linux@gmail.com>
Subject: [PATCH v3 0/2] KVM: count actual tlb flushes
Date: Thu, 18 Sep 2014 12:38:35 -0400
Message-Id: <1411058317-23646-1-git-send-email-liangchen.linux@gmail.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Instead of counting the number of coalesced flush requests,
  we count the actual tlb flushes.
* Flushes from kvm_flush_remote_tlbs will also be counted.
* Freeing the namespace a bit by replaces kvm_mmu_flush_tlb()
  with kvm_make_request() again.

---
v2 -> v3:

* split the patch into a series of two patches.
* rename the util function kvm_mmu_flush_tlb in x86.c to
  kvm_vcpu_flush_tlb

v1 -> v2:

* Instead of calling kvm_mmu_flush_tlb everywhere to make sure the
  stat is always incremented, postponing the counting to
  kvm_check_request.


Liang Chen (1):
  KVM: x86: directly use kvm_make_request again

Radim Krčmář (1):
  KVM: x86: count actual tlb flushes

 arch/x86/include/asm/kvm_host.h |  1 -
 arch/x86/kvm/mmu.c              | 17 +++++------------
 arch/x86/kvm/vmx.c              |  2 +-
 arch/x86/kvm/x86.c              | 13 ++++++++++---
 4 files changed, 16 insertions(+), 17 deletions(-)

-- 
1.9.1

