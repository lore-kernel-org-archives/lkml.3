Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645AbaBZDtp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 22:49:45 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:38025 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbaBZDtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 22:49:43 -0500
X-Originating-IP: 50.43.14.201
Date: Tue, 25 Feb 2014 19:49:36 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/5] bug: Make BUG() call unreachable()
Message-ID: <d97712e037ea4c90e9cb30c56229383d257831de.1393385236.git.josh@joshtriplett.org>
References: <469b5dc113cb468232291527642f8dc47663e945.1393385236.git.josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <469b5dc113cb468232291527642f8dc47663e945.1393385236.git.josh@joshtriplett.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This effectively causes BUG() to act like a function with the noreturn
attribute, which prevents GCC from warning about the code that follows
BUG() (for instance, warning about not returning a value in a non-void
function after calling BUG()).

This actually makes the kernel smaller; bloat-o-meter summary:
add/remove: 2/7 grow/shrink: 34/57 up/down: 475/-1233 (-758)

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 include/asm-generic/bug.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index 653c44a..5f69248 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -134,7 +134,7 @@ extern void warn_slowpath_null(const char *file, const int line);
 
 #else /* !CONFIG_BUG */
 #ifndef HAVE_ARCH_BUG
-#define BUG() do {} while (0)
+#define BUG() do { unreachable(); } while (0)
 #endif
 
 #ifndef HAVE_ARCH_WARN_ON
-- 
1.9.0

