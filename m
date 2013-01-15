Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742Ab3AOTMn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 14:12:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41408 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754564Ab3AOTMm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 14:12:42 -0500
Date: Tue, 15 Jan 2013 20:12:37 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Clayton <andrew@digital-domain.net>,
        Zlatko Calusic <zlatko.calusic@iskon.hr>,
        Rik van Riel <riel@redhat.com>
Subject: [PATCH] lockdep, rwsem: fix down_write_nest_lock() if
 !CONFIG_DEBUG_LOCK_ALLOC
Message-ID: <alpine.LNX.2.00.1301152010040.14768@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 1b963c81b1 ("lockdep, rwsem: provide down_write_nest_lock()") 
contains a bug in a codepath when CONFIG_DEBUG_LOCK_ALLOC is disabled, 
which causes down_read() to be called instead of down_write() by mistake 
on such configurations. Fix that.

Reported-by: Andrew Clayton <andrew@digital-domain.net>
Reported-by: Zlatko Calusic <zlatko.calusic@iskon.hr>
Tested-by: Andrew Clayton <andrew@digital-domain.net>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 include/linux/rwsem.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
index 413cc11..8da67d6 100644
--- a/include/linux/rwsem.h
+++ b/include/linux/rwsem.h
@@ -135,7 +135,7 @@ do {								\
 
 #else
 # define down_read_nested(sem, subclass)		down_read(sem)
-# define down_write_nest_lock(sem, nest_lock)	down_read(sem)
+# define down_write_nest_lock(sem, nest_lock)	down_write(sem)
 # define down_write_nested(sem, subclass)	down_write(sem)
 #endif
 
-- 
Jiri Kosina
SUSE Labs
