Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990AbaB1VXt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 16:23:49 -0500
Received: from qmta13.emeryville.ca.mail.comcast.net ([76.96.27.243]:55326
	"EHLO qmta13.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752491AbaB1VXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 16:23:08 -0500
From: Shuah Khan <shuah.kh@samsung.com>
To: m.chehab@samsung.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com
Subject: [PATCH 1/3] media/drx39xyj: fix pr_dbg undefined compile errors when DJH_DEBUG is defined
Date: Fri, 28 Feb 2014 14:23:00 -0700
Message-Id: <88f91cfa309e47267d31f9ce176f839f6e309d95.1393621530.git.shuah.kh@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <cover.1393621530.git.shuah.kh@samsung.com>
References: <cover.1393621530.git.shuah.kh@samsung.com>
In-Reply-To: <cover.1393621530.git.shuah.kh@samsung.com>
References: <cover.1393621530.git.shuah.kh@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drxj.c fails to compile with the following errors when DJH_DEBUG
is defined.

drivers/media/dvb-frontends/drx39xyj/drxj.c:1567:2: error: implicit declaration of function ‘pr_dbg’ [-Werror=implicit-function-declaration]
  pr_dbg("drx3933 i2c operation addr=%x i2c=%p, wc=%x rc=%x\n",
  ^

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drxj.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index ed68c52..a78af4e 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -1562,7 +1562,7 @@ int drxbsp_i2c_write_read(struct i2c_device_addr *w_dev_addr,
 		 .flags = I2C_M_RD, .buf = r_data, .len = r_count},
 	};
 
-	pr_dbg("drx3933 i2c operation addr=%x i2c=%p, wc=%x rc=%x\n",
+	pr_debug("drx3933 i2c operation addr=%x i2c=%p, wc=%x rc=%x\n",
 	       w_dev_addr->i2c_addr, state->i2c, w_count, r_count);
 
 	if (i2c_transfer(state->i2c, msg, 2) != 2) {
@@ -20640,7 +20640,7 @@ static int drx39xxj_set_frontend(struct dvb_frontend *fe)
 	for (i = 0; i < 2000; i++) {
 		fe_status_t status;
 		drx39xxj_read_status(fe, &status);
-		pr_dbg("i=%d status=%d\n", i, status);
+		pr_debug("i=%d status=%d\n", i, status);
 		msleep(100);
 		i += 100;
 	}
@@ -20663,7 +20663,7 @@ static int drx39xxj_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
 	int result;
 
 #ifdef DJH_DEBUG
-	pr_dbg("i2c gate call: enable=%d state=%d\n", enable,
+	pr_debug("i2c gate call: enable=%d state=%d\n", enable,
 	       state->i2c_gate_open);
 #endif
 
-- 
1.8.3.2

