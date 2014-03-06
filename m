Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951AbaCFJQL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 04:16:11 -0500
Received: from mailapp01.imgtec.com ([195.89.28.115]:34968 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbaCFJQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 04:16:08 -0500
X-Greylist: delayed 2324 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Mar 2014 04:16:08 EST
From: Markos Chandras <markos.chandras@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: Markos Chandras <markos.chandras@imgtec.com>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <dborkman@redhat.com>
Subject: [PATCH] tools/net/Makefile: Define PACKAGE to fix bfd build problems
Date: Thu, 6 Mar 2014 09:15:54 +0000
Message-ID: <1394097354-5290-1-git-send-email-markos.chandras@imgtec.com>
X-Mailer: git-send-email 1.9.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.154.47]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the following build problem with binutils-2.24

gcc -Wall -O2   -c -o bpf_jit_disasm.o bpf_jit_disasm.c
In file included from bpf_jit_disasm.c:25:0:
/usr/include/bfd.h:35:2: error: #error config.h must be included
before this header
 #error config.h must be included before this header

This is similar to commit 3ce711a6abc27abce1554e1d671a8762b7187690
"perf tools: bfd.h/libbfd detection fails with recent binutils"

See: https://sourceware.org/bugzilla/show_bug.cgi?id=14243

CC: David S. Miller <davem@davemloft.net>
CC: Daniel Borkmann <dborkman@redhat.com>
Signed-off-by: Markos Chandras <markos.chandras@imgtec.com>
---
 tools/net/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/net/Makefile b/tools/net/Makefile
index 004cd74..ee577ea 100644
--- a/tools/net/Makefile
+++ b/tools/net/Makefile
@@ -12,7 +12,7 @@ YACC = bison
 
 all : bpf_jit_disasm bpf_dbg bpf_asm
 
-bpf_jit_disasm : CFLAGS = -Wall -O2
+bpf_jit_disasm : CFLAGS = -Wall -O2 -DPACKAGE='bpf_jit_disasm'
 bpf_jit_disasm : LDLIBS = -lopcodes -lbfd -ldl
 bpf_jit_disasm : bpf_jit_disasm.o
 
-- 
1.9.0

