Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549AbaHDQ7P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 12:59:15 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56565 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752013AbaHDQt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:49:56 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Michael Cree" <mcree@orcon.net.nz>,
        "=?UTF-8?Q?Ra=C3=BAl=20?=Porcel" <armin76@gentoo.org>,
        "Matt Turner" <mattst88@gmail.com>
Date: Mon, 04 Aug 2014 17:48:32 +0100
Message-ID: <lsq.1407170912.550321139@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 77/94] alpha: add io{read,write}{16,32}be functions
In-Reply-To: <lsq.1407170911.107020799@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.62-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Cree <mcree@orcon.net.nz>

commit 25534eb7707821b796fd84f7115367e02f36aa60 upstream.

These functions are used in some PCI drivers with big-endian
MMIO space.

Admittedly it is almost certain that no one this side of the
Moon would use such a card in an Alpha but it does get us
closer to being able to build allyesconfig or allmodconfig,
and it enables the Debian default generic config to build.

Tested-by: Raúl Porcel <armin76@gentoo.org>
Signed-off-by: Michael Cree <mcree@orcon.net.nz>
Signed-off-by: Matt Turner <mattst88@gmail.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/alpha/include/asm/io.h | 5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/alpha/include/asm/io.h
+++ b/arch/alpha/include/asm/io.h
@@ -490,6 +490,11 @@ extern inline void writeq(u64 b, volatil
 }
 #endif
 
+#define ioread16be(p) be16_to_cpu(ioread16(p))
+#define ioread32be(p) be32_to_cpu(ioread32(p))
+#define iowrite16be(v,p) iowrite16(cpu_to_be16(v), (p))
+#define iowrite32be(v,p) iowrite32(cpu_to_be32(v), (p))
+
 #define inb_p		inb
 #define inw_p		inw
 #define inl_p		inl

