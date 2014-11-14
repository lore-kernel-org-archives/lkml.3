Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935377AbaKNMmf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 07:42:35 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:58634 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934994AbaKNMmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 07:42:33 -0500
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4] ALSA: ice1712: consider error value
Date: Fri, 14 Nov 2014 18:12:21 +0530
Message-Id: <1415968941-14181-1-git-send-email-sudipm.mukherjee@gmail.com>
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

change in v4: error value returned according to coding style.

 sound/pci/ice1712/revo.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/pci/ice1712/revo.c b/sound/pci/ice1712/revo.c
index 1112ec1..1d81ae6 100644
--- a/sound/pci/ice1712/revo.c
+++ b/sound/pci/ice1712/revo.c
@@ -494,11 +494,13 @@ static int ap192_ak4114_init(struct snd_ice1712 *ice)
 				 ap192_ak4114_write,
 				 ak4114_init_vals, ak4114_init_txcsb,
 				 ice, &spec->ak4114);
+	if (err < 0)
+		return err;
 	/* AK4114 in Revo cannot detect external rate correctly.
 	 * No reason to stop capture stream due to incorrect checks */
 	spec->ak4114->check_flags = AK4114_CHECK_NO_RATE;
 
-	return 0; /* error ignored; it's no fatal error */
+	return 0;
 }
 
 static int revo_init(struct snd_ice1712 *ice)
-- 
1.8.1.2

