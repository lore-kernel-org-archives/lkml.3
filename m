Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001AbbAEPAU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 10:00:20 -0500
Received: from mail.skyhub.de ([78.46.96.112]:51550 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753202AbbAEPAQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 10:00:16 -0500
From: Borislav Petkov <bp@alien8.de>
To: X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH 0/4] x86, alternatives: Insn padding and more robust JMPs
Date: Mon,  5 Jan 2015 16:00:09 +0100
Message-Id: <1420470013-26413-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 2.2.0.33.gc18b867
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Hi all,

this is something which hpa and I talked about recently: the ability for
the alternatives code to add padding to the original instruction in case
the replacement is longer and also to be able to simply write "jmp" and
not care about which JMP exactly the compiler generates and whether the
relative offsets are correct.

So this is a stab at it, it seems to boot in kvm here but it needs more
staring to make sure we're actually generating the proper code at all
times.

Thus the RFC tag, comments/suggestions are welcome.

Thanks.

Borislav Petkov (4):
  x86, copy_user: Remove FIX_ALIGNMENT define
  x86, alternatives: Cleanup DPRINTK macro
  alternatives: Add instruction padding
  alternatives: Make JMPs more robust

 arch/x86/include/asm/alternative-asm.h |  38 ++++++++++
 arch/x86/include/asm/alternative.h     |  34 +++++----
 arch/x86/include/asm/cpufeature.h      |  12 +--
 arch/x86/kernel/alternative.c          | 130 +++++++++++++++++++++++++++------
 arch/x86/lib/copy_page_64.S            |  34 ++++-----
 arch/x86/lib/copy_user_64.S            |  44 ++---------
 6 files changed, 193 insertions(+), 99 deletions(-)

-- 
2.2.0.33.gc18b867

