Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169AbaHDQxJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 12:53:09 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56685 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752276AbaHDQt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:49:59 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Guan Xuetao" <gxt@mprc.pku.edu.cn>,
        "Jonas Bonn" <jonas@southpole.se>, "Arnd Bergmann" <arnd@arndb.de>
Date: Mon, 04 Aug 2014 17:48:32 +0100
Message-ID: <lsq.1407170912.229441953@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 73/94] unicore32: add ioremap_nocache definition
In-Reply-To: <lsq.1407170911.107020799@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.62-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Guan Xuetao <gxt@mprc.pku.edu.cn>

commit a50e4213e71adc7dde0d514aabd8af7275fee39f upstream.

Bugfix for following error messages:
lib/iomap.c: In function 'pci_iomap':
lib/iomap.c:274: error: implicit declaration of function 'ioremap_nocache'
lib/iomap.c:274: warning: return makes pointer from integer without a cast

Also see commit <f1ecc69838a2d7c8a3e1909f637d4083c071777d>
  it will hide the ioremap_nocache function for systems with an MMU

Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Jonas Bonn <jonas@southpole.se>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/unicore32/include/asm/io.h | 1 +
 1 file changed, 1 insertion(+)

--- a/arch/unicore32/include/asm/io.h
+++ b/arch/unicore32/include/asm/io.h
@@ -37,6 +37,7 @@ extern void __uc32_iounmap(volatile void
  */
 #define ioremap(cookie, size)		__uc32_ioremap(cookie, size)
 #define ioremap_cached(cookie, size)	__uc32_ioremap_cached(cookie, size)
+#define ioremap_nocache(cookie, size)	__uc32_ioremap(cookie, size)
 #define iounmap(cookie)			__uc32_iounmap(cookie)
 
 /*

