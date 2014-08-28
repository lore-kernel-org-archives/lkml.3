Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751400AbaH1NOB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 09:14:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38507 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107AbaH1NN7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 09:13:59 -0400
From: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, kvm-ia64@vger.kernel.org,
        linux-s390@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH 0/2] KVM: minor cleanup and optimizations
Date: Thu, 28 Aug 2014 15:13:01 +0200
Message-Id: <1409231583-7048-1-git-send-email-rkrcmar@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first patch answers a demand for inline arch functions.
(There is a lot of constant functions that could be inlined as well.)

Second patch digs a bit into the history of KVM and removes a useless
argument that seemed suspicious when preparing the first patch.


Radim Krčmář (2):
  KVM: static inline empty kvm_arch functions
  KVM: remove garbage arg to *hardware_{en,dis}able

 arch/arm/include/asm/kvm_host.h     |  6 +++++
 arch/arm/kvm/arm.c                  | 21 +----------------
 arch/arm64/include/asm/kvm_host.h   |  6 +++++
 arch/ia64/include/asm/kvm_host.h    | 12 ++++++++++
 arch/ia64/kvm/kvm-ia64.c            | 34 ++--------------------------
 arch/mips/include/asm/kvm_host.h    | 11 +++++++++
 arch/mips/kvm/mips.c                | 44 +-----------------------------------
 arch/powerpc/include/asm/kvm_host.h |  8 +++++++
 arch/powerpc/kvm/powerpc.c          | 31 +------------------------
 arch/s390/include/asm/kvm_host.h    | 14 ++++++++++++
 arch/s390/kvm/kvm-s390.c            | 45 +------------------------------------
 arch/x86/include/asm/kvm_host.h     |  4 ++--
 arch/x86/kvm/svm.c                  |  4 ++--
 arch/x86/kvm/vmx.c                  |  4 ++--
 arch/x86/kvm/x86.c                  | 12 +++++-----
 include/linux/kvm_host.h            |  4 ++--
 virt/kvm/kvm_main.c                 |  4 ++--
 17 files changed, 79 insertions(+), 185 deletions(-)

-- 
2.1.0

