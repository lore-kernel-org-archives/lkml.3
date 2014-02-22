Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbaBVWgy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 17:36:54 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:49057 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080AbaBVWgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 17:36:53 -0500
X-Originating-IP: 50.43.14.201
Date: Sat, 22 Feb 2014 14:36:46 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] bug: When !CONFIG_BUG, simplify WARN_ON_ONCE and
 family
Message-ID: <20140222223646.GA4931@thin>
References: <20140222192325.GA12587@thin>
 <53091CA9.3060403@infradead.org>
 <20140222223120.GB4643@thin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140222223120.GB4643@thin>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 22, 2014 at 02:31:20PM -0800, Josh Triplett wrote:
> On Sat, Feb 22, 2014 at 01:54:49PM -0800, Randy Dunlap wrote:
> > On 02/22/2014 11:23 AM, Josh Triplett wrote:
> > 
> > Hi Josh,
> > 
> > If you redo these patches, please make while(0) not look like a
> > function call, i.e., use while (0) instead.
> 
> Good catch.  Fixing in v2.

Looking at the patch, those while(0)s were all in the original code, not
introduced by my patch.  (diff claims my patch moves them, but a better
diff would have shown that I left them alone and just moved other code
above them.)

With that in mind, I didn't want to change that style issue in the same
patch, but I wrote a separate style patch to be applied on top:

----- >8 -----
>From 2a80f851b507f44142d219af3cf00555e333f4c4 Mon Sep 17 00:00:00 2001
From: Josh Triplett <josh@joshtriplett.org>
Date: Sat, 22 Feb 2014 14:33:01 -0800
Subject: [PATCH] include/asm-generic/bug.h: Style fix: s/while(0)/while (0)/

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 include/asm-generic/bug.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index 34223e0..5f5a277 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -52,7 +52,7 @@ struct bug_entry {
 #endif
 
 #ifndef HAVE_ARCH_BUG_ON
-#define BUG_ON(condition) do { if (unlikely(condition)) BUG(); } while(0)
+#define BUG_ON(condition) do { if (unlikely(condition)) BUG(); } while (0)
 #endif
 
 /*
@@ -138,11 +138,11 @@ extern void warn_slowpath_null(const char *file, const int line);
 
 #else /* !CONFIG_BUG */
 #ifndef HAVE_ARCH_BUG
-#define BUG() do {} while(0)
+#define BUG() do {} while (0)
 #endif
 
 #ifndef HAVE_ARCH_BUG_ON
-#define BUG_ON(condition) do { if (condition) ; } while(0)
+#define BUG_ON(condition) do { if (condition) ; } while (0)
 #endif
 
 #ifndef HAVE_ARCH_WARN_ON
-- 
1.9.0

