Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab3ISVob (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 17:44:31 -0400
Received: from www17.your-server.de ([213.133.104.17]:55682 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525Ab3ISVo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 17:44:29 -0400
Subject: [PATCH 2/10] xtensa: Cocci spatch "noderef"
From: Thomas Meyer <thomas@m3y3r.de>
To: chris@zankel.net, jcmvbkbc@gmail.com, linux-xtensa@linux-xtensa.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Message-ID: <1379604755851-2004428468-2-diffsplit-thomas@m3y3r.de>
References: <1379604755850-858421494-0-diffsplit-thomas@m3y3r.de>
In-Reply-To: <1379604755850-858421494-0-diffsplit-thomas@m3y3r.de>
Date: Thu, 19 Sep 2013 23:42:22 +0200
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sizeof when applied to a pointer typed expression gives the size of the
pointer.
Found by coccinelle spatch "misc/noderef.cocci"

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/arch/xtensa/platforms/iss/network.c b/arch/xtensa/platforms/iss/network.c
--- a/arch/xtensa/platforms/iss/network.c
+++ b/arch/xtensa/platforms/iss/network.c
@@ -737,7 +737,7 @@ static int __init iss_net_setup(char *st
 		return 1;
 	}
 
-	if ((new = alloc_bootmem(sizeof new)) == NULL) {
+	if ((new = alloc_bootmem(sizeof *new)) == NULL) {
 		printk("Alloc_bootmem failed\n");
 		return 1;
 	}
