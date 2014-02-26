Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591AbaBZDtQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 22:49:16 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:60333 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635AbaBZDtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 22:49:14 -0500
X-Originating-IP: 50.43.14.201
Date: Tue, 25 Feb 2014 19:49:05 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/5] bug: When !CONFIG_BUG, make WARN call no_printk to
 check format and args
Message-ID: <770b3955bdcec63564ae09741ae154f8908c22c6.1393385236.git.josh@joshtriplett.org>
References: <469b5dc113cb468232291527642f8dc47663e945.1393385236.git.josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <469b5dc113cb468232291527642f8dc47663e945.1393385236.git.josh@joshtriplett.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The stub version of WARN for !CONFIG_BUG completely ignored its format
string and subsequent arguments; make it check them instead, using
no_printk.

Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 include/asm-generic/bug.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index 2d54d8d..a97fa11 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -155,6 +155,7 @@ extern void warn_slowpath_null(const char *file, const int line);
 #ifndef WARN
 #define WARN(condition, format...) ({					\
 	int __ret_warn_on = !!(condition);				\
+	no_printk(format);						\
 	unlikely(__ret_warn_on);					\
 })
 #endif
-- 
1.9.0

