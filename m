Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524Ab3LSIee (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 03:34:34 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:35170 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab3LSIed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 03:34:33 -0500
Date: Thu, 19 Dec 2013 14:04:25 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Rashika Kheria <rashika.kheria@gmail.com>,
        linux-pcmcia@lists.infradead.org, josh@joshtriplett.org
Subject: [PATCH 2/3] drivers: pcmcia: Include appropriate header file in
 cs_internal.h
Message-ID: <e3c2ceb33568badbc62ebb0e2a11999a2181a489.1387387468.git.rashika.kheria@gmail.com>
References: <7fc39fa8a73bfcca6f379c6cd53cdb1659fc9d12.1387387468.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7fc39fa8a73bfcca6f379c6cd53cdb1659fc9d12.1387387468.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include header file include/pcmcia/cistpl.h in cs_internal.h because
definition of variables 'cisdats_t', ‘cisparse_t’ and ‘tuple_t’ is
present in include/pcmcia/cistpl.h.

This eliminates the following errors in cs_internal.h:
drivers/pcmcia/cs_internal.h:164:9: error: unknown type name ‘cisdata_t’
drivers/pcmcia/cs_internal.h:171:25: error: unknown type name ‘cisparse_t’
drivers/pcmcia/cs_internal.h:172:28: error: unknown type name ‘tuple_t’

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/pcmcia/cs_internal.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pcmcia/cs_internal.h b/drivers/pcmcia/cs_internal.h
index 7f1953f..ce03389 100644
--- a/drivers/pcmcia/cs_internal.h
+++ b/drivers/pcmcia/cs_internal.h
@@ -22,6 +22,7 @@
 #define _LINUX_CS_INTERNAL_H
 
 #include <linux/kref.h>
+#include <pcmcia/cistpl.h>
 
 /* Flags in client state */
 #define CLIENT_WIN_REQ(i)	(0x1<<(i))
-- 
1.7.9.5

