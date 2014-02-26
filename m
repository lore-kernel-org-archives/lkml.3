Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205AbaBZTJM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 14:09:12 -0500
Received: from mail-ig0-f175.google.com ([209.85.213.175]:46685 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638AbaBZTJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 14:09:08 -0500
Subject: [PATCH 1/4] i2o: Fix I/O space allocation copy/paste error
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: Markus Lidel <Markus.Lidel@shadowconnect.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 26 Feb 2014 12:09:06 -0700
Message-ID: <20140226190906.9616.52057.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20140226190306.9616.30567.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140226190306.9616.30567.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When i2o_iop_systab_set() allocates I/O port space, it assigns the base of
the new I/O port region to sb->current_mem_base, not sb->current_io_base.
This looks like a copy/paste error, because we do use current_io_base, but
there's no other place that sets it.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/message/i2o/iop.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/message/i2o/iop.c b/drivers/message/i2o/iop.c
index a8c08f332da0..a8373d7aaef7 100644
--- a/drivers/message/i2o/iop.c
+++ b/drivers/message/i2o/iop.c
@@ -704,7 +704,7 @@ static int i2o_iop_systab_set(struct i2o_controller *c)
 					      NULL, NULL) >= 0) {
 			c->io_alloc = 1;
 			sb->current_io_size = resource_size(res);
-			sb->current_mem_base = res->start;
+			sb->current_io_base = res->start;
 			osm_info("%s: allocated %llu bytes of PCI I/O at "
 				"0x%016llX.\n", c->name,
 				(unsigned long long)resource_size(res),

