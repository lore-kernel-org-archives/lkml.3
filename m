Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259AbaJ2Vdx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 17:33:53 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:58688 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755636AbaJ2Vdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 17:33:52 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: x86@kernel.org, linux-kernel@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>, Ingo Molnar <mingo@kernel.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v2 0/3] x86_64: Tidy up vsyscall emulation and make it optional
Date: Wed, 29 Oct 2014 14:33:44 -0700
Message-Id: <cover.1414618407.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that arch/x86/kernel/vsyscall_64.c contains only vsyscall
emulation code, clean it up and make it optional.

Patch 1 makes vsyscall=none work be a bit more self-consistent: it
actually removes the fake vsyscall page instead of just segfaulting
anyone who tries to use it.

Patch 2 is pure cosmetic cleanup.

Patch 3 is the meat: it lets vsyscall emulation be configured out.
The config option to disable it is hidden under CONFIG_EXPERT, since
it will break legacy code.

Note that, last I checked, current userspace is unlikely to work if
the vDSO *and* vsyscalls are off.  Take it up with the glibc
maintainers.

This applies on top of tip/x86/vdso.

Changes from v1:
 - Added Josh's Reviewed-by
 - Fixup up Xen bits in patch 3

Andy Lutomirski (3):
  x86_64,vsyscall: Turn vsyscalls all the way off when vsyscall=none
  x86_64,vsyscall: Rewrite comment and clean up headers in vsyscall code
  x86_64,vsyscall: Make vsyscall emulation configurable

 arch/x86/Kconfig                | 18 ++++++++++++
 arch/x86/include/asm/fixmap.h   |  2 ++
 arch/x86/include/asm/page_64.h  |  4 ++-
 arch/x86/include/asm/vsyscall.h |  8 +++++
 arch/x86/kernel/Makefile        |  3 +-
 arch/x86/kernel/setup.c         |  2 --
 arch/x86/kernel/vsyscall_64.c   | 65 +++++++++++++++++------------------------
 arch/x86/xen/mmu.c              |  6 ++--
 8 files changed, 63 insertions(+), 45 deletions(-)

-- 
1.9.3

