Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068AbaAMPWg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 10:22:36 -0500
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:3675 "EHLO
	mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751924AbaAMPVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 10:21:45 -0500
X-IronPort-AV: E=Sophos;i="4.95,653,1384297200"; 
   d="scan'208";a="44621454"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Omar Ramirez Luna <omar.ramirez@copitl.com>
Cc: kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] staging: tidspbridge: delete useless variable
Date: Mon, 13 Jan 2014 17:17:27 +0100
Message-Id: <1389629847-5330-5-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1389629847-5330-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1389629847-5330-1-git-send-email-Julia.Lawall@lip6.fr>
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

