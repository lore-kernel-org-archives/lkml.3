Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866Ab3HRUz2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 16:55:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43445 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755482Ab3HRUdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 16:33:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [ 11/34] cris: Remove old legacy "-traditional" flag from arch-v10/lib/Makefile
Date: Sun, 18 Aug 2013 13:34:24 -0700
Message-Id: <20130818203300.460923714@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130818203259.653403173@linuxfoundation.org>
References: <20130818203259.653403173@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Gortmaker <paul.gortmaker@windriver.com>

commit 7b91747d42a1012e3781dd09fa638d113809e3fd upstream.

Most of these have been purged years ago.  This one silently lived
on until commit 69349c2dc01c489eccaa4c472542c08e370c6d7e

    "kconfig: fix IS_ENABLED to not require all options to be defined"

In the above, we use some macro trickery to create a conditional that
is valid in CPP and in C usage.  However that trickery doesn't sit
well if you have the legacy "-traditional" flag enabled.  You'll get:

  AS      arch/cris/arch-v10/lib/checksum.o
In file included from <command-line>:4:0:
include/linux/kconfig.h:23:0: error: syntax error in macro parameter list
make[2]: *** [arch/cris/arch-v10/lib/checksum.o] Error 1

Everything builds fine w/o "-traditional" so simply drop it from this
location as well.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/cris/arch-v10/lib/Makefile |    3 ---
 1 file changed, 3 deletions(-)

--- a/arch/cris/arch-v10/lib/Makefile
+++ b/arch/cris/arch-v10/lib/Makefile
@@ -2,8 +2,5 @@
 # Makefile for Etrax-specific library files..
 #
 
-
-EXTRA_AFLAGS := -traditional
-
 lib-y  = checksum.o checksumcopy.o string.o usercopy.o memset.o csumcpfruser.o
 


