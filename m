Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933487Ab3GCXYn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 19:24:43 -0400
Received: from cm-84.215.157.11.getinternet.no ([84.215.157.11]:54225 "EHLO
	server.arpanet.local" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933096Ab3GCXYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 19:24:42 -0400
From: =?UTF-8?q?Jon=20Arne=20J=C3=B8rgensen?= <jonarne@jonarne.no>
To: linux-media@vger.kernel.org
Cc: jonarne@jonarne.no, linux-kernel@vger.kernel.org, mchehab@redhat.com,
        hans.verkuil@cisco.com, prabhakar.csengg@gmail.com,
        laurent.pinchart@ideasonboard.com, andriy.shevchenko@linux.intel.com
Subject: [RFC v3 2/3] saa7115: Do not load saa7115_init_misc for gm7113c
Date: Thu,  4 Jul 2013 01:27:19 +0200
Message-Id: <1372894040-23922-3-git-send-email-jonarne@jonarne.no>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1372894040-23922-1-git-send-email-jonarne@jonarne.no>
References: <1372894040-23922-1-git-send-email-jonarne@jonarne.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of the registers changed in saa7115_init_misc table are out of range
for the gm7113c chip.
The only register that's within range doesn't need to be changed here.

Signed-off-by: Jon Arne Jørgensen <jonarne@jonarne.no>
---
 drivers/media/i2c/saa7115.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/saa7115.c b/drivers/media/i2c/saa7115.c
index 41408dd..17a464d 100644
--- a/drivers/media/i2c/saa7115.c
+++ b/drivers/media/i2c/saa7115.c
@@ -1769,7 +1769,7 @@ static int saa711x_probe(struct i2c_client *client,
 		state->crystal_freq = SAA7115_FREQ_32_11_MHZ;
 		saa711x_writeregs(sd, saa7115_init_auto_input);
 	}
-	if (state->ident > SAA7111A)
+	if (state->ident > SAA7111A && state->ident != GM7113C)
 		saa711x_writeregs(sd, saa7115_init_misc);
 	saa711x_set_v4lstd(sd, V4L2_STD_NTSC);
 	v4l2_ctrl_handler_setup(hdl);
-- 
1.8.3.1

