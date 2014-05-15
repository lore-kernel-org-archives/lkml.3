Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352AbaEOQvo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 12:51:44 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:36940 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754226AbaEOQvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 12:51:41 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: jan.kiszka@siemens.com, kvm@vger.kernel.org, gleb@kernel.org,
        avi.kivity@gmail.com
Subject: [PATCH v2 0/4] KVM: x86: get CPL from SS.DPL
Date: Thu, 15 May 2014 18:51:27 +0200
Message-Id: <1400172691-27030-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another day, another CPL patch...

It turns out that the simple approach of getting CPL from SS.DPL
broke x86/taskswitch2.flat.  To fix that, already "imagine" that the
CPL is CS.RPL, or 3 for VM86 tasks, while loading segment descriptors
during task switches.  This removes the hack where task switches call
kvm_set_rflags to override the VM flag (patch 2).

While at it, add a new privilege test during task switches that is
missing.

Patch 4 is the same as before.

Paolo Bonzini (4):
  KVM: x86: use new CS.RPL as CPL during task switch
  KVM: x86: drop set_rflags callback
  KVM: x86: check CS.DPL against RPL during task switch
  KVM: x86: get CPL from SS.DPL

 arch/x86/include/asm/kvm_emulate.h |  1 -
 arch/x86/include/asm/kvm_host.h    |  1 -
 arch/x86/kvm/emulate.c             | 63 ++++++++++++++++++++++----------------
 arch/x86/kvm/svm.c                 | 35 +++++++++------------
 arch/x86/kvm/vmx.c                 | 24 +++------------
 arch/x86/kvm/x86.c                 |  6 ----
 6 files changed, 54 insertions(+), 76 deletions(-)

-- 
1.8.3.1

