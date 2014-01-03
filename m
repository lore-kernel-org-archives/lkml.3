Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169AbaACQHy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 11:07:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53993 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197AbaACQHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 11:07:53 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 4/7] Fix up a pointer-integer size mismatch warning in
 tps65217_probe()
From: David Howells <dhowells@redhat.com>
To: akpm@linux-foundation.org
Cc: dhowells@redhat.com, Samuel Ortiz <sameo@linux.intel.com>,
        AnilKumar Ch <anilkumar@ti.com>, linux-kernel@vger.kernel.org
Date: Fri, 03 Jan 2014 16:07:47 +0000
Message-ID: <20140103160747.8153.54905.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix up the following pointer-integer size mismatch warning in tps65217_probe():

	drivers/mfd/tps65217.c: In function 'tps65217_probe':
	drivers/mfd/tps65217.c:173:13: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
	   chip_id = (unsigned int)match->data;
		     ^

Signed-off-by: David Howells <dhowells@redhat.com>
cc: AnilKumar Ch <anilkumar@ti.com>
cc: Samuel Ortiz <sameo@linux.intel.com>
---

 drivers/mfd/tps65217.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/tps65217.c b/drivers/mfd/tps65217.c
index b7be0b295575..66195edc0ef4 100644
--- a/drivers/mfd/tps65217.c
+++ b/drivers/mfd/tps65217.c
@@ -170,7 +170,7 @@ static int tps65217_probe(struct i2c_client *client,
 				"Failed to find matching dt id\n");
 			return -EINVAL;
 		}
-		chip_id = (unsigned int)match->data;
+		chip_id = (unsigned int)(unsigned long)match->data;
 		status_off = of_property_read_bool(client->dev.of_node,
 					"ti,pmic-shutdown-controller");
 	}

