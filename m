Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449Ab3EIWNv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:13:51 -0400
Received: from longford.logfs.org ([213.229.74.203]:59124 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754488Ab3EIWNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:13:49 -0400
From: Joern Engel <joern@logfs.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
        Borislav Petkov <bp@alien8.de>, Takashi Iwai <tiwai@suse.de>,
        Joern Engel <joern@logfs.org>
Subject: [PATCH 07/14] bcon: check for hdparm in bcon_tail
Date: Thu,  9 May 2013 16:43:05 -0400
Message-Id: <1368132193-25817-10-git-send-email-joern@logfs.org>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1368132193-25817-1-git-send-email-joern@logfs.org>
References: <1368132193-25817-1-git-send-email-joern@logfs.org>
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

