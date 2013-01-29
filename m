Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529Ab3A2Dhi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 22:37:38 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:48767 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756408Ab3A2Dfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 22:35:33 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 02/11] staging/fwserial: Release port regardless of unplug response code
Date: Mon, 28 Jan 2013 22:34:36 -0500
Message-Id: <1359430485-5301-2-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1359430485-5301-1-git-send-email-peter@hurleysoftware.com>
References: <1359430485-5301-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After sending the unplug response, release the port even if an
error occurred.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/staging/fwserial/fwserial.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/fwserial/fwserial.c b/drivers/staging/fwserial/fwserial.c
index b1482ef..055085d 100644
--- a/drivers/staging/fwserial/fwserial.c
+++ b/drivers/staging/fwserial/fwserial.c
@@ -2675,10 +2675,9 @@ static void fwserial_handle_unplug_req(struct work_struct *work)
 
 	spin_lock_bh(&peer->lock);
 	if (peer->state == FWPS_UNPLUG_RESPONDING) {
-		if (rcode == RCODE_COMPLETE)
-			port = peer_revert_state(peer);
-		else
+		if (rcode != RCODE_COMPLETE)
 			fwtty_err(&peer->unit, "UNPLUG_RSP error (%d)", rcode);
+		port = peer_revert_state(peer);
 	}
 cleanup:
 	spin_unlock_bh(&peer->lock);
-- 
1.8.1.1

