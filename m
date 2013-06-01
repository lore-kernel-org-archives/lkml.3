Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759025Ab3FAJ4S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 05:56:18 -0400
Received: from www17.your-server.de ([213.133.104.17]:60668 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756741Ab3FAJ4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 05:56:11 -0400
Message-ID: <1370080565.29224.29.camel@localhost.localdomain>
Subject: [PATCH] virtio-mmio: Cocci spatch "ptr_ret.spatch"
From: Thomas Meyer <thomas@m3y3r.de>
To: rusty@rustcorp.com.au, mst@redhat.com, grant.likely@linaro.org,
        rob.herring@calxeda.com, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Date: Sat, 01 Jun 2013 11:56:05 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
--- a/drivers/virtio/virtio_mmio.c
+++ b/drivers/virtio/virtio_mmio.c
@@ -567,10 +567,7 @@ static int vm_cmdline_set(const char *de
 	pdev = platform_device_register_resndata(&vm_cmdline_parent,
 			"virtio-mmio", vm_cmdline_id++,
 			resources, ARRAY_SIZE(resources), NULL, 0);
-	if (IS_ERR(pdev))
-		return PTR_ERR(pdev);
-
-	return 0;
+	return PTR_RET(pdev);
 }
 
 static int vm_cmdline_get_device(struct device *dev, void *data)


