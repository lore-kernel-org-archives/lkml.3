Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760203AbaJ3OIt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 10:08:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54071 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686AbaJ3OIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 10:08:47 -0400
From: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Gleb Natapov <gleb@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 0/3] kvm: APICv register write workaround
Date: Thu, 30 Oct 2014 15:06:44 +0100
Message-Id: <1414678007-9377-1-git-send-email-rkrcmar@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

APICv traps register writes, so we can't retrieve previous value, but
our code depends on detecting changes.

Apart from disabling APIC register virtualization, we can detect the
change by using extra memory.  One value history is enough, but we still
don't want to keep it for every APIC register, for performance reasons.
This leaves us with either a new framework, or exceptions ...
The latter options fits KVM's path better [1,2].

And when we already mirror a part of registers, optimizing access is
acceptable [3].  (Squashed to keep bisecters happy.)

---
Radim Krčmář (3):
  KVM: x86: detect SPIV changes under APICv
  KVM: x86: detect LVTT changes under APICv
  KVM: x86: optimize some accesses to LVTT and SPIV

 arch/x86/kvm/lapic.c | 32 +++++++++++++++++---------------
 arch/x86/kvm/lapic.h |  8 +++++---
 2 files changed, 22 insertions(+), 18 deletions(-)

-- 
2.1.0

