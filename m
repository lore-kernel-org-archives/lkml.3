Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326AbaDNXTv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 19:19:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50072 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085AbaDNXTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 19:19:49 -0400
Date: Mon, 14 Apr 2014 20:19:06 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [GIT PULL] KVM fixes for 3.15-rc1
Message-ID: <20140414231906.GA16088@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: ~/inbox/sent-mutt-Aug-2012
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Please pull from

git://git.kernel.org/pub/scm/virt/kvm/kvm.git master

To receive the following KVM fixes:

	- Fix for guest triggerable BUG_ON (CVE-2014-0155)
	- CR4.SMAP support
	- Spurious WARN_ON() fix

Feng Wu (5):
      KVM: Remove SMAP bit from CR4_RESERVED_BITS
      KVM: Add SMAP support when setting CR4
      KVM: Disable SMAP for guests in EPT realmode and EPT unpaging mode
      KVM: expose SMAP feature to guest
      KVM: Rename variable smep to cr4_smep

Marcelo Tosatti (1):
      KVM: x86: remove WARN_ON from get_kernel_ns()

Paolo Bonzini (2):
      KVM: ioapic: fix assignment of ioapic->rtc_status.pending_eoi (CVE-2014-0155)
      KVM: ioapic: try to recover if pending_eoi goes out of range

 arch/x86/include/asm/kvm_host.h |    2 -
 arch/x86/kvm/cpuid.c            |    2 -
 arch/x86/kvm/cpuid.h            |    8 +++++++
 arch/x86/kvm/mmu.c              |   40 ++++++++++++++++++++++++++++++------
 arch/x86/kvm/mmu.h              |   44 ++++++++++++++++++++++++++++++++--------
 arch/x86/kvm/paging_tmpl.h      |    2 -
 arch/x86/kvm/vmx.c              |   11 +++++-----
 arch/x86/kvm/x86.c              |   10 +++++++--
 virt/kvm/ioapic.c               |   25 +++++++++++++++++-----
 9 files changed, 114 insertions(+), 30 deletions(-)
