Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758935Ab3FAJxu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 05:53:50 -0400
Received: from www17.your-server.de ([213.133.104.17]:60331 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758562Ab3FAJxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 05:53:44 -0400
Message-ID: <1370080418.29224.26.camel@localhost.localdomain>
Subject: [PATCH] x86, olpc: Cocci spatch "ptr_ret.spatch"
From: Thomas Meyer <thomas@m3y3r.de>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        grant.likely@linaro.org, rob.herring@calxeda.com,
        linux-kernel@vger.kernel.org
Date: Sat, 01 Jun 2013 11:53:38 +0200
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

diff -u -p a/arch/x86/platform/olpc/olpc.c b/arch/x86/platform/olpc/olpc.c
--- a/arch/x86/platform/olpc/olpc.c
+++ b/arch/x86/platform/olpc/olpc.c
@@ -311,10 +311,7 @@ static int __init add_xo1_platform_devic
 		return PTR_ERR(pdev);
 
 	pdev = platform_device_register_simple("olpc-xo1", -1, NULL, 0);
-	if (IS_ERR(pdev))
-		return PTR_ERR(pdev);
-
-	return 0;
+	return PTR_RET(pdev);
 }
 
 static int olpc_xo1_ec_probe(struct platform_device *pdev)


