Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756934Ab3CTJXN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 05:23:13 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:43152 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab3CTJXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 05:23:06 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: backports@vger.kernel.org
Cc: ben@decadent.org.uk, noelamac@gmail.com, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, andi@firstfloor.org,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [RFC 01/30] compat: add LINUX_BACKPORT() for prefixing symbols
Date: Wed, 20 Mar 2013 02:22:26 -0700
Message-Id: <1363771375-31715-2-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363771375-31715-1-git-send-email-mcgrof@do-not-panic.com>
References: <1363771375-31715-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

Ben Hutchings notes that "compat_" is already taken as a
prefix for symbols and while this is only slightly true
in practice its best we avoid any future issues.

Others in the past have noted issues with symbols exported
by backporting effort to conflict with other symbols that
might be preferred by the running kernel. In the worst
case scenerio we'd have the same subsystems with two eras
with two sets of drivers using a subystem from an era each.
This patch doesn't address that but tries to address the
namespace conflict by compat itself. The best alternative I
was hoping for was to use core module symbol namespaces but
after reviewing that effort introduced in 2007
by Andi Kleen [0] I see in the end Rusty Russell nack'd
these patches [1] so we're left with dealing with symbol
renaming.

Define LINUX_BACKPORT() to be used to allow us to rename
symbols with a backport_ prefix. The the cleanest, but
its a start. It isn't clean but its something, I welcome
other ideas.

[0] http://thread.gmane.org/gmane.linux.network/78674
[1] http://article.gmane.org/gmane.linux.kernel/606885

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 include/linux/compat-2.6.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/compat-2.6.h b/include/linux/compat-2.6.h
index 68e95d5..d1d24d0 100644
--- a/include/linux/compat-2.6.h
+++ b/include/linux/compat-2.6.h
@@ -3,6 +3,8 @@
 
 #ifndef __ASSEMBLY__
 
+#define LINUX_BACKPORT(__sym) backport_ ##__sym
+
 #include <linux/version.h>
 #if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,1,0))
 #include <linux/kconfig.h>
-- 
1.7.10.4

