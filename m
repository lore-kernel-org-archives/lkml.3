Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135Ab3JGVqJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 17:46:09 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:50626 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212Ab3JGVqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 17:46:06 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: stefano.stabellini@eu.citrix.com, Rob Herring <rob.herring@calxeda.com>,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        Ashley Lai <ashley@ashleylai.com>, Rajiv Andrade <mail@srajiv.net>,
        Marcel Selhorst <tpmdd@selhorst.net>, Sirrix AG <tpmdd@sirrix.com>,
        tpmdd-devel@lists.sourceforge.net
Subject: [PATCH] tpm: xen-tpmfront: fix missing declaration of xen_domain
Date: Mon,  7 Oct 2013 16:45:53 -0500
Message-Id: <1381182353-12449-1-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

xen-tpmfront fails to build on arm64 with the following error:

drivers/char/tpm/xen-tpmfront.c: In function ‘xen_tpmfront_init’:
drivers/char/tpm/xen-tpmfront.c:422:2: error: implicit declaration of function ‘xen_domain’ [-Werror=implicit-function-declaration]

Add include of xen/xen.h to fix this.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>
Cc: Ashley Lai <ashley@ashleylai.com>
Cc: Rajiv Andrade <mail@srajiv.net>
Cc: Marcel Selhorst <tpmdd@selhorst.net>
Cc: Sirrix AG <tpmdd@sirrix.com>
Cc: tpmdd-devel@lists.sourceforge.net
---
 drivers/char/tpm/xen-tpmfront.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/tpm/xen-tpmfront.c b/drivers/char/tpm/xen-tpmfront.c
index 06189e5..94c280d 100644
--- a/drivers/char/tpm/xen-tpmfront.c
+++ b/drivers/char/tpm/xen-tpmfront.c
@@ -10,6 +10,7 @@
 #include <linux/errno.h>
 #include <linux/err.h>
 #include <linux/interrupt.h>
+#include <xen/xen.h>
 #include <xen/events.h>
 #include <xen/interface/io/tpmif.h>
 #include <xen/grant_table.h>
-- 
1.8.1.2

