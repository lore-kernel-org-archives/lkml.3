Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531Ab3ITJus (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 05:50:48 -0400
Received: from www17.your-server.de ([213.133.104.17]:35753 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754495Ab3ITJuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 05:50:46 -0400
Subject: [PATCH 1/10] MIPS: BCM47XX: Cocci spatch "noderef"
From: Thomas Meyer <thomas@m3y3r.de>
To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Message-ID: <1379604755851-1504037195-1-diffsplit-thomas@m3y3r.de>
References: <1379604755850-858421494-0-diffsplit-thomas@m3y3r.de>
In-Reply-To: <1379604755850-858421494-0-diffsplit-thomas@m3y3r.de>
Date: Thu, 19 Sep 2013 23:45:46 +0200
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

diff -u -p a/arch/mips/bcm47xx/sprom.c b/arch/mips/bcm47xx/sprom.c
--- a/arch/mips/bcm47xx/sprom.c
+++ b/arch/mips/bcm47xx/sprom.c
@@ -162,7 +162,7 @@ static void nvram_read_alpha2(const char
 		pr_warn("alpha2 is too long %s\n", buf);
 		return;
 	}
-	memcpy(val, buf, sizeof(val));
+	memcpy(val, buf, sizeof(*val));
 }
 
 static void bcm47xx_fill_sprom_r1234589(struct ssb_sprom *sprom,
