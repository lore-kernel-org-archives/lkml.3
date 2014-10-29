Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934410AbaJ2QEg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 12:04:36 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:46792 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933691AbaJ2QEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 12:04:34 -0400
From: Andrey Utkin <andrey.krieger.utkin@gmail.com>
To: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
Cc: ismael.luceno@corp.bluecherry.net, m.chehab@samsung.com,
        hverkuil@xs4all.nl, Andrey Utkin <andrey.krieger.utkin@gmail.com>
Subject: [PATCH 4/4] [media] solo6x10: don't turn off/on encoder interrupt in processing loop
Date: Wed, 29 Oct 2014 20:03:54 +0400
Message-Id: <1414598634-13446-4-git-send-email-andrey.krieger.utkin@gmail.com>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1414598634-13446-1-git-send-email-andrey.krieger.utkin@gmail.com>
References: <1414598634-13446-1-git-send-email-andrey.krieger.utkin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The used approach actually cannot prevent new encoder interrupt to
appear, because interrupt handler can execute in different thread, and
in current implementation there is still race condition regarding this.
Also from practice the code with this change seems to work as stable as
before.

Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>
---
 drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
index b9b61b9..30e09d9 100644
--- a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
+++ b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
@@ -703,9 +703,7 @@ static int solo_ring_thread(void *data)
 
 		if (timeout == -ERESTARTSYS || kthread_should_stop())
 			break;
-		solo_irq_off(solo_dev, SOLO_IRQ_ENCODER);
 		solo_handle_ring(solo_dev);
-		solo_irq_on(solo_dev, SOLO_IRQ_ENCODER);
 		try_to_freeze();
 	}
 
-- 
1.8.5.5

