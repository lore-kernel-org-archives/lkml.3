Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000AbaCZAb1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 20:31:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34483 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944AbaCZAbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 20:31:10 -0400
Date: Tue, 25 Mar 2014 17:30:29 -0700
From: tip-bot for Andy Lutomirski <tipbot@zytor.com>
Message-ID: <tip-b9a4a56c1e5c72eac92d18aa48250a8c965632be@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, luto@amacapital.net, hpa@zytor.com,
        mingo@kernel.org, stefani@seibold.net, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, luto@amacapital.net,
        linux-kernel@vger.kernel.org, stefani@seibold.net, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <d741449340642213744dd659471a35bb970a0c4c.1395789923.git.luto@amacapital.net>
References: <d741449340642213744dd659471a35bb970a0c4c.1395789923.git.luto@amacapital.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86, vdso, build: Don'
 t rebuild 32-bit vdsos on every make
Git-Commit-ID: b9a4a56c1e5c72eac92d18aa48250a8c965632be
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b9a4a56c1e5c72eac92d18aa48250a8c965632be
Gitweb:     http://git.kernel.org/tip/b9a4a56c1e5c72eac92d18aa48250a8c965632be
Author:     Andy Lutomirski <luto@amacapital.net>
AuthorDate: Tue, 25 Mar 2014 16:25:53 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 25 Mar 2014 17:08:58 -0700

x86, vdso, build: Don't rebuild 32-bit vdsos on every make

vdso32/vclock_gettime.o was confusing kbuild.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Cc: Stefani Seibold <stefani@seibold.net>
Link: http://lkml.kernel.org/r/d741449340642213744dd659471a35bb970a0c4c.1395789923.git.luto@amacapital.net
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/vdso/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index a2de5fc..6e6361a 100644
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -136,7 +136,7 @@ override obj-dirs = $(dir $(obj)) $(obj)/vdso32/
 
 targets += vdso32/vdso32.lds
 targets += $(vdso32-images) $(vdso32-images:=.dbg)
-targets += vdso32/note.o $(vdso32.so-y:%=vdso32/%.o)
+targets += vdso32/note.o vdso32/vclock_gettime.o $(vdso32.so-y:%=vdso32/%.o)
 
 extra-y	+= $(vdso32-images)
 
