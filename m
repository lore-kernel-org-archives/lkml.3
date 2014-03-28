Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907AbaC1Ras (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 13:30:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51203 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677AbaC1Ral (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 13:30:41 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Vinod Koul <vinod.koul@intel.com>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.10 01/22] ALSA: compress: Pass through return value of open ops callback
Date: Fri, 28 Mar 2014 10:31:53 -0700
Message-Id: <20140328173109.589260466@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140328173109.378288825@linuxfoundation.org>
References: <20140328173109.378288825@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/core/compress_offload.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/core/compress_offload.c
+++ b/sound/core/compress_offload.c
@@ -133,7 +133,7 @@ static int snd_compr_open(struct inode *
 		kfree(data);
 	}
 	snd_card_unref(compr->card);
-	return 0;
+	return ret;
 }
 
 static int snd_compr_free(struct inode *inode, struct file *f)


