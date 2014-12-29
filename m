Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495AbaL2RLv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 12:11:51 -0500
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:21740
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751473AbaL2RKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 12:10:52 -0500
X-IronPort-AV: E=Sophos;i="5.07,659,1413237600"; 
   d="scan'208";a="94921795"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: kernel-janitors@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/8] adm8211: fix error return code
Date: Mon, 29 Dec 2014 18:04:41 +0100
Message-Id: <1419872683-32709-7-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1419872683-32709-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1419872683-32709-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
 drivers/net/wireless/adm8211.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/adm8211.c b/drivers/net/wireless/adm8211.c
index 17fcaab..f07a618 100644
--- a/drivers/net/wireless/adm8211.c
+++ b/drivers/net/wireless/adm8211.c
@@ -1837,6 +1837,7 @@ static int adm8211_probe(struct pci_dev *pdev,
 	if (!priv->map) {
 		printk(KERN_ERR "%s (adm8211): Cannot map device memory\n",
 		       pci_name(pdev));
+		err = -ENOMEM;
 		goto err_free_dev;
 	}
 

