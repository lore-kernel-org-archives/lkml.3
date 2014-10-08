Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563AbaJHQyc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 12:54:32 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:47726 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755181AbaJHQya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 12:54:30 -0400
Date: Wed, 8 Oct 2014 09:54:25 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: linux-input@vger.kernel.org
Cc: Henrik Rydberg <rydberg@euromail.se>, Hans de Goede <hdegoede@redhat.com>,
        David Herrmann <dh.herrmann@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>, jikos@jikos.cz,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Input: automatically set EV_ABS bit in input_set_abs_params
Message-ID: <20141008165425.GA23281@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let's automatically set EV_ABS bit in device's event type list when calling
input_set_abs_params() so that drivers do not have to do it explicitly.

These calls are never in a hot paths so we won't lose much time by setting
the same bit several times.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/input.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/input/input.c b/drivers/input/input.c
index 29ca0bb..d2e06cc 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -498,7 +498,8 @@ void input_set_abs_params(struct input_dev *dev, unsigned int axis,
 	absinfo->fuzz = fuzz;
 	absinfo->flat = flat;
 
-	dev->absbit[BIT_WORD(axis)] |= BIT_MASK(axis);
+	__set_bit(EV_ABS, dev->evbit);
+	__set_bit(axis, dev->absbit);
 }
 EXPORT_SYMBOL(input_set_abs_params);
 

-- 
Dmitry
