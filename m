Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758068Ab3D2OEf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 10:04:35 -0400
Received: from mail.skyhub.de ([78.46.96.112]:54446 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752873Ab3D2OEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 10:04:33 -0400
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 0/3] FPU detection in C, second try
Date: Mon, 29 Apr 2013 16:04:19 +0200
Message-Id: <1367244262-29511-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.3.rc0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Right,

here's the fixed version which boots fine on everything I have here.
It would be nice if Ingo could test it on his K8 with the 32-bit
MATH_EMULATION config to make sure the corruptions don't happen anymore.

The second one is the sanity check for static_cpu_has which we discussed
yesterday.

And how cool is that: it already caught an unrelated issue in the FPU
code which resulted in patch #3. Fun.

Thanks.

Borislav Petkov (2):
  x86: Sanity-check static_cpu_has usage
  x86, FPU: Do not use static_cpu_has before alternatives

H. Peter Anvin (1):
  x86: Get rid of ->hard_math and all the FPU asm fu

 arch/x86/include/asm/cpufeature.h   | 23 ++++++++++++++-
 arch/x86/include/asm/fpu-internal.h |  4 +--
 arch/x86/include/asm/processor.h    |  3 +-
 arch/x86/kernel/asm-offsets_32.c    |  1 -
 arch/x86/kernel/cpu/bugs.c          | 21 ++-----------
 arch/x86/kernel/cpu/common.c        |  9 ++++--
 arch/x86/kernel/cpu/cyrix.c         |  2 +-
 arch/x86/kernel/cpu/proc.c          |  4 +--
 arch/x86/kernel/head_32.S           | 21 -------------
 arch/x86/kernel/i387.c              | 59 ++++++++++++++++++++++++++++++-------
 arch/x86/kernel/xsave.c             |  5 ++--
 arch/x86/lguest/boot.c              |  2 +-
 arch/x86/xen/enlighten.c            |  2 +-
 13 files changed, 89 insertions(+), 67 deletions(-)

-- 
1.8.3.rc0

