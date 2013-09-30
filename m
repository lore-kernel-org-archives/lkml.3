Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201Ab3I3TeR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 15:34:17 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:47693 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755258Ab3I3TeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 15:34:15 -0400
X-Greylist: delayed 527 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Sep 2013 15:34:15 EDT
Date: Mon, 30 Sep 2013 21:25:27 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Armin Schindler <mac@melware.de>
cc: Karsten Keil <isdn@linux-pingi.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] isdn: eicon: free pointer after using it in log msg in
 divas_um_idi_delete_entity()
Message-ID: <alpine.LNX.2.00.1309302119550.4992@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not really a problem, but nice IMHO; the Coverity static analyzer
complains that we use the pointer 'e' after it has been freed, so move
the freeing below the final use, even if that use is just using the
value of the pointer and not actually dereferencing it.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/isdn/hardware/eicon/um_idi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/isdn/hardware/eicon/um_idi.c b/drivers/isdn/hardware/eicon/um_idi.c
index 7cab5c3..e151971 100644
--- a/drivers/isdn/hardware/eicon/um_idi.c
+++ b/drivers/isdn/hardware/eicon/um_idi.c
@@ -288,9 +288,9 @@ int divas_um_idi_delete_entity(int adapter_nr, void *entity)
 	cleanup_entity(e);
 	diva_os_free(0, e->os_context);
 	memset(e, 0x00, sizeof(*e));
-	diva_os_free(0, e);

 	DBG_LOG(("A(%d) remove E:%08x", adapter_nr, e));
+	diva_os_free(0, e);

 	return (0);
 }
--
1.7.1


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

