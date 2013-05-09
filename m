Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110Ab3EIWMO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:12:14 -0400
Received: from longford.logfs.org ([213.229.74.203]:59093 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754451Ab3EIWMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:12:12 -0400
From: Joern Engel <joern@logfs.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
        Borislav Petkov <bp@alien8.de>, Takashi Iwai <tiwai@suse.de>,
        Joern Engel <joern@logfs.org>
Subject: [PATCH 08/14] blockconsole: Allow to pass a device file path to bcon_tail
Date: Thu,  9 May 2013 16:43:06 -0400
Message-Id: <1368132193-25817-11-git-send-email-joern@logfs.org>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1368132193-25817-1-git-send-email-joern@logfs.org>
References: <1368132193-25817-1-git-send-email-joern@logfs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

... instead of always looking through all devices.

Minor tweak: Moved the "CANDIDATES=" line below Takashi's new code.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Joern Engel <joern@logfs.org>
---
 Documentation/block/blockconsole/bcon_tail |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/Documentation/block/blockconsole/bcon_tail b/Documentation/block/blockconsole/bcon_tail
index eb3524b..70926c6 100755
--- a/Documentation/block/blockconsole/bcon_tail
+++ b/Documentation/block/blockconsole/bcon_tail
@@ -58,6 +58,21 @@ end_of_log() {
 # HEADER contains a newline, so the funny quoting is necessary
 HEADER='
 Linux blockconsole version 1.1'
+
+DEV="$1"
+if [ -n "$DEV" ]; then
+	if [ ! -b "$DEV" ]; then
+		echo "bcon_tail: No block device file $DEV"
+		exit 1
+	fi
+	if [ "`head -c32 $DEV`" != "$HEADER" ]; then
+		echo "bcon_tail: Invalid device file $DEV"
+		exit 1
+	fi
+	end_of_log $DEV
+	exit 0
+fi
+
 CANDIDATES=`lsscsi |sed 's|.*/dev|/dev|'`
 
 for DEV in $CANDIDATES; do
-- 
1.7.10.4

