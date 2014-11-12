Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932608AbaKLB2p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:28:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59090 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932580AbaKLB2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:28:38 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Alex Smith <alex@alex-smith.me.uk>, linux-mips@linux-mips.org,
        Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH 3.17 144/319] MIPS: ptrace.h: Add a missing include
Date: Wed, 12 Nov 2014 10:14:42 +0900
Message-Id: <20141112011016.330887734@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaro Koskinen <aaro.koskinen@iki.fi>

commit cdb685ad44996e9a113a10002cb42d40ff29db99 upstream.

Commit a79ebea62010 (MIPS: ptrace: Fix user pt_regs definition,
use in ptrace_{get, set}regs()) converted struct pt_regs to use __u64.
Some userspace applications (e.g. GDB) include this file directly,
and fail to see this type. Fix by including <linux/types.h>.

The patch fixes the following build failure with GDB 7.8 when using
GLIBC headers created against Linux 3.17:

In file included from /home/aaro/los/work/shared/gdb-7.8/gdb/mips-linux-nat.c:37:0:
/home/aaro/los/work/mips/rootfs/mips-linux-gnu/usr/include/asm/ptrace.h:32:2: error: unknown type name '__u64'
  __u64 regs[32];
  ^
/home/aaro/los/work/mips/rootfs/mips-linux-gnu/usr/include/asm/ptrace.h:35:2: error: unknown type name '__u64'
  __u64 lo;
  ^
/home/aaro/los/work/mips/rootfs/mips-linux-gnu/usr/include/asm/ptrace.h:36:2: error: unknown type name '__u64'
  __u64 hi;
  ^

Fixes: a79ebea62010 ("MIPS: ptrace: Fix user pt_regs definition, use in ptrace_{get, set}regs()")
Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Alex Smith <alex@alex-smith.me.uk>
Cc: linux-mips@linux-mips.org
Patchwork: https://patchwork.linux-mips.org/patch/8067/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/include/uapi/asm/ptrace.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/mips/include/uapi/asm/ptrace.h
+++ b/arch/mips/include/uapi/asm/ptrace.h
@@ -9,6 +9,8 @@
 #ifndef _UAPI_ASM_PTRACE_H
 #define _UAPI_ASM_PTRACE_H
 
+#include <linux/types.h>
+
 /* 0 - 31 are integer registers, 32 - 63 are fp registers.  */
 #define FPR_BASE	32
 #define PC		64


