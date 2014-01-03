Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285AbaACQIF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 11:08:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46729 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098AbaACQIC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 11:08:02 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 5/7] Fix up a pointer-integer size mismatch warning in
 tps62360_probe()
From: David Howells <dhowells@redhat.com>
To: akpm@linux-foundation.org
Cc: dhowells@redhat.com, Laxman Dewangan <ldewangan@nvidia.com>,
        linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Fri, 03 Jan 2014 16:07:55 +0000
Message-ID: <20140103160755.8153.81654.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix up the following pointer-integer size mismatch warning in tps62360_probe():

	drivers/regulator/tps62360-regulator.c: In function 'tps62360_probe':
	drivers/regulator/tps62360-regulator.c:363:13: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
	   chip_id = (int)match->data;
		     ^

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Laxman Dewangan <ldewangan@nvidia.com>
cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
---

 drivers/regulator/tps62360-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/tps62360-regulator.c b/drivers/regulator/tps62360-regulator.c
index c2c0185a2dcd..c3fa15a299b1 100644
--- a/drivers/regulator/tps62360-regulator.c
+++ b/drivers/regulator/tps62360-regulator.c
@@ -360,7 +360,7 @@ static int tps62360_probe(struct i2c_client *client,
 			dev_err(&client->dev, "Error: No device match found\n");
 			return -ENODEV;
 		}
-		chip_id = (int)match->data;
+		chip_id = (int)(long)match->data;
 		if (!pdata)
 			pdata = of_get_tps62360_platform_data(&client->dev);
 	} else if (id) {

