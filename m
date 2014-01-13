Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398AbaAMOpP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 09:45:15 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51454 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbaAMO02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 09:26:28 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 61/96] Input: allocate absinfo data when setting ABS capability
Date: Mon, 13 Jan 2014 14:24:24 +0000
Message-Id: <1389623099-18783-62-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
References: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.29 -stable review patch.  If anyone has any objections, please let me know.

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
index 8921c61..d56c407 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -1707,6 +1707,10 @@ void input_set_capability(struct input_dev *dev, unsigned int type, unsigned int
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

