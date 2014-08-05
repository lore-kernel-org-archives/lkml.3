Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799AbaHETcf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 15:32:35 -0400
Received: from mail-yh0-f50.google.com ([209.85.213.50]:43976 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591AbaHETce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 15:32:34 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        "GitAuthor: Pranith Kumar" <bobby.prani@gmail.com>,
        linux-sh@vger.kernel.org (open list:SUPERH),
        linux-kernel@vger.kernel.org (open list)
Cc: Tony Breeds <tony@bakeyournoodle.com>, Guenter Roeck <linux@roeck-us.net>,
        Alexei Starovoitov <ast@plumgrid.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Daniel Borkmann <dborkman@redhat.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH RESEND 1/1] sh: Fix build error by adding generic ioport_{map/unmap}()
Date: Tue,  5 Aug 2014 15:32:39 -0400
Message-Id: <1407267160-15878-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resending with a bigger CC list. get_maintainer only picked up open lists.

Fix build error as reported by Geert Uytterhoeven here:
http://kisskb.ellerman.id.au/kisskb/buildresult/11607865/

The error happens when CONFIG_HAS_IOPORT_MAP=n because of which there are
missing definitions of ioport_map/unmap(). Fix this build error by adding these
prototypes.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 arch/sh/include/asm/io_noioport.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/sh/include/asm/io_noioport.h b/arch/sh/include/asm/io_noioport.h
index 4d48f14..c727e6d 100644
--- a/arch/sh/include/asm/io_noioport.h
+++ b/arch/sh/include/asm/io_noioport.h
@@ -34,6 +34,17 @@ static inline void outl(unsigned int x, unsigned long port)
 	BUG();
 }
 
+static inline void __iomem *ioport_map(unsigned long port, unsigned int size)
+{
+	BUG();
+	return NULL;
+}
+
+static inline void ioport_unmap(void __iomem *addr)
+{
+	BUG();
+}
+
 #define inb_p(addr)	inb(addr)
 #define inw_p(addr)	inw(addr)
 #define inl_p(addr)	inl(addr)
-- 
1.9.1

