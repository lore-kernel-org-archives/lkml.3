Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932382Ab3LWV4P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 16:56:15 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:55382 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932331Ab3LWV4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 16:56:12 -0500
X-Originating-IP: 50.43.14.201
Date: Mon, 23 Dec 2013 13:56:06 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] Makefile: Build with -Werror=date-time if the compiler
 supports it
Message-ID: <106ff2bbebe0c2c75bedf1c52a666d638b4dc20e.1387833347.git.josh@joshtriplett.org>
References: <cover.1387833347.git.josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1387833347.git.josh@joshtriplett.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GCC 4.9 and newer have a new warning -Wdate-time, which warns on any use
of __DATE__, __TIME__, or __TIMESTAMP__, which would make the build
non-deterministic.  Now that the kernel does not use any of those
macros, turn on -Werror=date-time if available, to keep it that way.

The kernel already (optionally) records this information at build time
in a single place; other kernel code should not duplicate that.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Makefile b/Makefile
index 14d592c..188eea7 100644
--- a/Makefile
+++ b/Makefile
@@ -668,6 +668,9 @@ KBUILD_CFLAGS   += $(call cc-option,-Werror=implicit-int)
 # require functions to have arguments in prototypes, not empty 'int foo()'
 KBUILD_CFLAGS   += $(call cc-option,-Werror=strict-prototypes)
 
+# Prohibit date/time macros, which would make the build non-deterministic
+KBUILD_CFLAGS   += $(call cc-option,-Werror=date-time)
+
 # use the deterministic mode of AR if available
 KBUILD_ARFLAGS := $(call ar-option,D)
 
-- 
1.8.5.2

