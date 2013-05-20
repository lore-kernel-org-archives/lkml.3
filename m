Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758265Ab3ETVMF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 17:12:05 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:64785 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756576Ab3ETVMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 17:12:00 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org, kvm@vger.kernel.org,
        Sanjay Lal <sanjayl@kymasys.com>
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: [PATCH v3 0/5] mips/kvm: Fix ABI for compatibility with 64-bit guests.
Date: Mon, 20 May 2013 14:01:21 -0700
Message-Id: <1369083686-27524-1-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

The initial patch set implementing MIPS KVM does not handle 64-bit
guests or use of the FPU.  This patch set corrects these ABI issues,
and does some very minor clean up.

Changes from v2:  Split into five parts, no code change.

David Daney (5):
  mips/kvm: Fix ABI for use of FPU.
  mips/kvm: Fix ABI for use of 64-bit registers.
  mips/kvm: Fix name of gpr field in struct kvm_regs.
  mips/kvm: Use ARRAY_SIZE() instead of hardcoded constants in
    kvm_arch_vcpu_ioctl_{s,g}et_regs
  mips/kvm: Fix ABI by moving manipulation of CP0 registers to
    KVM_{G,S}ET_MSRS

 arch/mips/include/asm/kvm.h      | 111 ++++++++++---
 arch/mips/include/asm/kvm_host.h |   4 -
 arch/mips/kvm/kvm_mips.c         | 102 +-----------
 arch/mips/kvm/kvm_trap_emul.c    | 330 ++++++++++++++++++++++++++++++++++-----
 4 files changed, 386 insertions(+), 161 deletions(-)

-- 
1.7.11.7

