Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141AbaDDTGH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 15:06:07 -0400
Received: from smtprelay01.ispgateway.de ([80.67.31.35]:33054 "EHLO
	smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754042AbaDDTGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 15:06:05 -0400
From: Christoph Jaeger <christophjaeger@linux.com>
To: johannes.thumshirn@men.de
Cc: linux-kernel@vger.kernel.org, Christoph Jaeger <christophjaeger@linux.com>
Subject: [PATCH] drivers: mcb: fix memory leak in chameleon_parse_cells() error path
Date: Fri,  4 Apr 2014 21:04:58 +0200
Message-Id: <1396638298-3173-1-git-send-email-christophjaeger@linux.com>
X-Mailer: git-send-email 1.9.0
X-Df-Sender: MTg4NDM4Mw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

chameleon_parse_cells() bails out if chameleon descriptor type is
invalid but does not free the storage 'header' points to.

Signed-off-by: Christoph Jaeger <christophjaeger@linux.com>
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
1.9.0

