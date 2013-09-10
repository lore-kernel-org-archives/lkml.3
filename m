Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585Ab3IJN6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 09:58:18 -0400
Received: from mail-qe0-f53.google.com ([209.85.128.53]:36330 "EHLO
	mail-qe0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313Ab3IJN6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 09:58:16 -0400
Message-ID: <1378821492.2493.3.camel@localhost>
Subject: Re: Oddness in security/Makefile
From: Eric Paris <eparis@parisplace.org>
To: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        James Morris <james.l.morris@oracle.com>,
        Stephen Smalley <sds@tycho.nsa.gov>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Date: Tue, 10 Sep 2013 09:58:12 -0400
In-Reply-To: <11543.1378741281@turing-police.cc.vt.edu>
References: <11543.1378741281@turing-police.cc.vt.edu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.9.91 (3.9.91-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 4675ca3470e3c2e325c5be6d9a11f47ac0917537 Mon Sep 17 00:00:00 2001
From: Eric Paris <eparis@redhat.com>
Date: Tue, 10 Sep 2013 09:51:50 -0400
Subject: [PATCH] security: remove erroneous comment about capabilities.o link
 ordering

Back when we had half ass LSM stacking we had to link capabilities.o
after bigger LSMs so that on initialization the bigger LSM would
register first and the capabilities module would be the one stacked as
the 'seconday'.  Somewhere around 6f0f0fd496333777d53 (back in 2008) we
finally removed the last of the kinda module stacking code but this
comment in the makefile still lives today.

Reported-by: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Signed-off-by: Eric Paris <eparis@redhat.com>
---
 security/Makefile | 1 -
 1 file changed, 1 deletion(-)

diff --git a/security/Makefile b/security/Makefile
index c26c81e..a5918e0 100644
--- a/security/Makefile
+++ b/security/Makefile
@@ -16,7 +16,6 @@ obj-$(CONFIG_MMU)			+= min_addr.o
 # Object file lists
 obj-$(CONFIG_SECURITY)			+= security.o capability.o
 obj-$(CONFIG_SECURITYFS)		+= inode.o
-# Must precede capability.o in order to stack properly.
 obj-$(CONFIG_SECURITY_SELINUX)		+= selinux/built-in.o
 obj-$(CONFIG_SECURITY_SMACK)		+= smack/built-in.o
 obj-$(CONFIG_AUDIT)			+= lsm_audit.o

