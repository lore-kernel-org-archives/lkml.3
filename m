Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301AbaHFUPa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 16:15:30 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:40882 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754185AbaHFUP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 16:15:27 -0400
X-IronPort-AV: E=Sophos;i="5.01,813,1400018400"; 
   d="scan'208";a="88519528"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: kernel-janitors@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] mfd: twl6040: fix error return code
Date: Wed,  6 Aug 2014 22:12:15 +0200
Message-Id: <1407355938-10932-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Convert a zero return value on error to a negative one, as returned
elsewhere in the function.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
(
if@p1 (\(ret < 0\|ret != 0\))
 { ... return ret; }
|
ret@p1 = 0
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
 drivers/mfd/twl6040.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/twl6040.c b/drivers/mfd/twl6040.c
index f9c06c5..9687645 100644
--- a/drivers/mfd/twl6040.c
+++ b/drivers/mfd/twl6040.c
@@ -679,6 +679,7 @@ static int twl6040_probe(struct i2c_client *client,
 	if (twl6040->rev < 0) {
 		dev_err(&client->dev, "Failed to read revision register: %d\n",
 			twl6040->rev);
+		ret = twl6040->rev;
 		goto gpio_err;
 	}
 

