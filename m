Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933055AbaLBUqM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 15:46:12 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:62229 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932179AbaLBUqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 15:46:11 -0500
From: j.glisse@gmail.com
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>
Subject: [PATCH] scripts/package: binrpm-pkg do not create source and devel package v3
Date: Tue,  2 Dec 2014 15:45:59 -0500
Message-Id: <1417553159-11632-1-git-send-email-j.glisse@gmail.com>
X-Mailer: git-send-email 1.9.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jérôme Glisse <jglisse@redhat.com>

When doing make binrpm-pkg we only want to build the binary and header
package as the documentation of binrpm-pkg target claims. Hence this
patch avoid building the source and devel package. This makes binrpm-pkg
target lot faster and way more usefull.

Changed since v2 :
  - Avoid symlinks in /usr/src/kernel.
  - Update subject line and changelog.

Changed since v1 :
  - Avoid building the devel package too.

Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
---
 scripts/package/mkspec | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/scripts/package/mkspec b/scripts/package/mkspec
index 1395760..010653c 100755
--- a/scripts/package/mkspec
+++ b/scripts/package/mkspec
@@ -119,11 +119,13 @@ echo "%endif"
 
 echo 'rm -f $RPM_BUILD_ROOT'"/lib/modules/$KERNELRELEASE/{build,source}"
 echo "mkdir -p "'$RPM_BUILD_ROOT'"/usr/src/kernels/$KERNELRELEASE"
+if ! $PREBUILT; then
 echo "EXCLUDES=\"$RCS_TAR_IGNORE --exclude .tmp_versions --exclude=*vmlinux* --exclude=*.o --exclude=*.ko --exclude=*.cmd --exclude=Documentation --exclude=firmware --exclude .config.old --exclude .missing-syscalls.d\""
 echo "tar "'$EXCLUDES'" -cf- . | (cd "'$RPM_BUILD_ROOT'"/usr/src/kernels/$KERNELRELEASE;tar xvf -)"
 echo 'cd $RPM_BUILD_ROOT'"/lib/modules/$KERNELRELEASE"
 echo "ln -sf /usr/src/kernels/$KERNELRELEASE build"
 echo "ln -sf /usr/src/kernels/$KERNELRELEASE source"
+fi
 
 echo ""
 echo "%clean"
@@ -151,9 +153,11 @@ echo "%files headers"
 echo '%defattr (-, root, root)'
 echo "/usr/include"
 echo ""
+if ! $PREBUILT; then
 echo "%files devel"
 echo '%defattr (-, root, root)'
 echo "/usr/src/kernels/$KERNELRELEASE"
 echo "/lib/modules/$KERNELRELEASE/build"
 echo "/lib/modules/$KERNELRELEASE/source"
 echo ""
+fi
-- 
1.9.3

