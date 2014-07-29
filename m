Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536AbaG2PX7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 11:23:59 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:15172 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753667AbaG2PT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 11:19:56 -0400
X-IronPort-AV: E=Sophos;i="5.01,757,1400018400"; 
   d="scan'208";a="87459214"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Karsten Keil <isdn@linux-pingi.de>
Cc: kernel-janitors@vger.kernel.org, linux-ia64@vger.kernel.org,
        ceph-devel@vger.kernel.org, toralf.foerster@gmx.de, hmh@hmh.eng.br,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/9] CAPI: use correct structure type name in sizeof
Date: Tue, 29 Jul 2014 17:16:44 +0200
Message-Id: <1406647011-8543-3-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1406647011-8543-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1406647011-8543-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Correct typo in the name of the type given to sizeof.  Because it is the
size of a pointer that is wanted, the typo has no impact on compilation or
execution.

This problem was found using Coccinelle (http://coccinelle.lip6.fr/).  The
semantic patch used can be found in message 0 of this patch series.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/isdn/capi/capi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/isdn/capi/capi.c b/drivers/isdn/capi/capi.c
index f9a87ed..6a2df32 100644
--- a/drivers/isdn/capi/capi.c
+++ b/drivers/isdn/capi/capi.c
@@ -1260,7 +1260,7 @@ static int __init capinc_tty_init(void)
 	if (capi_ttyminors <= 0)
 		capi_ttyminors = CAPINC_NR_PORTS;
 
-	capiminors = kzalloc(sizeof(struct capi_minor *) * capi_ttyminors,
+	capiminors = kzalloc(sizeof(struct capiminor *) * capi_ttyminors,
 			     GFP_KERNEL);
 	if (!capiminors)
 		return -ENOMEM;

