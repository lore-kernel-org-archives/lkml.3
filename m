Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283AbaLFPQ3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 10:16:29 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:47666 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752209AbaLFPIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 10:08:11 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ben Sagal <bensagal@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 48/66] Input: synaptics - adjust min/max on Thinkpad E540
Date: Sat,  6 Dec 2014 16:07:40 +0100
Message-Id: <2c2bbb8a720934e493feb6dc52dd84bb04e60562.1417878427.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
References: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
In-Reply-To: <cover.1417878427.git.jslaby@suse.cz>
References: <cover.1417878427.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Sagal <bensagal@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit bce4f9e764c36bc35dd5c9cf9e057c09f422397d upstream.

The LEN2006 Synaptics touchpad (as found in Thinkpad E540) returns wrong
min max values.

touchpad-edge-detector output:
>  Touchpad SynPS/2 Synaptics TouchPad on /dev/input/event6
>  Move one finger around the touchpad to detect the actual edges
>  Kernel says:    x [1472..5674], y [1408..4684]
>  Touchpad sends: x [1264..5675], y [1171..4688]

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=88211
Signed-off-by: Binyamin Sagal <bensagal@gmail.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/input/mouse/synaptics.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index 1e76eb8f06c7..a3769cf84381 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -140,6 +140,10 @@ static const struct min_max_quirk min_max_pnpid_table[] = {
 		(const char * const []){"LEN2001", NULL},
 		1024, 5022, 2508, 4832
 	},
+	{
+		(const char * const []){"LEN2006", NULL},
+		1264, 5675, 1171, 4688
+	},
 	{ }
 };
 
-- 
2.1.3

