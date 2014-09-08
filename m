Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229AbaIHSpW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 14:45:22 -0400
Received: from scspc499.cs.uwaterloo.ca ([129.97.171.80]:52045 "EHLO
	scspc499.cs.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428AbaIHSpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 14:45:21 -0400
Date: Mon, 8 Sep 2014 14:45:13 -0400
From: Adrian Nicoara <anicoara@uwaterloo.ca>
To: shigekatsu.tateno@atmel.com
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, tklauser@distanz.ch
Subject: [PATCH v2 4/4] staging: ozwpan: use kmalloc_array over kmalloc with
 multiply
Message-ID: <20140908184513.GD17486@uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup checkpatch.pl warnings.

Signed-off-by: Adrian Nicoara <anicoara@uwaterloo.ca>
---
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

