Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934574AbaE3V6x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 17:58:53 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:51035 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324AbaE3V6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 17:58:52 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: x86@kernel.org, linux-kernel@vger.kernel.org, linux-audit@redhat.com,
        Steve Grubb <sgrubb@redhat.com>, Eric Paris <eparis@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 0/2] Syscall auditing lite
Date: Fri, 30 May 2014 14:58:46 -0700
Message-Id: <cover.1401486790.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've made no secret of the fact that I dislike syscall auditing.  As far
as I can tell, the main technical (i.e. not compliance-related) use of
syscall auditing is to supply some useful context information to go
along with events like AVC denials.

CONFIG_AUDITSYSCALL is serious overkill to do this.  kernel/auditsc.c is
~2500 lines of terror.

This patchset accomplishes the same goal, more usefully, with no
overhead at all, in under 70 lines of code.  It tries to coexist cleanly
with CONFIG_AUDITSYSCALL.

This is only implemented for x86.  Other architectures can add support
fairly easily, I think.

Andy Lutomirski (2):
  x86,syscall: Add syscall_in_syscall to test whether we're in a syscall
  audit: Syscall auditing lite

 arch/x86/Kconfig               |  1 +
 arch/x86/include/asm/syscall.h | 21 ++++++++++++++++++++
 init/Kconfig                   |  3 +++
 kernel/audit.c                 | 44 +++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 68 insertions(+), 1 deletion(-)

-- 
1.9.3

