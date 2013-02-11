Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466Ab3BKOW1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 09:22:27 -0500
Received: from mail.skyhub.de ([78.46.96.112]:45167 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757129Ab3BKOWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 09:22:24 -0500
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 0/4 -v3]  x86, head_32: Some cleanups
Date: Mon, 11 Feb 2013 15:22:14 +0100
Message-Id: <1360592538-10643-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.1.3.535.ga923c31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Hi,

this is the new version with patch 5 from the old transformed into an
expanded, more verbose comment at the beginning of default_entry. No
changes otherwise.


Changelog:

v2:

Here's the next version with new_cpu_data left put and two minor fixlets
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

Borislav Petkov (4):
  x86, head_32: Remove i386 pieces
  x86: Detect CPUID support early at boot
  x86, head_32: Remove second CPUID detection from default_entry
  x86, head_32: Give the 6 label a real name

 arch/x86/kernel/head_32.S | 93 ++++++++++++++++++-----------------------------
 1 file changed, 36 insertions(+), 57 deletions(-)

-- 
1.8.1.3.535.ga923c31

