Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918AbaIWClb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 22:41:31 -0400
Received: from mail.kernel.org ([198.145.19.201]:38699 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755903AbaIWClL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 22:41:11 -0400
From: Zefan Li <lizf@kernel.org>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Michael Cree <mcree@orcon.net.nz>,
        Matt Turner <mattst88@gmail.com>, Guenter Roeck <linux@roeck-us.net>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 45/45] alpha: add io{read,write}{16,32}be functions
Date: Tue, 23 Sep 2014 10:31:47 +0800
Message-Id: <1411439507-30391-45-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411439259-30224-1-git-send-email-lizf@kernel.org>
References: <1411439259-30224-1-git-send-email-lizf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Cree <mcree@orcon.net.nz>

3.4.104-rc1 review patch.  If anyone has any objections, please let me know.

------------------

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
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 arch/alpha/include/asm/io.h |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/alpha/include/asm/io.h b/arch/alpha/include/asm/io.h
index 7a3d38d..5ebab58 100644
--- a/arch/alpha/include/asm/io.h
+++ b/arch/alpha/include/asm/io.h
@@ -489,6 +489,11 @@ extern inline void writeq(u64 b, volatile void __iomem *addr)
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
-- 
1.7.9.5

