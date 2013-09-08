Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759680Ab3IHDVO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:21:14 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56166 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756668Ab3IHDS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:18:57 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Michal Simek" <monstr@monstr.eu>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.818011895@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [115/121] microblaze: Fix __futex_atomic_op macro register usage
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Simek <monstr@monstr.eu>

commit 8cf662ed3ef190fddc186bb5b1cd75eb3880d5a9 upstream.

Old Microblaze toolchain supported "b" contstrains for
all register but it always points to general purpose reg.
New Microblaze toolchain is more strict in this
and general purpose register should be used there "r".

Signed-off-by: Michal Simek <monstr@monstr.eu>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/microblaze/include/asm/futex.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/microblaze/include/asm/futex.h b/arch/microblaze/include/asm/futex.h
index b0526d2..ff8cde1 100644
--- a/arch/microblaze/include/asm/futex.h
+++ b/arch/microblaze/include/asm/futex.h
@@ -24,7 +24,7 @@
 			.word	1b,4b,2b,4b;				\
 			.previous;"					\
 	: "=&r" (oldval), "=&r" (ret)					\
-	: "b" (uaddr), "i" (-EFAULT), "r" (oparg)			\
+	: "r" (uaddr), "i" (-EFAULT), "r" (oparg)			\
 	);								\
 })
 

