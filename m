Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742Ab3LRVyu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:54:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36137 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753377Ab3LRVMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:12:41 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>, Antti Palosaari <crope@iki.fi>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Frederik Himpe <fhimpe@telenet.be>
Subject: [PATCH 3.10 66/78] [media] cxd2820r_core: fix sparse warnings
Date: Wed, 18 Dec 2013 13:11:34 -0800
Message-Id: <20131218211113.765766467@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211111.903835960@linuxfoundation.org>
References: <20131218211111.903835960@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/dvb-frontends/cxd2820r_core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/dvb-frontends/cxd2820r_core.c
+++ b/drivers/media/dvb-frontends/cxd2820r_core.c
@@ -34,7 +34,7 @@ static int cxd2820r_wr_regs_i2c(struct c
 		{
 			.addr = i2c,
 			.flags = 0,
-			.len = sizeof(buf),
+			.len = len + 1,
 			.buf = buf,
 		}
 	};
@@ -75,7 +75,7 @@ static int cxd2820r_rd_regs_i2c(struct c
 		}, {
 			.addr = i2c,
 			.flags = I2C_M_RD,
-			.len = sizeof(buf),
+			.len = len,
 			.buf = buf,
 		}
 	};


