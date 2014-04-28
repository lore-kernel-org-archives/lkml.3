Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187AbaD1FA7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 01:00:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14773 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752874AbaD1FA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 01:00:56 -0400
From: Bandan Das <bsd@redhat.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] Emulate VMXON region correctly
Date: Mon, 28 Apr 2014 01:00:01 -0400
Message-Id: <1398661204-4822-1-git-send-email-bsd@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reference: https://bugzilla.kernel.org/show_bug.cgi?id=54521

The vmxon region is unused by nvmx, but adding these checks
are probably harmless and may detect buggy L1 hypervisors in 
the future!

Bandan Das (3):
  KVM: nVMX: rearrange get_vmx_mem_address
  KVM: nVMX: additional checks on vmxon region
  KVM: nVMX: fail on invalid vmclear/vmptrld pointer

 arch/x86/kvm/vmx.c | 171 ++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 118 insertions(+), 53 deletions(-)

-- 
1.8.3.1

