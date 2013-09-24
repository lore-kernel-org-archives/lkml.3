Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256Ab3IXPot (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 11:44:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36127 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411Ab3IXPor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 11:44:47 -0400
From: Joseph Salisbury <joseph.salisbury@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: dmitry.torokhov@gmail.com, rydberg@euromail.se, kamal@canonical.com,
        dudl@cypress.com, git@status.e4ward.com, tim.gardner@canonical.com,
        linux-input@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 1/1] Input: cypress_ps2 - Return zero finger count if palm is detected.
Date: Tue, 24 Sep 2013 11:44:38 -0400
Message-Id: <007c09ae4ef7f72ffb657de0fb3854fcbc6d88f0.1379968154.git.joseph.salisbury@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <cover.1379968154.git.joseph.salisbury@canonical.com>
References: <cover.1379968154.git.joseph.salisbury@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BugLink: http://bugs.launchpad.net/bugs/1229361

This patch sets the finger count to 0 in the case of palm contact.

Signed-off-by: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com> (maintainer:INPUT (KEYBOARD,...,commit_signer:2/2=100%)
Cc: Henrik Rydberg <rydberg@euromail.se> (maintainer:INPUT MULTITOUCH...)
Cc: Kamal Mostafa <kamal@canonical.com> (commit_signer:2/2=100%)
Cc: Dudley Du <dudl@cypress.com> (commit_signer:2/2=100%)
Cc: Kyle Fazzari <git@status.e4ward.com> (commit_signer:1/2=50%)
Cc: Tim Gardner <tim.gardner@canonical.com> (commit_signer:1/2=50%)
Cc: linux-input@vger.kernel.org (open list:INPUT (KEYBOARD,...)
Cc: linux-kernel@vger.kernel.org (open list)
Cc: stable@vger.kernel.org

---
 drivers/input/mouse/cypress_ps2.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/mouse/cypress_ps2.c b/drivers/input/mouse/cypress_ps2.c
index 45b3eda..95b2c40 100644
--- a/drivers/input/mouse/cypress_ps2.c
+++ b/drivers/input/mouse/cypress_ps2.c
@@ -441,7 +441,7 @@ static int cypress_get_finger_count(unsigned char header_byte)
 			case 2: return 5;
 			default:
 				/* Invalid contact (e.g. palm). Ignore it. */
-				return -1;
+				return 0;
 		}
 	}
 
@@ -460,7 +460,7 @@ static int cypress_parse_packet(struct psmouse *psmouse,
 
 	contact_cnt = cypress_get_finger_count(header_byte);
 
-	if (contact_cnt < 0) /* e.g. palm detect */
+	if (contact_cnt < 0)
 		return -EINVAL;
 
 	report_data->contact_cnt = contact_cnt;
-- 
1.7.9.5

