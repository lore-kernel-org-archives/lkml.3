Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946Ab3JUJIw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 05:08:52 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39724 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754096Ab3JUIwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:52:11 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Dave Jones" <davej@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Dave Jones" <davej@fedoraproject.org>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.710690636@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 101/149] caif: Add missing braces to multiline if in 
 cfctrl_linkup_request
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Jones <davej@redhat.com>

[ Upstream commit 0c1db731bfcf3a9fd6c58132134f8b0f423552f0 ]

The indentation here implies this was meant to be a multi-line if.

Introduced several years back in commit c85c2951d4da1236e32f1858db418221e624aba5
("caif: Handle dev_queue_xmit errors.")

Signed-off-by: Dave Jones <davej@fedoraproject.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/caif/cfctrl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/caif/cfctrl.c b/net/caif/cfctrl.c
index 5cf5222..84efbe4 100644
--- a/net/caif/cfctrl.c
+++ b/net/caif/cfctrl.c
@@ -288,9 +288,10 @@ int cfctrl_linkup_request(struct cflayer *layer,
 
 		count = cfctrl_cancel_req(&cfctrl->serv.layer,
 						user_layer);
-		if (count != 1)
+		if (count != 1) {
 			pr_err("Could not remove request (%d)", count);
 			return -ENODEV;
+		}
 	}
 	return 0;
 }

