Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206AbaFFRe5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 13:34:57 -0400
Received: from mout.web.de ([212.227.17.12]:51499 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891AbaFFRez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 13:34:55 -0400
From: Ken Helias <kenhelias@web.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ken Helias <kenhelias@firemail.de>,
        linux-usb@vger.kernel.org
Subject: [PATCH 10/13] xhci: Use list_add_(before|after) macros
Date: Fri,  6 Jun 2014 19:34:29 +0200
Message-Id: <1402076072-4044-10-git-send-email-kenhelias@web.de>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1402076072-4044-1-git-send-email-kenhelias@web.de>
References: <1402076072-4044-1-git-send-email-kenhelias@web.de>
X-Provags-ID: V03:K0:RlYhfoSlBQkvoLPz4Ggpt+umCGLv43EVHSJjiDUM2Pd5UCfnHBI
 xJt0pkjIEZCQ+3nFfYnQxYLEn5WtiecIDJb4BexFZTvOdELFbKjv9TE6Jp7MAu8cHEk1Olw
 EtyCfHsMjG0gowbIEEgQ2swUFvqvhgVvb3DYnBIA/VXIZEUUJD2bOg5wTYH9LWNZMdj2LGP
 4JfAnd+v8ohPY1S+v/nIg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ken Helias <kenhelias@firemail.de>

Many places in the code uses list_add_tail/list_add to insert an entry
before/after another entry. This confuses the reader because these are usually
used to add an item to a list_head and not an entry. Better use the self
explaining function name.

Signed-off-by: Ken Helias <kenhelias@firemail.de>
Cc: linux-usb@vger.kernel.org
---
 drivers/usb/host/xhci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 2b8d9a2..4f4b702 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -2471,7 +2471,7 @@ static void xhci_add_ep_to_interval_table(struct xhci_hcd *xhci,
 		if (ep_bw->max_packet_size >=
 				smaller_ep->bw_info.max_packet_size) {
 			/* Add the new ep before the smaller endpoint */
-			list_add_tail(&virt_ep->bw_endpoint_list,
+			list_add_before(&virt_ep->bw_endpoint_list,
 					&smaller_ep->bw_endpoint_list);
 			return;
 		}
-- 
2.0.0

