Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934750AbaEFLCi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 07:02:38 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:54881 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934579AbaEFLCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 07:02:35 -0400
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Randy Dunlap <rdunlap@infradead.org>
Cc: linux-pm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH] Documentation: power: swsusp: Fix script for unswapping
Date: Tue,  6 May 2014 13:01:56 +0200
Message-Id: <1399374116-12400-1-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

System can have mmaped also character devices (e.g dri devices by X) or deleted
files. Running cat on character devices is really bad idea (system can hang) so
run cat only on regular files. Also mmaped files can have spaces in filenames.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
---
 Documentation/power/swsusp.txt |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/Documentation/power/swsusp.txt b/Documentation/power/swsusp.txt
index 079160e..f732a83 100644
--- a/Documentation/power/swsusp.txt
+++ b/Documentation/power/swsusp.txt
@@ -220,7 +220,10 @@ Q: After resuming, system is paging heavily, leading to very bad interactivity.
 
 A: Try running
 
-cat `cat /proc/[0-9]*/maps | grep / | sed 's:.* /:/:' | sort -u` > /dev/null
+cat /proc/[0-9]*/maps | grep / | sed 's:.* /:/:' | sort -u | while read file
+do
+  test -f "$file" && cat "$file" > /dev/null
+done
 
 after resume. swapoff -a; swapon -a may also be useful.
 
-- 
1.7.9.5

