Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007Ab3G3PLq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 11:11:46 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:51928 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084Ab3G3PLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 11:11:43 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gnatapov@redhat.com, kvm@vger.kernel.org
Subject: [PATCH 0/2] KVM: x86: minimal debugging support during emulation
Date: Tue, 30 Jul 2013 17:11:33 +0200
Message-Id: <1375197096-2454-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The switch to emulate_invalid_guest_state brought one slightly unwelcome
change; the debugging interface does not work in the initial boot phase
because KVM_SET_GUEST_DEBUG is basically ignored.

These two patches bring some initial support for debugging, namely for
hardware breakpoints and single-stepping.  Software breakpoints and
hardware watchpoints are still ignored.

Paolo

v1->v2: rename EMULATE_DO_MMIO to EMULATE_USER_EXIT;
    return EMULATE_* value via pointer-to-int argument.

Paolo Bonzini (3):
  KVM: x86: rename EMULATE_DO_MMIO
  KVM: x86: handle hardware breakpoints during emulation
  KVM: x86: handle singlestep during emulation

 arch/x86/include/asm/kvm_host.h |   4 +-
 arch/x86/kvm/mmu.c              |   2 +-
 arch/x86/kvm/vmx.c              |   2 +-
 arch/x86/kvm/x86.c              | 109 ++++++++++++++++++++++++++++++++++++++--
 4 files changed, 110 insertions(+), 7 deletions(-)

-- 
1.8.1.4

