Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005AbaACQHw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 11:07:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37642 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197AbaACQHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 11:07:50 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 3/7] Fix up a pointer-integer size mismatch warning in
 max8998_i2c_get_driver_data()
From: David Howells <dhowells@redhat.com>
To: akpm@linux-foundation.org
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
        Tomasz Figa <t.figa@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@linaro.org>
Date: Fri, 03 Jan 2014 16:07:39 +0000
Message-ID: <20140103160739.8153.38553.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix up the following pointer-integer size mismatch warning in
max8998_i2c_get_driver_data():

	drivers/mfd/max8998.c: In function 'max8998_i2c_get_driver_data':
	drivers/mfd/max8998.c:178:10: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
		return (int)match->data;
		       ^

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Tomasz Figa <t.figa@samsung.com>
cc: Mark Brown <broonie@linaro.org>
cc: Samuel Ortiz <sameo@linux.intel.com>
---

 drivers/mfd/max8998.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/max8998.c b/drivers/mfd/max8998.c
index fe6332dcabee..5d6385998e83 100644
--- a/drivers/mfd/max8998.c
+++ b/drivers/mfd/max8998.c
@@ -175,7 +175,7 @@ static inline int max8998_i2c_get_driver_data(struct i2c_client *i2c,
 	if (IS_ENABLED(CONFIG_OF) && i2c->dev.of_node) {
 		const struct of_device_id *match;
 		match = of_match_node(max8998_dt_match, i2c->dev.of_node);
-		return (int)match->data;
+		return (int)(long)match->data;
 	}
 
 	return (int)id->driver_data;

