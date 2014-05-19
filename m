Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750714AbaESEer (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 00:34:47 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:14034 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750952AbaESEcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 00:32:53 -0400
X-IronPort-AV: E=Sophos;i="4.98,865,1392159600"; 
   d="scan'208";a="74474220"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Jaroslav Kysela <perex@perex.cz>
Cc: kernel-janitors@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH 8/13] sound: mpu401.c: make return of 0 explicit
Date: Mon, 19 May 2014 06:31:10 +0200
Message-Id: <1400473875-22228-9-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1400473875-22228-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1400473875-22228-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Delete unnecessary local variable whose value is always 0 and that hides
the fact that the result is always 0.

A simplified version of the semantic patch that fixes this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
local idexpression ret;
expression e;
position p;
@@

-ret = 0;
... when != ret = e
return 
- ret
+ 0
  ;
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 sound/oss/mpu401.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/oss/mpu401.c b/sound/oss/mpu401.c
index 25e4609..3bbc3ec 100644
--- a/sound/oss/mpu401.c
+++ b/sound/oss/mpu401.c
@@ -567,7 +567,6 @@ static int mpu401_out(int dev, unsigned char midi_byte)
 static int mpu401_command(int dev, mpu_command_rec * cmd)
 {
 	int i, timeout, ok;
-	int ret = 0;
 	unsigned long   flags;
 	struct mpu_config *devc;
 
@@ -644,7 +643,6 @@ retry:
 			}
 		}
 	}
-	ret = 0;
 	cmd->data[0] = 0;
 
 	if (cmd->nr_returns)
@@ -666,7 +664,7 @@ retry:
 		}
 	}
 	spin_unlock_irqrestore(&devc->lock,flags);
-	return ret;
+	return 0;
 }
 
 static int mpu_cmd(int dev, int cmd, int data)

