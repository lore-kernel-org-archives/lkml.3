Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400AbaBJCUN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 21:20:13 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:39571 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532AbaBJCUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 21:20:11 -0500
X-Greylist: delayed 1083 seconds by postgrey-1.27 at vger.kernel.org; Sun, 09 Feb 2014 21:20:11 EST
From: Peter Hurley <peter@hurleysoftware.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Gianluca Anzolin <gianluca@sottospazio.it>,
        Alexander Holler <holler@ahsoftware.de>,
        Andrey Vihrov <andrey.vihrov@gmail.com>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 11/24] Bluetooth: Simplify RFCOMM session state eval
Date: Sun,  9 Feb 2014 20:59:11 -0500
Message-Id: <1391997564-1805-12-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1391997564-1805-1-git-send-email-peter@hurleysoftware.com>
References: <1391997564-1805-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Merge conditional test for BT_LISTEN session state into following
switch statement (which is functionally equivalent).

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 net/bluetooth/rfcomm/core.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/rfcomm/core.c b/net/bluetooth/rfcomm/core.c
index 646b6ff..b5a3785 100644
--- a/net/bluetooth/rfcomm/core.c
+++ b/net/bluetooth/rfcomm/core.c
@@ -1967,12 +1967,11 @@ static void rfcomm_process_sessions(void)
 			continue;
 		}
 
-		if (s->state == BT_LISTEN) {
+		switch (s->state) {
+		case BT_LISTEN:
 			rfcomm_accept_connection(s);
 			continue;
-		}
 
-		switch (s->state) {
 		case BT_BOUND:
 			s = rfcomm_check_connection(s);
 			break;
-- 
1.8.1.2

