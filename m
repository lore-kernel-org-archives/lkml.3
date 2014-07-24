Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758823AbaGXLyV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 07:54:21 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:23314 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758794AbaGXLyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 07:54:19 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkoCAIDy0FOERCABjGdsb2JhbABZ1SUBgQwWEAEBASc9hAQBBXkQUVeIW7lVhlcXjmdkBxaEMAWKY6hdgWw
X-IPAS-Result: AkoCAIDy0FOERCABjGdsb2JhbABZ1SUBgQwWEAEBASc9hAQBBXkQUVeIW7lVhlcXjmdkBxaEMAWKY6hdgWw
X-IronPort-AV: E=Sophos;i="5.01,723,1400014800"; 
   d="scan'208";a="116773272"
From: Nadav Amit <namit@cs.technion.ac.il>
To: pbonzini@redhat.com
Cc: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org, nadav.amit@gmail.com,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH 0/2] KVM: x86: Missing rflags.rf fixes
Date: Thu, 24 Jul 2014 14:51:22 +0300
Message-Id: <1406202684-5226-1-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <53CD080A.1000400@redhat.com>
References: <53CD080A.1000400@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two patches address two remaining issues from the previous RF fixes
patch-set.  One is setting RF during rep-string emulation, so if the
instruction emulation is incomplete, the entry back to the guest will perfromed
with RF=1 so no instruction breakpoint would occur. The second sets RF when
injecting a fault to the guest.

Nadav Amit (2):
  KVM: x86: Setting rflags.rf during rep-string emulation
  KVM: x86: set rflags.rf during fault injection

 arch/x86/kvm/emulate.c |  6 +++++-
 arch/x86/kvm/x86.c     | 30 ++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+), 1 deletion(-)

-- 
1.9.1

