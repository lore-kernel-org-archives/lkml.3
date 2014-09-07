Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821AbaIGS2b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 14:28:31 -0400
Received: from scspc499.cs.uwaterloo.ca ([129.97.171.80]:51235 "EHLO
	scspc499.cs.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010AbaIGS2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 14:28:30 -0400
Date: Sun, 7 Sep 2014 14:28:25 -0400
From: anicoara <anicoara@uwaterloo.ca>
To: shigekatsu.tateno@atmel.com
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] staging: ozwpan: use kmalloc_array over kmalloc with
 multiply
Message-ID: <20140907182825.GD2312@uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Adrian Nicoara <anicoara@uwaterloo.ca>
---
Patch submitted as part of the Eudyptula challenge.

 drivers/staging/ozwpan/ozhcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/ozwpan/ozhcd.c b/drivers/staging/ozwpan/ozhcd.c
index ba2168f..4cfe56e 100644
--- a/drivers/staging/ozwpan/ozhcd.c
+++ b/drivers/staging/ozwpan/ozhcd.c
@@ -1315,7 +1315,7 @@ static int oz_build_endpoints_for_config(struct usb_hcd *hcd,
 	if (num_iface) {
 		struct oz_interface *iface;

-		iface = kmalloc(num_iface*sizeof(struct oz_interface),
+		iface = kmalloc_array(num_iface, sizeof(struct oz_interface),
 				mem_flags | __GFP_ZERO);
 		if (!iface)
 			return -ENOMEM;
--
2.0.1

