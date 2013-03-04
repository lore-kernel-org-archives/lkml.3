Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755744Ab3CDEWx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 23:22:53 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60733 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755230Ab3CDDm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:42:28 -0500
Message-Id: <20130304033708.634981727@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:37:17 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Jean Delvare <khali@linux-fr.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 010/153] pcmcia/vrc4171: Add missing spinlock init
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean Delvare <khali@linux-fr.org>

commit 811af9723859884f2f771f3174f3ddedab7c53b5 upstream.

It doesn't seem this spinlock was properly initialized. This bug was
introduced by commit 7a410e8d4d97457c8c381e2de9cdc7bd3306badc.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/pcmcia/vrc4171_card.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/pcmcia/vrc4171_card.c
+++ b/drivers/pcmcia/vrc4171_card.c
@@ -246,6 +246,7 @@ static int pccard_init(struct pcmcia_soc
 	socket = &vrc4171_sockets[slot];
 	socket->csc_irq = search_nonuse_irq();
 	socket->io_irq = search_nonuse_irq();
+	spin_lock_init(&socket->lock);
 
 	return 0;
 }


