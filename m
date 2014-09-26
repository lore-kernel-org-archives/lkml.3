Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756308AbaIZPFF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 11:05:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41343 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756283AbaIZPFB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 11:05:01 -0400
Date: Fri, 26 Sep 2014 17:02:04 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>,
        Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH -mm]
	signal-use-build_bug-instead-of-_nsig_words_is_unsupported_size.fix
Message-ID: <20140926150204.GA29926@redhat.com>
References: <20140926201704.1e2a62c3@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140926201704.1e2a62c3@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>

Fixes signal-use-build_bug-instead-of-_nsig_words_is_unsupported_size.patch
which caused the build failure on powerpc.

Add missing "include <linux/bug.h>" which defines BUILD_BUG()
used by that patch.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/signal.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/signal.h b/include/linux/signal.h
index 14acfd5..ab1e039 100644
--- a/include/linux/signal.h
+++ b/include/linux/signal.h
@@ -2,6 +2,7 @@
 #define _LINUX_SIGNAL_H
 
 #include <linux/list.h>
+#include <linux/bug.h>
 #include <uapi/linux/signal.h>
 
 struct task_struct;
-- 
1.5.5.1


