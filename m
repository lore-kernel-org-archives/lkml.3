Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751588AbaKWNRn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 08:17:43 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:56800 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751279AbaKWNQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 08:16:40 -0500
X-IronPort-AV: E=Sophos;i="5.07,443,1413237600"; 
   d="scan'208";a="109083689"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: linux-pcmcia@lists.infradead.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] electra_cf: fix error return code
Date: Sun, 23 Nov 2014 14:11:16 +0100
Message-Id: <1416748278-22881-4-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1416748278-22881-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1416748278-22881-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Return a negative error code on failure.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
identifier ret; expression e1,e2;
@@
(
if (\(ret < 0\|ret != 0\))
 { ... return ret; }
|
ret = 0
)
... when != ret = e1
    when != &ret
*if(...)
{
  ... when != ret = e2
      when forall
 return ret;
}
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/pcmcia/electra_cf.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pcmcia/electra_cf.c b/drivers/pcmcia/electra_cf.c
index 7f9950d..6a67a00 100644
--- a/drivers/pcmcia/electra_cf.c
+++ b/drivers/pcmcia/electra_cf.c
@@ -250,6 +250,7 @@ static int electra_cf_probe(struct platform_device *ofdev)
 
 	cf->socket.pci_irq = cf->irq;
 
+	status = -EINVAL;
 	prop = of_get_property(np, "card-detect-gpio", NULL);
 	if (!prop)
 		goto fail1;

