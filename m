Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883AbaCKWPe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 18:15:34 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:38070 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686AbaCKWPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 18:15:33 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, x86@kernel.org
Cc: Stefani Seibold <stefani@seibold.net>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>,
        Martin Runge <Martin.Runge@rohde-schwarz.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v2 0/2] x86: Relocate the compat vdso per process
Date: Tue, 11 Mar 2014 15:15:20 -0700
Message-Id: <cover.1394575968.git.luto@amacapital.net>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The meat of this patch series is in patch 1.  Patch 2 is split out for
improved bisectability.

Changes from v1: Split into two patches and fixed a comment.

Andy Lutomirski (2):
  x86: Dynamically relocate the compat vdso
  x86_32: Remove user bit from identity map PDE

 Documentation/kernel-parameters.txt  |  18 +++-
 arch/x86/Kconfig                     |  24 +++--
 arch/x86/include/asm/elf.h           |   4 -
 arch/x86/include/asm/fixmap.h        |   8 --
 arch/x86/include/asm/pgtable_types.h |   7 +-
 arch/x86/include/asm/vdso.h          |   5 +-
 arch/x86/vdso/vdso-layout.lds.S      |   2 +-
 arch/x86/vdso/vdso32-setup.c         | 173 ++++++++++++++++-------------------
 arch/x86/vdso/vdso32/vdso32.lds.S    |   2 -
 9 files changed, 111 insertions(+), 132 deletions(-)

-- 
1.8.5.3

