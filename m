Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302AbaKYLJM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:09:12 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58886 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753778AbaKYKmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:42:47 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 176/254] Input: synaptics - add min/max quirk for Lenovo T440s
Date: Tue, 25 Nov 2014 10:38:46 +0000
Message-Id: <1416912004-5928-177-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit e4742b1e786ca386e88e6cfb2801e14e15e365cd upstream.

The new Lenovo T440s laptop has a different PnP ID "LEN0039", and it
needs the similar min/max quirk to make its clickpad working.

BugLink: https://bugzilla.opensuse.org/show_bug.cgi?id=903748
Reported-and-tested-by: Joschi Brauchle <joschibrauchle@gmx.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/input/mouse/synaptics.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index 58902332cf33..3dcdeb785649 100644
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
2.1.0

