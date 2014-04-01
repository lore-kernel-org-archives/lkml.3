Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760AbaDAQNG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 12:13:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44517 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbaDAQNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 12:13:05 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Takashi Iwai <tiwai@suse.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 77/86] ALSA: compress: Pass through return value of open ops callback
Date: Tue,  1 Apr 2014 09:08:30 -0700
Message-Id: <1396368519-12728-78-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396368519-12728-1-git-send-email-kamal@canonical.com>
References: <1396368519-12728-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.21 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/core/compress_offload.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/core/compress_offload.c b/sound/core/compress_offload.c
index a388a87..918d2fd 100644
--- a/sound/core/compress_offload.c
+++ b/sound/core/compress_offload.c
@@ -131,7 +131,7 @@ static int snd_compr_open(struct inode *inode, struct file *f)
 		kfree(data);
 	}
 	snd_card_unref(compr->card);
-	return 0;
+	return ret;
 }
 
 static int snd_compr_free(struct inode *inode, struct file *f)
-- 
1.8.3.2

