Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281AbaABRIx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 12:08:53 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40372 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988AbaABRIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 12:08:50 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Frederik Himpe <fhimpe@telenet.be>,
        Luis Henriques <luis.henriques@canonical.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 56/91] [media] cxd2820r_core: fix sparse warnings
Date: Thu,  2 Jan 2014 09:04:31 -0800
Message-Id: <1388682306-30859-57-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388682306-30859-1-git-send-email-kamal@canonical.com>
References: <1388682306-30859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.15 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/media/dvb-frontends/cxd2820r_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/cxd2820r_core.c b/drivers/media/dvb-frontends/cxd2820r_core.c
index 9b658c1..52323de 100644
--- a/drivers/media/dvb-frontends/cxd2820r_core.c
+++ b/drivers/media/dvb-frontends/cxd2820r_core.c
@@ -31,7 +31,7 @@ static int cxd2820r_wr_regs_i2c(struct cxd2820r_priv *priv, u8 i2c, u8 reg,
 		{
 			.addr = i2c,
 			.flags = 0,
-			.len = sizeof(buf),
+			.len = len + 1,
 			.buf = buf,
 		}
 	};
@@ -65,7 +65,7 @@ static int cxd2820r_rd_regs_i2c(struct cxd2820r_priv *priv, u8 i2c, u8 reg,
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

