Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932295Ab3ENOvw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 10:51:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:1858 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932203Ab3ENOtY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 10:49:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,671,1363158000"; 
   d="scan'208";a="313415323"
From: Imre Deak <imre.deak@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Clemens Ladisch <clemens@ladisch.de>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org
Subject: [PATCH v2 8/8] sound/oxygen_io: take msecs_to_jiffies_timeout into use
Date: Tue, 14 May 2013 17:48:38 +0300
Message-Id: <1368542918-8861-9-git-send-email-imre.deak@intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368542918-8861-1-git-send-email-imre.deak@intel.com>
References: <1368542918-8861-1-git-send-email-imre.deak@intel.com>
In-Reply-To: <1368188011-23661-1-git-send-email-imre.deak@intel.com>
References: <1368188011-23661-1-git-send-email-imre.deak@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use msecs_to_jiffies_timeout instead of open-coding the same.

Signed-off-by: Imre Deak <imre.deak@intel.com>
---
 sound/pci/oxygen/oxygen_io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/oxygen/oxygen_io.c b/sound/pci/oxygen/oxygen_io.c
index 521eae4..51bfcd0 100644
--- a/sound/pci/oxygen/oxygen_io.c
+++ b/sound/pci/oxygen/oxygen_io.c
@@ -108,7 +108,7 @@ static int oxygen_ac97_wait(struct oxygen *chip, unsigned int mask)
 	wait_event_timeout(chip->ac97_waitqueue,
 			   ({ status |= oxygen_read8(chip, OXYGEN_AC97_INTERRUPT_STATUS);
 			      status & mask; }),
-			   msecs_to_jiffies(1) + 1);
+			   msecs_to_jiffies_timeout(1));
 	/*
 	 * Check even after a timeout because this function should not require
 	 * the AC'97 interrupt to be enabled.
-- 
1.7.10.4

