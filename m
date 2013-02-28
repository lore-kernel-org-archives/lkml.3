Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759601Ab3B1O4U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:56:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42518 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933049Ab3B1Ou4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:50:56 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 123/139] sunvdc: Fix off-by-one in generic_request().
Date: Thu, 28 Feb 2013 14:44:33 +0000
Message-Id: <1362062689-2567-124-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

commit f4d9605434c0fd4cc8639bf25cfc043418c52362 upstream.

The 'operations' bitmap corresponds one-for-one with the operation
codes, no adjustment is necessary.

Reported-by: Mark Kettenis <mark.kettenis@xs4all.nl>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/block/sunvdc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/sunvdc.c b/drivers/block/sunvdc.c
index 9dcf76a..31dd451 100644
--- a/drivers/block/sunvdc.c
+++ b/drivers/block/sunvdc.c
@@ -461,7 +461,7 @@ static int generic_request(struct vdc_port *port, u8 op, void *buf, int len)
 	int op_len, err;
 	void *req_buf;
 
-	if (!(((u64)1 << ((u64)op - 1)) & port->operations))
+	if (!(((u64)1 << (u64)op) & port->operations))
 		return -EOPNOTSUPP;
 
 	switch (op) {
-- 
1.8.1.2

