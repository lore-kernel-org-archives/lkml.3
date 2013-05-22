Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087Ab3EVUBk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 16:01:40 -0400
Received: from www17.your-server.de ([213.133.104.17]:46600 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849Ab3EVUBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 16:01:39 -0400
X-Greylist: delayed 1373 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 May 2013 16:01:38 EDT
Message-ID: <1369251520.3865.321.camel@localhost.localdomain>
Subject: [PATCH] crypto: ux50: Cocci spatch "resource_size.spatch"
From: Thomas Meyer <thomas@m3y3r.de>
To: herbert@gondor.hengli.com.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 22 May 2013 21:38:40 +0200
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

diff -u -p a/drivers/crypto/ux500/cryp/cryp_core.c b/drivers/crypto/ux500/cryp/cryp_core.c
--- a/drivers/crypto/ux500/cryp/cryp_core.c
+++ b/drivers/crypto/ux500/cryp/cryp_core.c
@@ -1600,7 +1600,7 @@ static int ux500_cryp_remove(struct plat
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (res)
-		release_mem_region(res->start, res->end - res->start + 1);
+		release_mem_region(res->start, resource_size(res));
 
 	kfree(device_data);
 


