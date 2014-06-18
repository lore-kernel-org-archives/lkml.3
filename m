Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966767AbaFROT4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 10:19:56 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:38610 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbaFROTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 10:19:49 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Au4BACOfoVOERCABjGdsb2JhbABarlABAQaDXo4Gh0SBChYPAQEBJzyFA4oTxxuFdYViiRMdhC0EijmnJw
X-IPAS-Result: Au4BACOfoVOERCABjGdsb2JhbABarlABAQaDXo4Gh0SBChYPAQEBJzyFA4oTxxuFdYViiRMdhC0EijmnJw
X-IronPort-AV: E=Sophos;i="5.01,501,1400014800"; 
   d="scan'208";a="112034605"
From: Nadav Amit <namit@cs.technion.ac.il>
To: pbonzini@redhat.com
Cc: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        joro@8bytes.org, Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH 0/3] Correct monitor-mwait emulation as nop
Date: Wed, 18 Jun 2014 17:19:33 +0300
Message-Id: <1403101176-23664-1-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KVM handles monitor-mwait as nop, but does not check any of the preconditions
for the instructions.  These instructions may generate all kind of exceptions
(#UD, #PF, #GP, #SS). They can also be executed in real-mode.  This patch-set
moves the handling of monitor-mwait to the emulator, to allow their execution
in either real-mode or protected-mode.  It tries to follow the SDM in checking
the preconditions and generating the necassary exceptions.

Thanks for reviewing the patch. Please try it with OS X to make sure it works
properly without generating unnecassary exception.

Nadav Amit (3):
  KVM: x86: Emulator flag for instruction with no big real mode
  KVM: x86: Emulator support for #UD on CPL>0
  KVM: x86: correct mwait and monitor emulation

 arch/x86/kvm/emulate.c | 55 ++++++++++++++++++++++++++++++++++++++++++++++----
 arch/x86/kvm/svm.c     | 22 ++------------------
 arch/x86/kvm/vmx.c     | 27 ++++++++++---------------
 3 files changed, 64 insertions(+), 40 deletions(-)

-- 
1.9.1

