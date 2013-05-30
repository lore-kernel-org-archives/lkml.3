Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759684Ab3E3TLh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 15:11:37 -0400
Received: from [207.46.163.27] ([207.46.163.27]:23226 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1759245Ab3E3TLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 15:11:03 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275dhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1155h)
X-WSS-ID: 0MNML81-01-TUZ-02
X-M-MSG: 
From: Jacob Shin <jacob.shin@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, <x86@kernel.org>
CC: Fenghua Yu <fenghua.yu@intel.com>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        Borislav Petkov <bp@alien8.de>, Joe Perches <joe@perches.com>,
        <linux-kernel@vger.kernel.org>, Jacob Shin <jacob.shin@amd.com>
Subject: [PATCH V3 0/4] x86/microcode: early microcode patch loading support on AMD
Date: Thu, 30 May 2013 14:09:15 -0500
Message-ID: <1369940959-2077-1-git-send-email-jacob.shin@amd.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patchset adds early microcode patch loading support on
AMD systems, on top of the framework introduced by:
  https://lkml.org/lkml/2012/12/21/193

V3:
* Moved early logic to microcode_amd_early.c
* Revised x86 vendor detection in microcode_core_early.c to use switch
  statement.
* Added AMD blurb to Documentation/x86/early-microcode.txt

V2:
* Fixed warnings when compiling without early loading
* Picked up a typo fix [PATCH 1/4] from Boris

Borislav Petkov (1):
  x86, microcode, intel: Correct typo in printk

Jacob Shin (3):
  x86/microcode: vendor abstract out save_microcode_in_initrd()
  x86/microcode/amd: refactor functions to prepare for early loading
  microcode/x86/amd: early microcode patch loading support for AMD

 Documentation/x86/early-microcode.txt   |   11 +-
 arch/x86/Kconfig                        |   14 +-
 arch/x86/include/asm/microcode_amd.h    |   78 +++++++++++
 arch/x86/include/asm/microcode_intel.h  |    2 +
 arch/x86/kernel/Makefile                |    1 +
 arch/x86/kernel/microcode_amd.c         |  133 +++++++++---------
 arch/x86/kernel/microcode_amd_early.c   |  222 +++++++++++++++++++++++++++++++
 arch/x86/kernel/microcode_core_early.c  |   49 ++++++-
 arch/x86/kernel/microcode_intel_early.c |    6 +-
 9 files changed, 429 insertions(+), 87 deletions(-)
 create mode 100644 arch/x86/include/asm/microcode_amd.h
 create mode 100644 arch/x86/kernel/microcode_amd_early.c

-- 
1.7.9.5


