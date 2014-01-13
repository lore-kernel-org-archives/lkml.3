Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181AbaAMQD4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:03:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53328 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754012AbaAMQD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:03:26 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 108/208] Input: allocate absinfo data when setting ABS capability
Date: Mon, 13 Jan 2014 15:59:09 +0000
Message-Id: <1389628849-1614-109-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 28a2a2e1aedbe2d8b2301e6e0e4e63f6e4177aca upstream.

We need to make sure we allocate absinfo data when we are setting one of
EV_ABS/ABS_XXX capabilities, otherwise we may bomb when we try to emit this
event.

Rested-by: Paul Cercueil <pcercuei@gmail.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/input/input.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/input/input.c b/drivers/input/input.c
index c044699..66984e2 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -1866,6 +1866,10 @@ void input_set_capability(struct input_dev *dev, unsigned int type, unsigned int
 		break;
 
 	case EV_ABS:
+		input_alloc_absinfo(dev);
+		if (!dev->absinfo)
+			return;
+
 		__set_bit(code, dev->absbit);
 		break;
 
-- 
1.8.3.2

