Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932816AbaKSUy6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 15:54:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56311 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932383AbaKSUyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 15:54:55 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 3.17 089/141] Input: synaptics - add min/max quirk for Lenovo T440s
Date: Wed, 19 Nov 2014 12:51:52 -0800
Message-Id: <20141119205153.573888535@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205150.700188369@linuxfoundation.org>
References: <20141119205150.700188369@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit e4742b1e786ca386e88e6cfb2801e14e15e365cd upstream.

The new Lenovo T440s laptop has a different PnP ID "LEN0039", and it
needs the similar min/max quirk to make its clickpad working.

BugLink: https://bugzilla.opensuse.org/show_bug.cgi?id=903748
Reported-and-tested-by: Joschi Brauchle <joschibrauchle@gmx.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/mouse/synaptics.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -135,8 +135,8 @@ static const struct min_max_quirk min_ma
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
@@ -163,6 +163,7 @@ static const char * const topbuttonpad_p
 	"LEN0036", /* T440 */
 	"LEN0037",
 	"LEN0038",
+	"LEN0039", /* T440s */
 	"LEN0041",
 	"LEN0042", /* Yoga */
 	"LEN0045",


