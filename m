Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965183AbaKNKjW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 05:39:22 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:62753 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965102AbaKNKjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 05:39:20 -0500
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3] ALSA: ice1712: consider error value
Date: Fri, 14 Nov 2014 16:09:06 +0530
Message-Id: <1415961547-10330-2-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1415961547-10330-1-git-send-email-sudipm.mukherjee@gmail.com>
References: <1415961547-10330-1-git-send-email-sudipm.mukherjee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

earlier we were ignoring the return value of snd_ak4114_create and
always returning 0.
now we are returning the actual status. revo_init is calling this
function, and revo_init is checking the return value.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 sound/pci/ice1712/revo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/ice1712/revo.c b/sound/pci/ice1712/revo.c
index 1112ec1..2835196 100644
--- a/sound/pci/ice1712/revo.c
+++ b/sound/pci/ice1712/revo.c
@@ -498,7 +498,7 @@ static int ap192_ak4114_init(struct snd_ice1712 *ice)
 	 * No reason to stop capture stream due to incorrect checks */
 	spec->ak4114->check_flags = AK4114_CHECK_NO_RATE;
 
-	return 0; /* error ignored; it's no fatal error */
+	return err;
 }
 
 static int revo_init(struct snd_ice1712 *ice)
-- 
1.8.1.2

