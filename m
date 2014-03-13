Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911AbaCMXBd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 19:01:33 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:38509 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754191AbaCMXBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 19:01:32 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, x86@kernel.org
Cc: Stefani Seibold <stefani@seibold.net>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>,
        Martin Runge <Martin.Runge@rohde-schwarz.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v4 0/2] x86: Remove compat vdso support
Date: Thu, 13 Mar 2014 16:01:25 -0700
Message-Id: <cover.1394751608.git.luto@amacapital.net>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This applies to -linus and should replace tip/x86/vdso -- Stefani
will presumably rebase the rest of that branch.

Changes from v3:
 - Don't rename the config option
 - Switch the default value of CONFIG_COMPAT_VDSO
 - Fix numerous typos in comments and docs

Changes from v2: Update a comment that I missed.

Changes from v1:
 - CONFIG_ENABLE_VDSO32_BY_DEFAULT now defaults to n
 - Improved the config text and description
 - Improved the kernel parameter docs

Andy Lutomirski (2):
  x86: Remove compat vdso support
  x86_32: Remove user bit from identity map PDE

 Documentation/kernel-parameters.txt  |  22 +++-
 arch/x86/Kconfig                     |  26 ++--
 arch/x86/include/asm/elf.h           |   4 -
 arch/x86/include/asm/fixmap.h        |   8 --
 arch/x86/include/asm/pgtable_types.h |   7 +-
 arch/x86/include/asm/vdso.h          |   5 +-
 arch/x86/vdso/vdso-layout.lds.S      |   2 +-
 arch/x86/vdso/vdso32-setup.c         | 232 ++++-------------------------------
 arch/x86/vdso/vdso32/vdso32.lds.S    |   2 -
 9 files changed, 59 insertions(+), 249 deletions(-)

-- 
1.8.5.3

