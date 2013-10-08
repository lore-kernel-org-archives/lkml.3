Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793Ab3JHUu7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 16:50:59 -0400
Received: from mail.ispras.ru ([83.149.199.45]:46885 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752747Ab3JHUu6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 16:50:58 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Won Kang <wonkang@gctsemi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH 1/2] staging: gdm7240: alloc_mux_rx() does not need GFP_ATOMIC
Date: Wed,  9 Oct 2013 00:50:15 +0400
Message-Id: <1381265416-26333-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As far as alloc_mux_rx() is called from probe() only
there is no need in GFP_ATOMIC here.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/staging/gdm724x/gdm_mux.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/gdm724x/gdm_mux.c b/drivers/staging/gdm724x/gdm_mux.c
index 5b1ef40..5221cf9 100644
--- a/drivers/staging/gdm724x/gdm_mux.c
+++ b/drivers/staging/gdm724x/gdm_mux.c
@@ -96,12 +96,12 @@ static struct mux_rx *alloc_mux_rx(void)
 {
 	struct mux_rx *r = NULL;
 
-	r = kzalloc(sizeof(struct mux_rx), GFP_ATOMIC);
+	r = kzalloc(sizeof(struct mux_rx), GFP_KERNEL);
 	if (!r)
 		return NULL;
 
-	r->urb = usb_alloc_urb(0, GFP_ATOMIC);
-	r->buf = kmalloc(MUX_RX_MAX_SIZE, GFP_ATOMIC);
+	r->urb = usb_alloc_urb(0, GFP_KERNEL);
+	r->buf = kmalloc(MUX_RX_MAX_SIZE, GFP_KERNEL);
 	if (!r->urb || !r->buf) {
 		usb_free_urb(r->urb);
 		kfree(r->buf);
-- 
1.8.1.2

