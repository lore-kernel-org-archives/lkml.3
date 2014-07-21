Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137AbaGUMdg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 08:33:36 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:54941 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754942AbaGUMde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 08:33:34 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: bdas@redhat.com, wanpeng.li@linux.intel.com, kvm@vger.kernel.org,
        jan.kiszka@siemens.com, mtosatti@redhat.com
Subject: [PATCH 0/2] KVM: nVMX: fix lifetime issues for vmcs02 and shadow VMCS
Date: Mon, 21 Jul 2014 14:33:23 +0200
Message-Id: <1405946005-4228-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think that commit 26a865f4aa8e (KVM: VMX: fix use after free of
vmx->loaded_vmcs, 2014-01-03) was wrong, as it introduced a use of
a dangling vmcs02. 

The first patch introduces what I think is the right fix, while the
second patch strengthens the invariants around nested_release_vmcs12.

Paolo Bonzini (2):
  KVM: nVMX: fix lifetime issues for vmcs02
  KVM: nVMX: clean up nested_release_vmcs12 and code around it

 arch/x86/kvm/vmx.c | 91 ++++++++++++++++++++++++++++++++----------------------
 1 file changed, 54 insertions(+), 37 deletions(-)

-- 
1.8.3.1

