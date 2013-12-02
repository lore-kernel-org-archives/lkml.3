Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482Ab3LBPd5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 10:33:57 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:52641 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab3LBPdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 10:33:54 -0500
From: Franck Bui-Huu <fbuihuu@gmail.com>
To: mmarek@suse.cz
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix detectition of kernel git repository in setlocalversion script [take #2]
Date: Mon,  2 Dec 2013 16:34:29 +0100
Message-Id: <1385998469-21515-1-git-send-email-fbuihuu@gmail.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <529CA5DE.7030505@gmail.com>
References: <529CA5DE.7030505@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

setlocalversion script was testing the presence of .git directory in order to find out
if git is used as SCM to track the current kernel project. However in some cases, .git
is not a directory but can be a file: when the kernel is a git submodule part of a git
super project for example.

This patch just fixes this by using 'git rev-parse --show-cdup' to check that the
current directory is the kernel git topdir. This has the advantage to not test and rely
on git internal infrastructure directly.

Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
---
 scripts/setlocalversion | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/scripts/setlocalversion b/scripts/setlocalversion
index 0b5ccf3..3d8af0e 100755
--- a/scripts/setlocalversion
+++ b/scripts/setlocalversion
@@ -43,7 +43,8 @@ scm_version()
 	fi
 
 	# Check for git and a git repo.
-	if test -d .git && head=`git rev-parse --verify --short HEAD 2>/dev/null`; then
+	if test -z "$(git rev-parse --show-cdup 2>/dev/null)" &&
+	   head=`git rev-parse --verify --short HEAD 2>/dev/null`; then
 
 		# If we are at a tagged commit (like "v2.6.30-rc6"), we ignore
 		# it, because this version is defined in the top level Makefile.
-- 
1.8.4.2

