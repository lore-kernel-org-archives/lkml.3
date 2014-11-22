Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483AbaKVOp7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 09:45:59 -0500
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:51827
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752099AbaKVOom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 09:44:42 -0500
X-IronPort-AV: E=Sophos;i="5.07,437,1413237600"; 
   d="scan'208";a="90017237"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Sebastian Reichel <sre@kernel.org>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] HSI: nokia-modem: fix error return code
Date: Sat, 22 Nov 2014 15:39:16 +0100
Message-Id: <1416667159-9808-4-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1416667159-9808-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1416667159-9808-1-git-send-email-Julia.Lawall@lip6.fr>
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
 drivers/hsi/clients/nokia-modem.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hsi/clients/nokia-modem.c b/drivers/hsi/clients/nokia-modem.c
index f0c2145..e07009a 100644
--- a/drivers/hsi/clients/nokia-modem.c
+++ b/drivers/hsi/clients/nokia-modem.c
@@ -199,6 +199,7 @@ static int nokia_modem_probe(struct device *dev)
 	modem->ssi_protocol = hsi_new_client(port, &ssip);
 	if (!modem->ssi_protocol) {
 		dev_err(dev, "Could not register ssi-protocol device\n");
+		err = -ENOMEM;
 		goto error2;
 	}
 

