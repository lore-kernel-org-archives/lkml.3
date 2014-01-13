Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984AbaAMQMi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:12:38 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:24472 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751695AbaAMQMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:12:34 -0500
X-IronPort-AV: E=Sophos;i="4.95,653,1384297200"; 
   d="scan'208";a="53033621"
Date: Mon, 13 Jan 2014 17:12:09 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Dan Carpenter <dan.carpenter@oracle.com>
cc: Omar Ramirez Luna <omar.ramirez@copitl.com>, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] staging: tidspbridge: adjust error return code
 (bugfix)
Message-ID: <alpine.DEB.2.10.1401131711220.2084@hadrien>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

The variable status is initialized to either 0 or an error code.  Return
status to propagate the error value.

A simplified version of the semantic patch that fixes this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
type T;
identifier i;
constant c;
@@

-T i;
<... when != i
-i = c;
...>
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
Most remove functions only return 0, as this one did before the change.  So
perhaps the correct solution is to remove the status variable?

 drivers/staging/tidspbridge/rmgr/drv_interface.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/tidspbridge/rmgr/drv_interface.c b/drivers/staging/tidspbridge/rmgr/drv_interface.c
index cafca46..74d31da 100644
--- a/drivers/staging/tidspbridge/rmgr/drv_interface.c
+++ b/drivers/staging/tidspbridge/rmgr/drv_interface.c
@@ -589,7 +589,7 @@ func_cont:
 		class_destroy(bridge_class);

 	}
-	return 0;
+	return status;
 }

 #ifdef CONFIG_PM

