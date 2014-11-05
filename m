Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604AbaKEKLW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 05:11:22 -0500
Received: from ozlabs.org ([103.22.144.67]:40242 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754000AbaKEKLS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 05:11:18 -0500
From: Michael Ellerman <mpe@ellerman.id.au>
To: geoff@infradead.org, JBottomley@parallels.com
Cc: <linux-kernel@vger.kernel.org>, trivial@kernel.org
Subject: [PATCH] [SCSI] ps3rom: fix error return code
Date: Wed,  5 Nov 2014 21:11:10 +1100
Message-Id: <1415182270-25237-1-git-send-email-mpe@ellerman.id.au>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Set the return variable to an error code as done elsewhere in the function.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
---
 drivers/scsi/ps3rom.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/ps3rom.c b/drivers/scsi/ps3rom.c
index ef23fabe3924..619caf1acc9c 100644
--- a/drivers/scsi/ps3rom.c
+++ b/drivers/scsi/ps3rom.c
@@ -387,6 +387,7 @@ static int ps3rom_probe(struct ps3_system_bus_device *_dev)
 	if (!host) {
 		dev_err(&dev->sbd.core, "%s:%u: scsi_host_alloc failed\n",
 			__func__, __LINE__);
+		error = -ENOMEM;
 		goto fail_teardown;
 	}
 
-- 
1.9.1

