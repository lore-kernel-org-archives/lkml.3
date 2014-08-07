Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932352AbaHGNJy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 09:09:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48839 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757448AbaHGNJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 09:09:52 -0400
From: Amit Shah <amit.shah@redhat.com>
To: jgarzik@bitpay.com
Cc: hpa@linux.intel.com,
        Virtualization List <virtualization@lists.linux-foundation.org>,
        Amos Kong <akong@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
        linux-kernel@vger.kernel.org, Amit Shah <amit.shah@redhat.com>
Subject: [PATCH 2/2] Install udev rules in system-default directory
Date: Thu,  7 Aug 2014 18:39:00 +0530
Message-Id: <3df55388b1b3acd142f391494f102c3ddb2270ed.1407416628.git.amit.shah@redhat.com>
In-Reply-To: <cover.1407416628.git.amit.shah@redhat.com>
References: <cover.1407416628.git.amit.shah@redhat.com>
In-Reply-To: <cover.1407416628.git.amit.shah@redhat.com>
References: <cover.1407416628.git.amit.shah@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

not-quite-Signed-off-by: Amit Shah <amit.shah@redhat.com>
---
 Makefile.am  | 1 +
 configure.ac | 8 ++++++++
 2 files changed, 9 insertions(+)

diff --git a/Makefile.am b/Makefile.am
index f8490a3..a2b8173 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -8,6 +8,7 @@ sbin_PROGRAMS	 = rngd
 bin_PROGRAMS	 = rngtest
 man_MANS	 = rngd.8 rngtest.1
 noinst_LIBRARIES = librngd.a
+udevrules_DATA	 = 90-virtio-rng.rules
 
 rngd_SOURCES	= rngd.h rngd.c	rngd_entsource.h rngd_entsource.c	\
 		  rngd_linux.h rngd_linux.c util.c 			\
diff --git a/configure.ac b/configure.ac
index 27a2dba..4187aca 100644
--- a/configure.ac
+++ b/configure.ac
@@ -32,6 +32,14 @@ AC_ARG_WITH([libgcrypt],
 	[with_libgcrypt=check]
 )
 
+PKG_PROG_PKG_CONFIG
+
+AC_ARG_WITH([udevrulesdir],
+	AS_HELP_STRING([--with-udevrulesdir=DIR], [Directory for udev rules]),
+	[],
+	[with_udevrulesdir=$($PKG_CONFIG --variable=udevdir udev)"/rules.d"])
+AC_SUBST([udevrulesdir], [$with_udevrulesdir])
+
 dnl Make sure anyone changing configure.ac/Makefile.am has a clue
 AM_MAINTAINER_MODE
 
-- 
1.9.3

