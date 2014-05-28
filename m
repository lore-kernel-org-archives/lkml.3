Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849AbaE1QnP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 12:43:15 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:25382 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503AbaE1QnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 12:43:13 -0400
Date: Wed, 28 May 2014 19:42:46 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch 2/2] ALSA: fireworks: small leak on error path
Message-ID: <20140528164246.GC1824@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There was a typo here so we return directly instead of freeing "hwinfo".

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/sound/firewire/fireworks/fireworks.c b/sound/firewire/fireworks/fireworks.c
index 8e856cc..996fdc4 100644
--- a/sound/firewire/fireworks/fireworks.c
+++ b/sound/firewire/fireworks/fireworks.c
@@ -157,7 +157,7 @@ get_hardware_info(struct snd_efw *efw)
 	/* Hardware metering. */
 	if (hwinfo->phys_in_grp_count  > HWINFO_MAX_CAPS_GROUPS ||
 	    hwinfo->phys_out_grp_count > HWINFO_MAX_CAPS_GROUPS) {
-		return -EIO;
+		err = -EIO;
 		goto end;
 	}
 	efw->phys_in = hwinfo->phys_in;
