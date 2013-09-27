Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384Ab3I0S2c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 14:28:32 -0400
Received: from mail-1.atlantis.sk ([80.94.52.57]:52824 "EHLO
	mail-1.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726Ab3I0S20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 14:28:26 -0400
To: alsa-devel@alsa-project.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] [RESEND] snd-ac97-codec: Use complete ID when the codec is not known
From: Ondrej Zary <linux@rainbow-software.org>
Date: Fri, 27 Sep 2013 20:28:03 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201309272028.03764.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, if the codec ID is not known, the last byte of the ID is used as name.
It's not helpful at all, use full codec ID instead.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 sound/pci/ac97/ac97_codec.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/pci/ac97/ac97_codec.c b/sound/pci/ac97/ac97_codec.c
index bf578ba2..30a40a8 100644
--- a/sound/pci/ac97/ac97_codec.c
+++ b/sound/pci/ac97/ac97_codec.c
@@ -1830,7 +1830,7 @@ void snd_ac97_get_name(struct snd_ac97 *ac97, unsigned int id, char *name, int m
 				pid->patch(ac97);
 		}
 	} else
-		sprintf(name + strlen(name), " id %x", id & 0xff);
+		sprintf(name + strlen(name), " id %x", id);
 }
 
 /**
-- 
Ondrej Zary
