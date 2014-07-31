Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716AbaGaNsP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 09:48:15 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:57861 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853AbaGaNsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 09:48:08 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 04/18] staging: comedi: amplc_pci224: multiple assignments should be avoided
Date: Thu, 31 Jul 2014 14:47:41 +0100
Message-Id: <1406814475-5923-5-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406814475-5923-1-git-send-email-abbotti@mev.co.uk>
References: <1406814475-5923-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch issue: "CHECK: multiple assignments should be avoided".

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pci224.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci224.c b/drivers/staging/comedi/drivers/amplc_pci224.c
index e34bc5e..8e5d94a 100644
--- a/drivers/staging/comedi/drivers/amplc_pci224.c
+++ b/drivers/staging/comedi/drivers/amplc_pci224.c
@@ -1192,11 +1192,12 @@ static int pci224_attach_common(struct comedi_device *dev,
 		/* PCI234 range options. */
 		const struct comedi_lrange **range_table_list;
 
-		s->range_table_list = range_table_list =
+		range_table_list =
 		    kmalloc(sizeof(struct comedi_lrange *) * s->n_chan,
 			    GFP_KERNEL);
-		if (!s->range_table_list)
+		if (!range_table_list)
 			return -ENOMEM;
+		s->range_table_list = range_table_list;
 
 		if (options) {
 			for (n = 2; n < 3 + s->n_chan; n++) {
-- 
2.0.0

