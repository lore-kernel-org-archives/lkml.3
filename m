Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989AbaDCW2Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 18:28:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64619 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753725AbaDCW2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 18:28:13 -0400
From: Bandan Das <bsd@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [RFC PATCH 0/2] Emulator speedups - avoid initializations where possible
Date: Thu,  3 Apr 2014 18:27:48 -0400
Message-Id: <1396564070-5586-1-git-send-email-bsd@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While initializing emulation context structure, kvm memsets to 0 a 
number of fields some of which are redundant since they get set eventually.
This patch attempts at avoiding some of them.

Here are some before/after numbers on a Haswell host
Note : The before numbers already include Paolo's RFC posted here :
http://comments.gmane.org/gmane.linux.kernel/1676101

Before:
667 cycles/emulated jump instruction
839 cycles/emulated move instruction
892 cycles/emulated arithmetic instruction
995 cycles/emulated memory load instruction
1026 cycles/emulated memory store instruction
1022 cycles/emulated memory RMW instruction

After:
639 cycles/emulated jump instruction
786 cycles/emulated move instruction
802 cycles/emulated arithmetic instruction
936 cycles/emulated memory load instruction
970 cycles/emulated memory store instruction
1000 cycles/emulated memory RMW instruction

Bandan Das (2):
  KVM: emulate: move init_decode_cache to emulate.c
  KVM: emulate: clean up initializations in init_decode_cache

 arch/x86/include/asm/kvm_emulate.h | 17 +++++++------
 arch/x86/kvm/emulate.c             | 49 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c                 | 13 ----------
 3 files changed, 59 insertions(+), 20 deletions(-)

-- 
1.8.3.1

