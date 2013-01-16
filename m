Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726Ab3APRPu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 12:15:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35636 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756649Ab3APP5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 10:57:55 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Felipe Balbi <balbi@ti.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 008/222] usb: gadget: midi: free hs descriptors
Date: Wed, 16 Jan 2013 13:53:28 -0200
Message-Id: <1358351822-7675-9-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

commit d185039f7982eb82cf8d03b6fb6689587ca5af24 upstream.

The HS descriptors are only created if HS is supported by the UDC but we
never free them.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/gadget/f_midi.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/gadget/f_midi.c b/drivers/usb/gadget/f_midi.c
index 2f7e8f2..1bf9596 100644
--- a/drivers/usb/gadget/f_midi.c
+++ b/drivers/usb/gadget/f_midi.c
@@ -416,6 +416,7 @@ static void f_midi_unbind(struct usb_configuration *c, struct usb_function *f)
 	midi->id = NULL;
 
 	usb_free_descriptors(f->descriptors);
+	usb_free_descriptors(f->hs_descriptors);
 	kfree(midi);
 }
 
-- 
1.7.9.5

