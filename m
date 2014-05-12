Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856AbaELBlg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 21:41:36 -0400
Received: from 1wt.eu ([62.212.114.60]:34338 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750986AbaELBla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:41:30 -0400
Message-Id: <20140512003202.222981268@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:32:38 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: =?ISO-8859-15?q?Salva=20Peir=F3?= <speiro@ai2.upv.es>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 038/143] wanxl: fix info leak in ioctl
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: =?latin1?q?Salva=20Peir=F3?= <speiro@ai2.upv.es>

[ Upstream commit 2b13d06c9584b4eb773f1e80bbaedab9a1c344e1 ]

The wanxl_ioctl() code fails to initialize the two padding bytes of
struct sync_serial_settings after the ->loopback member. Add an explicit
memset(0) before filling the structure to avoid the info leak.

Signed-off-by: Salva Peiró <speiro@ai2.upv.es>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/net/wan/wanxl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wan/wanxl.c b/drivers/net/wan/wanxl.c
index daee8a0..b52b378 100644
--- a/drivers/net/wan/wanxl.c
+++ b/drivers/net/wan/wanxl.c
@@ -354,6 +354,7 @@ static int wanxl_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 			ifr->ifr_settings.size = size; /* data size wanted */
 			return -ENOBUFS;
 		}
+		memset(&line, 0, sizeof(line));
 		line.clock_type = get_status(port)->clocking;
 		line.clock_rate = 0;
 		line.loopback = 0;
-- 
1.7.12.2.21.g234cd45.dirty



