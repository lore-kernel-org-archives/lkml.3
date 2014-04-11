Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423162AbaDKQk2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 12:40:28 -0400
Received: from mail1.bemta5.messagelabs.com ([195.245.231.147]:46541 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422918AbaDKQkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 12:40:24 -0400
X-Env-Sender: Johannes.Thumshirn@men.de
X-Msg-Ref: server-5.tower-178.messagelabs.com!1397234418!26081338!1
X-Originating-IP: [80.255.6.145]
X-StarScan-Received: 
X-StarScan-Version: 6.11.1; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Fri, 11 Apr 2014 18:40:19 +0200
From: Johannes Thumshirn <johannes.thumshirn@men.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>,
        Johannes Thumshirn <Johannes.Thumshirn@men.de>,
        Christoph Jaeger <christophjaeger@linux.com>,
        Johannes Thumshirn <johannes.thumshirn@men.de>
Subject: [PATCH] drivers: mcb: fix memory leak in chameleon_parse_cells() error path
Date: Fri, 11 Apr 2014 18:40:05 +0200
Message-ID: <1397234405-11073-1-git-send-email-johannes.thumshirn@men.de>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.1.1.31]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Jaeger <christophjaeger@linux.com>

chameleon_parse_cells() bails out if chameleon descriptor type is
invalid but does not free the storage 'header' points to.

Signed-off-by: Christoph Jaeger <christophjaeger@linux.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@men.de>
---
 drivers/mcb/mcb-parse.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mcb/mcb-parse.c b/drivers/mcb/mcb-parse.c
index d1278b5..0049269 100644
--- a/drivers/mcb/mcb-parse.c
+++ b/drivers/mcb/mcb-parse.c
@@ -141,6 +141,7 @@ int chameleon_parse_cells(struct mcb_bus *bus, phys_addr_t mapbase,
 		default:
 			pr_err("Invalid chameleon descriptor type 0x%x\n",
 				dtype);
+			kfree(header);
 			return -EINVAL;
 		}
 		num_cells++;
-- 
1.9.1

