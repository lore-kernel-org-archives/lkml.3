Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbaFKUXM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 16:23:12 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:43588 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbaFKUXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 16:23:09 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>
Cc: Oleg Nesterov <oleg@redhat.com>, x86@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org,
        linux-arch@vger.kernel.org, linux-security-module@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>
Subject: [RFC 0/5] Two-phase seccomp and an x86_64 fast path
Date: Wed, 11 Jun 2014 13:22:57 -0700
Message-Id: <cover.1402517933.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On my VM, getpid takes about 70ns.  Before this patchset, adding a
single-instruction always-accept seccomp filter added about 134ns of
overhead to getpid.  With this patchset, the overhead is down to about
13ns.

I'd really appreciate careful review from all relevant arch
maintainers for patch 1.

This is an RFC for now.  I'll submit a non-RFC version after the merge
window ends.

Andy Lutomirski (5):
  seccomp,x86,arm,mips,s390: Remove nr parameter from secure_computing
  x86_64,entry: Treat regs->ax the same in fastpath and slowpath
    syscalls
  seccomp: Refactor the filter callback and the API
  seccomp: Allow arch code to provide seccomp_data
  x86,seccomp: Add a seccomp fastpath

 arch/arm/kernel/ptrace.c       |   7 +-
 arch/mips/kernel/ptrace.c      |   2 +-
 arch/s390/kernel/ptrace.c      |   2 +-
 arch/x86/include/asm/calling.h |   6 +-
 arch/x86/kernel/entry_64.S     |  52 ++++++++-
 arch/x86/kernel/ptrace.c       |   2 +-
 arch/x86/kernel/vsyscall_64.c  |   2 +-
 include/linux/seccomp.h        |  25 +++--
 kernel/seccomp.c               | 244 +++++++++++++++++++++++++++--------------
 9 files changed, 241 insertions(+), 101 deletions(-)

-- 
1.9.3

