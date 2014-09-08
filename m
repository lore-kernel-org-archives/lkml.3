Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299AbaIHRr6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 13:47:58 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:53842 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752776AbaIHRry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 13:47:54 -0400
X-Greylist: delayed 593 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Sep 2014 13:47:54 EDT
X-Sasl-enc: g226UhVADtQRRiVlmL1Gft9304SF0eyBX+w0dXjEyLFM 1410197882
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-kernel@vger.kernel.org
Cc: Borislav Petkov <bp@alien8.de>, H Peter Anvin <hpa@zytor.com>
Subject: [PATCH 0/8] x86, microcode, intel: fixes and enhancements
Date: Mon,  8 Sep 2014 14:37:46 -0300
Message-Id: <1410197875-19252-1-git-send-email-hmh@hmh.eng.br>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset applies on top of:
git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git microcode

It includes a regression fix (patch 2), an architectural requirement
violation fix (patch 7), and several enhancements.

Patch 7 (x86, microcode, intel: guard against misaligned microcode data)
has to align and restore the microcode data for each core that needs an
update.  The extra time to align the microcode data was not noticeable
in simple testing: it got lost in the noise of WRMSR 0x79.

FWIW, iucode-tool v1.0.3+ (https://gitorious.org/iucode-tool/pages/Home)
will pre-align the microcode in the early-initramfs, so that the kernel
won't have to do it.  Patch 7 documents two hacks to pre-align the
microcode data inside the early-initramfs so that people can write their
own tools to do it, if they want to.

Henrique de Moraes Holschuh (8):
  x86, microcode, intel: forbid some incorrect metadata
  x86, microcode, intel: don't update each HT core twice
  x86, microcode, intel: clarify log messages
  x86, microcode, intel: add error logging to early update driver
  x86, microcode, intel: don't check extsig entry checksum
  x86, microcode, intel: use cpuid explicitly instead of sync_core
  x86, microcode, intel: guard against misaligned microcode data
  x86, microcode, intel: defend apply_microcode_intel with BUG_ON

 Documentation/x86/early-microcode.txt       |   10 ++
 arch/x86/include/asm/microcode_intel.h      |   12 ++
 arch/x86/kernel/cpu/microcode/intel.c       |   58 ++++++----
 arch/x86/kernel/cpu/microcode/intel_early.c |  158 ++++++++++++++++-----------
 arch/x86/kernel/cpu/microcode/intel_lib.c   |   55 +++++-----
 5 files changed, 186 insertions(+), 107 deletions(-)

-- 
1.7.10.4

