Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751241AbaDQXee (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 19:34:34 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:25281 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaDQXea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 19:34:30 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgAFAAdkUFOERM5e/2dsb2JhbABZgwa9PYc9gSIWdIMlUG+IDsYahhQXjmKEPwSJXKFfgzQ6
X-IPAS-Result: AgAFAAdkUFOERM5e/2dsb2JhbABZgwa9PYc9gSIWdIMlUG+IDsYahhQXjmKEPwSJXKFfgzQ6
X-IronPort-AV: E=Sophos;i="4.97,882,1389736800"; 
   d="scan'208";a="102880990"
From: Nadav Amit <namit@cs.technion.ac.il>
To: gleb@kernel.org, pbonzini@redhat.com
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH 0/5] KVM: x86: Fix KVM behavior that does not follow spec
Date: Fri, 18 Apr 2014 02:33:06 +0300
Message-Id: <1397777591-6147-1-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches fix various scenarios in which KVM behavior does not
follow x86 specifications.  Each patch actually deals with a separate bug.
These bugs can cause the guest to get stuck (i.e., make no progress), encounter
spurious injected exceptions, or cause guest code to misbehave. As a result
guest OS can potentially fail.

Thanks for reviewing the patches.

Nadav Amit (5):
  KVM: x86: Fix wrong/stuck PMU when guest does not use PMI
  KVM: x86: Fix CR3 reserved bits
  KVM: x86: IN instruction emulation should ignore REP-prefix
  KVM: x86: RSI/RDI/RCX are zero-extended when affected by string ops
  KVM: x86: Processor mode may be determined incorrectly

 arch/x86/include/asm/kvm_host.h |    6 +-----
 arch/x86/kvm/emulate.c          |   11 ++++++-----
 arch/x86/kvm/pmu.c              |    7 +++++--
 arch/x86/kvm/x86.c              |   27 ++++++---------------------
 4 files changed, 18 insertions(+), 33 deletions(-)

-- 
1.7.10.4

