Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827AbaCLS3x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 14:29:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52831 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538AbaCLS3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 14:29:51 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, x86@kernel.org
Cc: Stefani Seibold <stefani@seibold.net>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>,
        Martin Runge <Martin.Runge@rohde-schwarz.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v2 0/2] x86: Remove compat vdso support
Date: Wed, 12 Mar 2014 11:29:43 -0700
Message-Id: <cover.1394648864.git.luto@amacapital.net>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is in the spirit of throwing patches at the list to see what sticks :)

This is intended as an alternative to my compat vdso relocation patches
(http://thread.gmane.org/gmane.linux.kernel/1665080)

v1 of this patch was thoroughly nakked out of existence.  v2 is similar,
but might survive the nakking.  The critical difference is that this
version defaults to the compatible vdso-less mode instead of the modern
incompatible mode.

Changes from v1:
 - CONFIG_ENABLE_VDSO32_BY_DEFAULT now defaults to n
 - Improved the config text and description
 - Improved the kernel parameter docs

Andy Lutomirski (2):
  x86: Remove compat vdso support
  x86_32: Remove user bit from identity map PDE

 Documentation/kernel-parameters.txt  |  23 +++-
 arch/x86/Kconfig                     |  28 +++--
 arch/x86/include/asm/elf.h           |   4 -
 arch/x86/include/asm/fixmap.h        |   8 --
 arch/x86/include/asm/pgtable_types.h |   7 +-
 arch/x86/include/asm/vdso.h          |   5 +-
 arch/x86/vdso/vdso-layout.lds.S      |   2 +-
 arch/x86/vdso/vdso32-setup.c         | 234 ++++-------------------------------
 arch/x86/vdso/vdso32/vdso32.lds.S    |   2 -
 9 files changed, 62 insertions(+), 251 deletions(-)

-- 
1.8.5.3

