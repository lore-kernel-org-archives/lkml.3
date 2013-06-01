Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758373Ab3FAJjB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 05:39:01 -0400
Received: from www17.your-server.de ([213.133.104.17]:58617 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756906Ab3FAJi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 05:38:56 -0400
Message-ID: <1370079532.29224.5.camel@localhost.localdomain>
Subject: [PATCH] dlm: Cocci spatch "memdup.spatch"
From: Thomas Meyer <thomas@m3y3r.de>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Date: Sat, 01 Jun 2013 11:38:52 +0200
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

diff -u -p a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -1213,10 +1213,9 @@ static void init_local(void)
 		if (dlm_our_addr(&sas, i))
 			break;
 
-		addr = kmalloc(sizeof(*addr), GFP_NOFS);
+		addr = kmemdup(&sas, sizeof(*addr), GFP_NOFS);
 		if (!addr)
 			break;
-		memcpy(addr, &sas, sizeof(*addr));
 		dlm_local_addr[dlm_local_count++] = addr;
 	}
 }


