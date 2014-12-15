Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364AbaLOO41 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:56:27 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38586 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734AbaLOO2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:28:10 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Binyamin Sagal <bensagal@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 079/168] Input: synaptics - adjust min/max on Thinkpad E540
Date: Mon, 15 Dec 2014 14:25:33 +0000
Message-Id: <1418653622-21105-80-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Sagal <bensagal@gmail.com>

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/input/mouse/synaptics.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index 3dcdeb785649..2d992a94f5dc 100644
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

