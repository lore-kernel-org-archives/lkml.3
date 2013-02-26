Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933081Ab3B0Atq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:49:46 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42195 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932156Ab3BZX6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:58:22 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jean Delvare <khali@linux-fr.org>
Subject: [ 113/150] pcmcia/vrc4171: Add missing spinlock init
Date: Tue, 26 Feb 2013 15:56:10 -0800
Message-Id: <20130226235535.827158973@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235523.930663721@linuxfoundation.org>
References: <20130226235523.930663721@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean Delvare <khali@linux-fr.org>

commit 811af9723859884f2f771f3174f3ddedab7c53b5 upstream.

It doesn't seem this spinlock was properly initialized. This bug was
introduced by commit 7a410e8d4d97457c8c381e2de9cdc7bd3306badc.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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


