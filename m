Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731Ab3KPIZO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 03:25:14 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:41907 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473Ab3KPIYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 03:24:54 -0500
From: "Du, Changbin" <changbin.du@gmail.com>
To: jbaron@akamai.com, joe@perches.com
Cc: linux-kernel@vger.kernel.org, marcel@holtmann.org,
        akpm@linux-foundation.org, "Du, Changbin" <changbin.du@gmail.com>
Subject: [PATCH v5 3/3] dynamic-debug-howto.txt: update since new wildcard support
Date: Sat, 16 Nov 2013 16:24:09 +0800
Message-Id: <1384590249-16672-4-git-send-email-changbin.du@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1384590249-16672-1-git-send-email-changbin.du@gmail.com>
References: <1384590249-16672-1-git-send-email-changbin.du@gmail.com>
In-Reply-To: <CABgQ-Th3arUm=rLcv4FGRamAN00kGnDsO_VsHkRp4ZfFGOjaZQ@mail.gmail.com>
References: <CABgQ-Th3arUm=rLcv4FGRamAN00kGnDsO_VsHkRp4ZfFGOjaZQ@mail.gmail.com>
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
1.8.3.2

