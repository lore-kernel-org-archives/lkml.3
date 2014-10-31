Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757294AbaJaTFv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 15:05:51 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:55331 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbaJaTFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 15:05:49 -0400
From: j.glisse@gmail.com
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
        linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] scripts/package: binrpm-pkg do not build source tar file
Date: Fri, 31 Oct 2014 15:05:31 -0400
Message-Id: <1414782331-7987-1-git-send-email-j.glisse@gmail.com>
X-Mailer: git-send-email 1.9.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jérôme Glisse <jglisse@redhat.com>

When doing make binrpm-pkg we do not want to build the source tar
file. This patch avoid doing the gigantic tar file.

Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
Cc: linux-kbuild@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
---
 scripts/package/mkspec | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/scripts/package/mkspec b/scripts/package/mkspec
index 1395760..b6f5e31 100755
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
-- 
1.9.3

