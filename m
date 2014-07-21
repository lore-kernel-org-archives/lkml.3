Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932343AbaGULlt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 07:41:49 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:56522 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754835AbaGULlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 07:41:06 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjcBAKb7zFOERCABjGdsb2JhbABZ0SUBgRoWDwEBASc9hAQBBXkQUVeIW7gnhkwXj0sHFoQwBYpfqDw
X-IPAS-Result: AjcBAKb7zFOERCABjGdsb2JhbABZ0SUBgRoWDwEBASc9hAQBBXkQUVeIW7gnhkwXj0sHFoQwBYpfqDw
X-IronPort-AV: E=Sophos;i="5.01,700,1400014800"; 
   d="scan'208";a="116353625"
From: Nadav Amit <namit@cs.technion.ac.il>
To: pbonzini@redhat.com
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        gleb@kernel.org, linux-kernel@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH kvm-unit-tests 0/3] x86: Test rflags.rf clearing/setting
Date: Mon, 21 Jul 2014 14:39:51 +0300
Message-Id: <1405942794-22681-1-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405942650-22589-1-git-send-email-namit@cs.technion.ac.il>
References: <1405942650-22589-1-git-send-email-namit@cs.technion.ac.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches introduces checks for rflags.rf and whether it is
cleared after emulation, and set correctly.  The last (third) patch fails even
with recent fixes, since there is no easy way for the hypervisor to determine
whether any iteration of rep-string was executed before. RFLAGS.RF should be
cleared before the first iteration, and set otherwise.

Nadav Amit (3):
  x86: Check rflags.rf is cleared after emulation
  x86: Test rflags.rf is set upon faults
  x86: Check RFLAGS.RF on interrupt during REP-str

 lib/x86/desc.c | 14 +++++++++++---
 lib/x86/desc.h |  1 +
 x86/eventinj.c | 16 ++++++++++++++++
 x86/idt_test.c | 13 +++++++++----
 x86/realmode.c |  3 ++-
 5 files changed, 39 insertions(+), 8 deletions(-)

-- 
1.9.1

