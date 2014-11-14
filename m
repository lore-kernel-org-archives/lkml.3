Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935227AbaKNL1E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 06:27:04 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:46761 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934404AbaKNL1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 06:27:02 -0500
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3] ALSA: ice1712: consider error value
Date: Fri, 14 Nov 2014 16:56:49 +0530
Message-Id: <1415964409-12580-1-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

earlier we were ignoring the return value of snd_ak4114_create and
always returning 0.
now we are returning the actual status. revo_init is calling this
function, and revo_init is checking the return value.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---

change in v3: spec->ak4114 is now dereferenced if we dont get an
error value from snd_ak4114_create.

 sound/pci/ice1712/revo.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/pci/ice1712/revo.c b/sound/pci/ice1712/revo.c
index 1112ec1..24a7c6a 100644
--- a/sound/pci/ice1712/revo.c
+++ b/sound/pci/ice1712/revo.c
@@ -496,9 +496,10 @@ static int ap192_ak4114_init(struct snd_ice1712 *ice)
 				 ice, &spec->ak4114);
 	/* AK4114 in Revo cannot detect external rate correctly.
 	 * No reason to stop capture stream due to incorrect checks */
-	spec->ak4114->check_flags = AK4114_CHECK_NO_RATE;
+	if (err == 0)
+		spec->ak4114->check_flags = AK4114_CHECK_NO_RATE;
 
-	return 0; /* error ignored; it's no fatal error */
+	return err;
 }
 
 static int revo_init(struct snd_ice1712 *ice)
-- 
1.8.1.2

