Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932092Ab3EWPlG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 11:41:06 -0400
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:10462
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757617Ab3EWPk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 11:40:28 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275dhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dc1h1155h)
X-WSS-ID: 0MN9CV5-02-51P-02
X-M-MSG: 
From: Jacob Shin <jacob.shin@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, <x86@kernel.org>
CC: Fenghua Yu <fenghua.yu@intel.com>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        Borislav Petkov <bp@alien8.de>, <linux-kernel@vger.kernel.org>,
        Jacob Shin <jacob.shin@amd.com>
Subject: [PATCH V2 0/3] x86/microcode: early microcode patch loading support on AMD
Date: Thu, 23 May 2013 10:40:15 -0500
Message-ID: <1369323618-5820-1-git-send-email-jacob.shin@amd.com>
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

V2:
* Fixed warnings when compiling without early loading
* Picked up a typo fix [PATCH 2/3] from Boris

Borislav Petkov (1):
  x86, microcode, intel: Correct typo in printk

Jacob Shin (2):
  x86/microcode: vendor abstract out save_microcode_in_initrd()
  x86/microcode: early microcode patch loading support on AMD

 arch/x86/Kconfig                        |   16 +-
 arch/x86/include/asm/microcode.h        |    1 -
 arch/x86/include/asm/microcode_amd.h    |   14 ++
 arch/x86/include/asm/microcode_intel.h  |    3 +
 arch/x86/kernel/microcode_amd.c         |  338 +++++++++++++++++++++++++++----
 arch/x86/kernel/microcode_core_early.c  |   17 ++
 arch/x86/kernel/microcode_intel_early.c |    4 +-
 7 files changed, 344 insertions(+), 49 deletions(-)
 create mode 100644 arch/x86/include/asm/microcode_amd.h

-- 
1.7.9.5


