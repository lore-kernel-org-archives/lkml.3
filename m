Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab3EJMOd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 08:14:33 -0400
Received: from mga14.intel.com ([143.182.124.37]:53450 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753300Ab3EJMOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 08:14:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,647,1363158000"; 
   d="scan'208";a="239604812"
From: Imre Deak <imre.deak@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Clemens Ladisch <clemens@ladisch.de>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org
Subject: [PATCH 11/11] sound/oxygen_io: take msecs_to_jiffies_min into use
Date: Fri, 10 May 2013 15:13:29 +0300
Message-Id: <1368188011-23661-11-git-send-email-imre.deak@intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368188011-23661-1-git-send-email-imre.deak@intel.com>
References: <1368188011-23661-1-git-send-email-imre.deak@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use msecs_to_jiffies_min instead of open-coding the same.

Signed-off-by: Imre Deak <imre.deak@intel.com>
---
 sound/pci/oxygen/oxygen_io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/oxygen/oxygen_io.c b/sound/pci/oxygen/oxygen_io.c
index 521eae4..132ecbe 100644
--- a/sound/pci/oxygen/oxygen_io.c
+++ b/sound/pci/oxygen/oxygen_io.c
@@ -108,7 +108,7 @@ static int oxygen_ac97_wait(struct oxygen *chip, unsigned int mask)
 	wait_event_timeout(chip->ac97_waitqueue,
 			   ({ status |= oxygen_read8(chip, OXYGEN_AC97_INTERRUPT_STATUS);
 			      status & mask; }),
-			   msecs_to_jiffies(1) + 1);
+			   msecs_to_jiffies_min(1));
 	/*
 	 * Check even after a timeout because this function should not require
 	 * the AC'97 interrupt to be enabled.
-- 
1.7.10.4

