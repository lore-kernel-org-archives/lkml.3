Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932AbaAMO0J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 09:26:09 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51173 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619AbaAMOZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 09:25:14 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Frederik Himpe <fhimpe@telenet.be>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 05/96] [media] cxd2820r_core: fix sparse warnings
Date: Mon, 13 Jan 2014 14:23:28 +0000
Message-Id: <1389623099-18783-6-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
References: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.29 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Verkuil <hans.verkuil@cisco.com>

commit 0db3fa2741ad8371c21b3a6785416a4afc0cc1d4 upstream.

drivers/media/dvb-frontends/cxd2820r_core.c:34:32: error: cannot size expression
drivers/media/dvb-frontends/cxd2820r_core.c:68:32: error: cannot size expression

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Antti Palosaari <crope@iki.fi>
Reviewed-by: Antti Palosaari <crope@iki.fi>
Reviewed-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Frederik Himpe <fhimpe@telenet.be>
[ luis: backported to 3.5:
  - file rename: drivers/media/dvb-frontends/cxd2820r_core.c - >
    drivers/media/dvb/frontends/cxd2820r_core.c ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/media/dvb/frontends/cxd2820r_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/frontends/cxd2820r_core.c b/drivers/media/dvb/frontends/cxd2820r_core.c
index 3bba37d..2ff04b1 100644
--- a/drivers/media/dvb/frontends/cxd2820r_core.c
+++ b/drivers/media/dvb/frontends/cxd2820r_core.c
@@ -35,7 +35,7 @@ static int cxd2820r_wr_regs_i2c(struct cxd2820r_priv *priv, u8 i2c, u8 reg,
 		{
 			.addr = i2c,
 			.flags = 0,
-			.len = sizeof(buf),
+			.len = len + 1,
 			.buf = buf,
 		}
 	};
@@ -68,7 +68,7 @@ static int cxd2820r_rd_regs_i2c(struct cxd2820r_priv *priv, u8 i2c, u8 reg,
 		}, {
 			.addr = i2c,
 			.flags = I2C_M_RD,
-			.len = sizeof(buf),
+			.len = len,
 			.buf = buf,
 		}
 	};
-- 
1.8.3.2

