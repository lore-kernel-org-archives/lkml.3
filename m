Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578AbaCKIuB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 04:50:01 -0400
Received: from mailapp01.imgtec.com ([195.89.28.114]:36226 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347AbaCKIt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 04:49:59 -0400
From: Markos Chandras <markos.chandras@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: Markos Chandras <markos.chandras@imgtec.com>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <dborkman@redhat.com>, <netdev@vger.kernel.org>
Subject: [PATCH v2] tools/net/Makefile: Define PACKAGE to fix build problems
Date: Tue, 11 Mar 2014 08:49:39 +0000
Message-ID: <1394527779-6995-1-git-send-email-markos.chandras@imgtec.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394447988-31299-1-git-send-email-markos.chandras@imgtec.com>
References: <1394447988-31299-1-git-send-email-markos.chandras@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.154.136]
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
CC: netdev@vger.kernel.org
Acked-by: Daniel Borkmann <dborkman@redhat.com>
Signed-off-by: Markos Chandras <markos.chandras@imgtec.com>
---
Resend with netdev@vger.kernel.org on CC

Changes since v1:
- Drop the 'bfd' word from the subject as requested by David Miller
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

