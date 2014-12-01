Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932443AbaLAU5t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 15:57:49 -0500
Received: from mail-qg0-f42.google.com ([209.85.192.42]:50822 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932112AbaLAU5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 15:57:48 -0500
From: j.glisse@gmail.com
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>
Subject: [PATCH] scripts/package: binrpm-pkg do not build source tar file v2
Date: Mon,  1 Dec 2014 15:57:18 -0500
Message-Id: <1417467438-32001-1-git-send-email-j.glisse@gmail.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jérôme Glisse <jglisse@redhat.com>

When doing make binrpm-pkg we do not want to build the source tar
file. This patch avoid doing the gigantic tar file.

Changed since v1
  - Avoid building the devel package too.

Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
---
 scripts/package/mkspec | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/scripts/package/mkspec b/scripts/package/mkspec
index 1395760..31b7b7f 100755
--- a/scripts/package/mkspec
+++ b/scripts/package/mkspec
@@ -119,8 +119,10 @@ echo "%endif"
 
 echo 'rm -f $RPM_BUILD_ROOT'"/lib/modules/$KERNELRELEASE/{build,source}"
 echo "mkdir -p "'$RPM_BUILD_ROOT'"/usr/src/kernels/$KERNELRELEASE"
+if ! $PREBUILT; then
 echo "EXCLUDES=\"$RCS_TAR_IGNORE --exclude .tmp_versions --exclude=*vmlinux* --exclude=*.o --exclude=*.ko --exclude=*.cmd --exclude=Documentation --exclude=firmware --exclude .config.old --exclude .missing-syscalls.d\""
 echo "tar "'$EXCLUDES'" -cf- . | (cd "'$RPM_BUILD_ROOT'"/usr/src/kernels/$KERNELRELEASE;tar xvf -)"
+fi
 echo 'cd $RPM_BUILD_ROOT'"/lib/modules/$KERNELRELEASE"
 echo "ln -sf /usr/src/kernels/$KERNELRELEASE build"
 echo "ln -sf /usr/src/kernels/$KERNELRELEASE source"
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
1.8.3.1

