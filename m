Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965915AbaLLT2W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 14:28:22 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:45067 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179AbaLLT2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 14:28:20 -0500
Date: Fri, 12 Dec 2014 22:28:10 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch 2/2] ALSA: oxfw: fix detect_loud_models() return value
Message-ID: <20141212192810.GB22234@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This code causes a static checker warning:

	sound/firewire/oxfw/oxfw.c:46 detect_loud_models()
	warn: signedness bug returning '(-2)'

The detect_loud_models() function should return false on falure, so that
we don't try to set up the loud code for hardware that doesn't support
it.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/sound/firewire/oxfw/oxfw.c b/sound/firewire/oxfw/oxfw.c
index cf1d0b5..60e5cad 100644
--- a/sound/firewire/oxfw/oxfw.c
+++ b/sound/firewire/oxfw/oxfw.c
@@ -43,7 +43,7 @@ static bool detect_loud_models(struct fw_unit *unit)
 	err = fw_csr_string(unit->directory, CSR_MODEL,
 			    model, sizeof(model));
 	if (err < 0)
-		return err;
+		return false;
 
 	for (i = 0; i < ARRAY_SIZE(models); i++) {
 		if (strcmp(models[i], model) == 0)
