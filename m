Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934291AbaKLBlQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:41:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60158 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965055AbaKLBlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:41:11 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Axel Lin <axel.lin@ingics.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 3.14 077/203] media: tda7432: Fix setting TDA7432_MUTE bit for TDA7432_RF register
Date: Wed, 12 Nov 2014 10:15:47 +0900
Message-Id: <20141112011546.235083489@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011542.686743533@linuxfoundation.org>
References: <20141112011542.686743533@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@ingics.com>

commit 91ba0e59babdb3c7aca836a65f1095b3eaff7b06 upstream.

Fix a copy-paste bug when converting to the control framework.

Fixes: commit 5d478e0de871 ("[media] tda7432: convert to the control framework")

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/i2c/tda7432.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/i2c/tda7432.c
+++ b/drivers/media/i2c/tda7432.c
@@ -293,7 +293,7 @@ static int tda7432_s_ctrl(struct v4l2_ct
 		if (t->mute->val) {
 			lf |= TDA7432_MUTE;
 			lr |= TDA7432_MUTE;
-			lf |= TDA7432_MUTE;
+			rf |= TDA7432_MUTE;
 			rr |= TDA7432_MUTE;
 		}
 		/* Mute & update balance*/


