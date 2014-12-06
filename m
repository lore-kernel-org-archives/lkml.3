Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601AbaLFPUd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 10:20:33 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:47661 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752133AbaLFPII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 10:08:08 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 09/66] Input: synaptics - add min/max quirk for Lenovo T440s
Date: Sat,  6 Dec 2014 16:07:01 +0100
Message-Id: <c5ddd2b1c74f81410950298b964bbb9c588f5aa6.1417878427.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
References: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
In-Reply-To: <cover.1417878427.git.jslaby@suse.cz>
References: <cover.1417878427.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit e4742b1e786ca386e88e6cfb2801e14e15e365cd upstream.

The new Lenovo T440s laptop has a different PnP ID "LEN0039", and it
needs the similar min/max quirk to make its clickpad working.

BugLink: https://bugzilla.opensuse.org/show_bug.cgi?id=903748
Reported-and-tested-by: Joschi Brauchle <joschibrauchle@gmx.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/input/mouse/synaptics.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index a50a2a7a43f7..1e76eb8f06c7 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -132,8 +132,8 @@ static const struct min_max_quirk min_max_pnpid_table[] = {
 		1232, 5710, 1156, 4696
 	},
 	{
-		(const char * const []){"LEN0034", "LEN0036", "LEN2002",
-					"LEN2004", NULL},
+		(const char * const []){"LEN0034", "LEN0036", "LEN0039",
+					"LEN2002", "LEN2004", NULL},
 		1024, 5112, 2024, 4832
 	},
 	{
@@ -160,6 +160,7 @@ static const char * const topbuttonpad_pnp_ids[] = {
 	"LEN0036", /* T440 */
 	"LEN0037",
 	"LEN0038",
+	"LEN0039", /* T440s */
 	"LEN0041",
 	"LEN0042", /* Yoga */
 	"LEN0045",
-- 
2.1.3

