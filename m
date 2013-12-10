Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340Ab3LJHO2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 02:14:28 -0500
Received: from ozlabs.org ([203.10.76.45]:52501 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789Ab3LJHOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 02:14:18 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "LKML" <linux-kernel@vger.kernel.org>
Cc: <linux-kbuild@vger.kernel.org>
Subject: [PATCH] scripts/gcc-version.sh: handle CC="gcc -m32"
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Tue, 10 Dec 2013 17:43:29 +1030
Message-ID: <87d2l5ji06.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without it we get ugly warnings (though build still succeeds).

$ make -j8 CC="gcc -m32"
In file included from <command-line>:0:0:
/usr/include/stdc-predef.h:30:26: fatal error: bits/predefs.h: No such file or directory
 #include <bits/predefs.h>
                          ^
compilation terminated.
In file included from <command-line>:0:0:
/usr/include/stdc-predef.h:30:26: fatal error: bits/predefs.h: No such file or directory
 #include <bits/predefs.h>
                          ^
compilation terminated.
/home/rusty/devel/kernel/linux/scripts/gcc-version.sh: line 31: printf: #: invalid number
/home/rusty/devel/kernel/linux/scripts/gcc-version.sh: line 31: printf: #: invalid number
/bin/sh: 1: [: 0001: unexpected operator
  CHK     include/config/kernel.release
  CHK     include/generated/uapi/linux/version.h
make[1]: Nothing to be done for `all'.
...

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/scripts/gcc-version.sh b/scripts/gcc-version.sh
index 7f2126df91f2..d48b0cbaf246 100644
--- a/scripts/gcc-version.sh
+++ b/scripts/gcc-version.sh
@@ -14,7 +14,7 @@ if [ "$1" = "-p" ] ; then
 	shift;
 fi
 
-compiler="$*"
+compiler="$1"
 
 if [ ${#compiler} -eq 0 ]; then
 	echo "Error: No compiler specified."
