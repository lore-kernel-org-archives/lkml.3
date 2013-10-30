Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab3J3OYI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 10:24:08 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:57059 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763Ab3J3OYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 10:24:07 -0400
From: "Du, Changbin" <changbin.du@gmail.com>
To: jbaron@akamai.com, joe@perches.com
Cc: linux-kernel@vger.kernel.org, marcel@holtmann.org,
        "Du, Changbin" <changbin.du@gmail.com>
Subject: [PATCH v4 2/2] dynamic-debug-howto.txt: update since new wildcard support
Date: Wed, 30 Oct 2013 22:21:41 +0800
Message-Id: <1383142901-6186-2-git-send-email-changbin.du@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383142901-6186-1-git-send-email-changbin.du@gmail.com>
References: <1383142901-6186-1-git-send-email-changbin.du@gmail.com>
In-Reply-To: <CABgQ-TjqiALfieAz8+6nt6TVxy93dJRv1UzkGMRMVO1CgfwXNg@mail.gmail.com>
References: <CABgQ-TjqiALfieAz8+6nt6TVxy93dJRv1UzkGMRMVO1CgfwXNg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Du, Changbin" <changbin.du@gmail.com>

Add the usage of using new feature wildcard support.

Signed-off-by: Du, Changbin <changbin.du@gmail.com>
---
 Documentation/dynamic-debug-howto.txt | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/dynamic-debug-howto.txt b/Documentation/dynamic-debug-howto.txt
index 1bbdcfc..46325eb 100644
--- a/Documentation/dynamic-debug-howto.txt
+++ b/Documentation/dynamic-debug-howto.txt
@@ -108,6 +108,12 @@ If your query set is big, you can batch them too:
 
   ~# cat query-batch-file > <debugfs>/dynamic_debug/control
 
+A another way is to use wildcard. The match rule support '*' (matches
+zero or more characters) and '?' (matches exactly one character).For
+example, you can match all usb drivers:
+
+  ~# echo "file drivers/usb/* +p" > <debugfs>/dynamic_debug/control
+
 At the syntactical level, a command comprises a sequence of match
 specifications, followed by a flags change specification.
 
@@ -315,6 +321,9 @@ nullarbor:~ # echo -n 'func svc_process -p' >
 nullarbor:~ # echo -n 'format "nfsd: READ" +p' >
 				<debugfs>/dynamic_debug/control
 
+// enable messages in files of which the pathes include string "usb"
+nullarbor:~ # echo -n '*usb* +p' > <debugfs>/dynamic_debug/control
+
 // enable all messages
 nullarbor:~ # echo -n '+p' > <debugfs>/dynamic_debug/control
 
-- 
1.8.1.2

