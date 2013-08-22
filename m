Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536Ab3HVU0I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 16:26:08 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:46330 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475Ab3HVUZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 16:25:46 -0400
From: Max Filippov <jcmvbkbc@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sam Ravnborg <sam@ravnborg.org>, Guenter Roeck <linux@roeck-us.net>,
        Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH v2 4/5] scripts/checkkconfigsymbols.sh: replace echo -e with printf
Date: Fri, 23 Aug 2013 00:25:24 +0400
Message-Id: <1377203125-22934-5-git-send-email-jcmvbkbc@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1377203125-22934-1-git-send-email-jcmvbkbc@gmail.com>
References: <1377203125-22934-1-git-send-email-jcmvbkbc@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-e is a non-standard echo option, echo output is
implementation-dependent when it is used. Replace echo -e
with printf as suggested by POSIX echo manual.

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---
 scripts/checkkconfigsymbols.sh |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/checkkconfigsymbols.sh b/scripts/checkkconfigsymbols.sh
index 2ca49bb..ccb3391 100755
--- a/scripts/checkkconfigsymbols.sh
+++ b/scripts/checkkconfigsymbols.sh
@@ -9,7 +9,7 @@ paths="$@"
 # Doing this once at the beginning saves a lot of time, on a cache-hot tree.
 Kconfigs="`find . -name 'Kconfig' -o -name 'Kconfig*[^~]'`"
 
-/bin/echo -e "File list \tundefined symbol used"
+printf "File list \tundefined symbol used\n"
 find $paths -name '*.[chS]' -o -name 'Makefile' -o -name 'Makefile*[^~]'| while read i
 do
 	# Output the bare Kconfig variable and the filename; the _MODULE part at
@@ -54,6 +54,6 @@ while read symb files; do
 	# beyond the purpose of this script.
 	symb_bare=`echo $symb | sed -e 's/_MODULE//'`
 	if ! grep -q "\<$symb_bare\>" $Kconfigs; then
-		/bin/echo -e "$files: \t$symb"
+		printf "$files: \t$symb\n"
 	fi
 done|sort
-- 
1.7.7.6

