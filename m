Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281AbaCaNYi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 09:24:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35760 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022AbaCaNYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 09:24:34 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 51/71] ALSA: compress: Pass through return value of open ops callback
Date: Mon, 31 Mar 2014 14:22:57 +0100
Message-Id: <1396272197-13394-52-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396272197-13394-1-git-send-email-luis.henriques@canonical.com>
References: <1396272197-13394-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.33 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

commit 749d32237bf39e6576dd95bfdf24e4378e51716c upstream.

The snd_compr_open function would always return 0 even if the compressed
ops open function failed, obviously this is incorrect. Looks like this
was introduced by a small typo in:

commit a0830dbd4e42b38aefdf3fb61ba5019a1a99ea85
ALSA: Add a reference counter to card instance

This patch returns the value from the compressed op as it should.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Acked-by: Vinod Koul <vinod.koul@intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/core/compress_offload.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/core/compress_offload.c b/sound/core/compress_offload.c
index 794f37a..d38a2a9 100644
--- a/sound/core/compress_offload.c
+++ b/sound/core/compress_offload.c
@@ -133,7 +133,7 @@ static int snd_compr_open(struct inode *inode, struct file *f)
 		kfree(data);
 	}
 	snd_card_unref(compr->card);
-	return 0;
+	return ret;
 }
 
 static int snd_compr_free(struct inode *inode, struct file *f)
-- 
1.9.1

