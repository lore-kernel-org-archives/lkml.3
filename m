Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751631AbaLCGqA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 01:46:00 -0500
Received: from smtp.mei.co.jp ([133.183.100.20]:42034 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750869AbaLCGp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 01:45:58 -0500
From: Masahiro Yamada <yamada.m@jp.panasonic.com>
To: linux-kbuild@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>,
        Masahiro Yamada <yamada.m@jp.panasonic.com>,
        Michal Marek <mmarek@suse.cz>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] kbuild: update headers_install.txt document
Date: Wed,  3 Dec 2014 15:45:41 +0900
Message-Id: <1417589141-14814-1-git-send-email-yamada.m@jp.panasonic.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The arch header directories "include/asm-*" were moved long ago.
Now we should check the existence of arch/*/include/uapi/asm/Kbuild
to see if an architecture supports the headers installation.
(Actually, "um" is the only architecture that does not have it.)

Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>
---

 Documentation/kbuild/headers_install.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/kbuild/headers_install.txt b/Documentation/kbuild/headers_install.txt
index 951eb9f..8e668d4 100644
--- a/Documentation/kbuild/headers_install.txt
+++ b/Documentation/kbuild/headers_install.txt
@@ -31,7 +31,7 @@ current architecture.  The linux/asm directory of the exported kernel headers
 is platform-specific, to see a complete list of supported architectures use
 the command:
 
-  ls -d include/asm-* | sed 's/.*-//'
+  for i in arch/*; do [ -e $i/include/uapi/asm/Kbuild ] && basename $i; done
 
 INSTALL_HDR_PATH indicates where to install the headers.  It defaults to
 "./usr/include".
-- 
1.9.1

