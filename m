Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936771Ab3DHP6H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 11:58:07 -0400
Received: from mail.skyhub.de ([78.46.96.112]:43447 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936668Ab3DHP6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 11:58:05 -0400
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 0/4] x86: FPU detection in C
Date: Mon,  8 Apr 2013 17:57:42 +0200
Message-Id: <1365436666-9837-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.2.135.g7b592fa
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Hi,

so this is the final result. Patches boot on every qemu cpu model and on
two baremetal configs here.

The three patches after yours are some small fixlets for issues I
spotted while testing.

Thanks.

Borislav Petkov (3):
  x86: Fold-in trivial check_config function
  x86, AMD: Correct {rd,wr}msr_amd_safe warnings
  x86, CPU, AMD: Drop useless label

H. Peter Anvin (1):
  x86: Get rid of ->hard_math and all the FPU asm fu

 arch/x86/include/asm/fpu-internal.h |  2 --
 arch/x86/include/asm/processor.h    |  3 +-
 arch/x86/kernel/asm-offsets_32.c    |  1 -
 arch/x86/kernel/cpu/amd.c           | 17 +++++------
 arch/x86/kernel/cpu/bugs.c          | 48 ++++++++----------------------
 arch/x86/kernel/cpu/common.c        |  3 +-
 arch/x86/kernel/cpu/cyrix.c         |  2 +-
 arch/x86/kernel/cpu/proc.c          |  4 +--
 arch/x86/kernel/head_32.S           | 21 -------------
 arch/x86/kernel/i387.c              | 59 ++++++++++++++++++++++++++++++-------
 arch/x86/kernel/xsave.c             |  5 ++--
 arch/x86/lguest/boot.c              |  2 +-
 arch/x86/xen/enlighten.c            |  2 +-
 13 files changed, 78 insertions(+), 91 deletions(-)

-- 
1.8.2.135.g7b592fa

