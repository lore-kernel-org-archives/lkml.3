Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758146Ab3B1XF4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 18:05:56 -0500
Received: from longford.logfs.org ([213.229.74.203]:58579 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758001Ab3B1XFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 18:05:52 -0500
From: Joern Engel <joern@logfs.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Borislav Petkov <bp@alien8.de>,
        Jeff Moyer <jmoyer@redhat.com>, Joern Engel <joern@logfs.org>
Subject: [PATCH 7/9] bcon: check for hdparm in bcon_tail
Date: Thu, 28 Feb 2013 16:40:00 -0500
Message-Id: <1362087602-8979-8-git-send-email-joern@logfs.org>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1362087602-8979-1-git-send-email-joern@logfs.org>
References: <1362087602-8979-1-git-send-email-joern@logfs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@alien8.de>
Signed-off-by: Joern Engel <joern@logfs.org>
---
 Documentation/block/blockconsole/bcon_tail |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/block/blockconsole/bcon_tail b/Documentation/block/blockconsole/bcon_tail
index b4bd660..eb3524b 100755
--- a/Documentation/block/blockconsole/bcon_tail
+++ b/Documentation/block/blockconsole/bcon_tail
@@ -14,6 +14,11 @@ if [ -z "$(which lsscsi)" ]; then
 	exit 1
 fi
 
+if [ -z "$(which hdparm)" ]; then
+	echo "You need to install the hdparm package on your distro."
+	exit 1
+fi
+
 end_of_log() {
 	DEV=$1
 	UUID=`head -c40 $DEV|tail -c8`
-- 
1.7.10.4

