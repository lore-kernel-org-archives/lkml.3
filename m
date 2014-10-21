Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248AbaJUK66 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 06:58:58 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:45943 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754969AbaJUK65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 06:58:57 -0400
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ALSA: ctxfi: remove unused variable
Date: Tue, 21 Oct 2014 16:28:47 +0530
Message-Id: <1413889127-18754-1-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As of now the pointer to struct dai is not being used anywhere in the
function. So it is safe to remove the variable.
If we are ever doing anything with the container_of(daio, struct dai, daio),
then at that time we can again add the variable.   

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 sound/pci/ctxfi/ctatc.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/sound/pci/ctxfi/ctatc.c b/sound/pci/ctxfi/ctatc.c
index 4546590..632e843 100644
--- a/sound/pci/ctxfi/ctatc.c
+++ b/sound/pci/ctxfi/ctatc.c
@@ -1145,7 +1145,6 @@ static int atc_release_resources(struct ct_atc *atc)
 	int i;
 	struct daio_mgr *daio_mgr = NULL;
 	struct dao *dao = NULL;
-	struct dai *dai = NULL;
 	struct daio *daio = NULL;
 	struct sum_mgr *sum_mgr = NULL;
 	struct src_mgr *src_mgr = NULL;
@@ -1172,9 +1171,6 @@ static int atc_release_resources(struct ct_atc *atc)
 				dao = container_of(daio, struct dao, daio);
 				dao->ops->clear_left_input(dao);
 				dao->ops->clear_right_input(dao);
-			} else {
-				dai = container_of(daio, struct dai, daio);
-				/* some thing to do for dai ... */
 			}
 			daio_mgr->put_daio(daio_mgr, daio);
 		}
-- 
1.8.1.2

