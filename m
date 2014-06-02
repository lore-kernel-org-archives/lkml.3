Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082AbaFBPed (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 11:34:33 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:7149 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762AbaFBPeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 11:34:31 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Au0BADuZjFOERCABjGdsb2JhbABYsiiNIYc+gRQWDgEBASc8gyWKE84PhUSOUh2EKgSKH4tcmm0
X-IPAS-Result: Au0BADuZjFOERCABjGdsb2JhbABYsiiNIYc+gRQWDgEBASc8gyWKE84PhUSOUh2EKgSKH4tcmm0
X-IronPort-AV: E=Sophos;i="4.98,957,1392156000"; 
   d="scan'208";a="109853125"
From: Nadav Amit <namit@cs.technion.ac.il>
To: pbonzini@redhat.com
Cc: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH 0/9] KVM: x86: Fixes for various emulator bugs
Date: Mon,  2 Jun 2014 18:34:02 +0300
Message-Id: <1401723251-8034-1-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The x86 emulator of KVM is buggy. This series of patches includes fixes for
various bugs which were detected. Each patch stands on its own.  Two patches do
not fix KVM emulation, but cause the emulator to fail more nicely by returning
an unhandlable error, instead of performing wrong emulation (VEX-prefix and
cmpxchg16b).  The fix for rdpmc is a bit intrusive to keep SVM behavior intact.

Thanks for reviewing the patches.

Nadav Amit (9):
  KVM: x86: Mark VEX-prefix instructions emulation as unimplemented
  KVM: x86: Emulator ignores LDTR/TR extended base on LLDT/LTR
  KVM: x86: Loading segments on 64-bit mode may be wrong
  KVM: x86: sgdt and sidt are not privilaged
  KVM: x86: cmpxchg emulation should compare in reverse order
  KVM: x86: movnti minimum op size of 32-bit is not kept
  KVM: x86: rdpmc emulation checks the counter incorrectly
  KVM: x86: Return error on cmpxchg16b emulation
  KVM: x86: smsw emulation is incorrect in 64-bit mode

 arch/x86/include/asm/kvm_emulate.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  1 +
 arch/x86/kvm/emulate.c             | 44 ++++++++++++++++++++++++++++----------
 arch/x86/kvm/pmu.c                 |  9 ++++++++
 arch/x86/kvm/x86.c                 |  7 ++++++
 5 files changed, 51 insertions(+), 11 deletions(-)

-- 
1.9.1

