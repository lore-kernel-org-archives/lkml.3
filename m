Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932550Ab3BITxB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 14:53:01 -0500
Received: from mail.skyhub.de ([78.46.96.112]:35118 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932514Ab3BITw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 14:52:59 -0500
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 0/5] x86, head_32: Some cleanups, -v2
Date: Sat,  9 Feb 2013 20:52:49 +0100
Message-Id: <1360439574-16122-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.1.3.535.ga923c31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>


Ok,

here's the next version with new_cpu_data left put and two minor fixlets
added at the end. The patchset was boot-tested on a bunch of baremetal
boxes and all QEMU cpu models - no issues.

Boot tests:

* baremetal:
- P4
- Atom n270
- 32-bit kernel on an AMD64 (F10h Phenom and Intel SNB)

* qemu, with cpu models:
 - qemu64
 - phenom
 - core2duo
 - kvm64
 - qemu32
 - kvm32
 - coreduo
 - 486{,SX}
 - pentium{,2,3}
 - athlon
 - n270,+movbe
 - Conroe
 - Penryn
 - Nehalem
 - Westmere
 - SandyBridge
 - Haswell
 - Opteron_G{1,2,3,4,5}

Why am I testing all those, you ask? Because I'm a sadistic mofo :-)

Changelog:

v1:

here are some initial low-hanging fruits wrt head_32.S cleanup. I've
made them as easily digestible as possible; after all, this is boot asm
and meddling with it tends to upset kernels.

Also, I've made the assumption that having boot_cpu_data.cpuid_level
contain the CPUID level for the boot cpu means that the APs have the
same CPUID level. This should be the case on X86.

They boot fine 486 and 486SX in qemu but I'd like to hear whether
the direction I'm going is ok before I continue testing them on real
hardware.


Borislav Petkov (5):
  x86, head_32: Remove i386 pieces
  x86: Detect CPUID support early at boot
  x86, head_32: Remove second CPUID detection from default_entry
  x86, head_32: Give the 6 label a real name
  x86, head_32: Remove an old gcc2 fix

 arch/x86/kernel/head_32.S | 92 ++++++++++++++++++-----------------------------
 1 file changed, 35 insertions(+), 57 deletions(-)

-- 
1.8.1.3.535.ga923c31

