Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251Ab3CWLKK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 07:10:10 -0400
Received: from forward11.mail.yandex.net ([95.108.130.93]:60144 "EHLO
	forward11.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689Ab3CWLKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 07:10:08 -0400
X-Greylist: delayed 705 seconds by postgrey-1.27 at vger.kernel.org; Sat, 23 Mar 2013 07:10:08 EDT
From: Kirill Tkhai <tkhai@yandex.ru>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Michal Marek <mmarek@suse.cz>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] scripts/tags.sh: Add magic for OFFSET and DEFINE
MIME-Version: 1.0
Message-Id: <1810321364036300@web2f.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Sat, 23 Mar 2013 14:58:20 +0400
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add rules for definitions which is generally used in asm-offsets files.

Signed-off-by: Kirill V Tkhai <tkhai@yandex.ru>
CC: Michal Marek <mmarek@suse.cz>
CC: Andrew Morton <akpm@linux-foundation.org>
---
 scripts/tags.sh |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)
diff --git a/scripts/tags.sh b/scripts/tags.sh
index 26a87e6..74f02e4 100755
--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -199,7 +199,9 @@ exuberant()
 	--regex-c='/DEFINE_PER_CPU_SHARED_ALIGNED\(([^,]*,\s*)(\w*).*\)/\2/v/' \
 	--regex-c='/DECLARE_WAIT_QUEUE_HEAD\((\w*)/\1/v/'		\
 	--regex-c='/DECLARE_(TASKLET|WORK|DELAYED_WORK)\((\w*)/\2/v/'	\
-	--regex-c='/DEFINE_PCI_DEVICE_TABLE\((\w*)/\1/v/'
+	--regex-c='/DEFINE_PCI_DEVICE_TABLE\((\w*)/\1/v/'		\
+	--regex-c='/(^\s)OFFSET\((\w*)/\2/v/'				\
+	--regex-c='/(^\s)DEFINE\((\w*)/\2/v/'
 
 	all_kconfigs | xargs $1 -a                              \
 	--langdef=kconfig --language-force=kconfig              \
