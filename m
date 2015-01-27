Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759073AbbA0Mge (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:36:34 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35196 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758553AbbA0MSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:18:46 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Anthony Liguori <aliguori@amazon.com>, Imre Palik <imrep@amazon.de>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 068/126] xen-netback: fixing the propagation of the transmit shaper timeout
Date: Tue, 27 Jan 2015 12:16:13 +0000
Message-Id: <1422361031-19364-69-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Palik, Imre" <imrep@amazon.de>

commit 07ff890daeda31cf23173865edf50bcb03e100c3 upstream.

Since e9ce7cb6b107 ("xen-netback: Factor queue-specific data into queue struct"),
the transimt shaper timeout is always set to 0.  The value the user sets via
xenbus is never propagated to the transmit shaper.

This patch fixes the issue.

Cc: Anthony Liguori <aliguori@amazon.com>
Signed-off-by: Imre Palik <imrep@amazon.de>
Acked-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/xen-netback/xenbus.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/xen-netback/xenbus.c b/drivers/net/xen-netback/xenbus.c
index 3d85acd84bad..9378a17c9553 100644
--- a/drivers/net/xen-netback/xenbus.c
+++ b/drivers/net/xen-netback/xenbus.c
@@ -549,6 +549,7 @@ static void connect(struct backend_info *be)
 		}
 
 		queue->remaining_credit = credit_bytes;
+		queue->credit_usec = credit_usec;
 
 		err = connect_rings(be, queue);
 		if (err) {
-- 
2.1.4

