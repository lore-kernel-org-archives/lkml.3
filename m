Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934130AbaICWXQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 18:23:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46220 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933902AbaICWSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:18:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Addy Ke <addy.ke@rock-chips.com>, Heiko Stuebner <heiko@sntech.de>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH 3.16 050/125] i2c: rk3x: fix interrupt handling issue
Date: Wed,  3 Sep 2014 15:06:47 -0700
Message-Id: <20140903220625.147499867@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220623.649748296@linuxfoundation.org>
References: <20140903220623.649748296@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: addy ke <addy.ke@rock-chips.com>

commit 9c5f7cad3acc69ce623d04d646950183a759949e upstream.

If slave holds scl, I2C_IPD[7] will be set 1 by controller
for debugging. Driver must ignore it.

[    5.752391] rk3x-i2c ff160000.i2c: unexpected irq in WRITE: 0x80
[    5.939027] rk3x-i2c ff160000.i2c: timeout, ipd: 0x80, state: 4

Signed-off-by: Addy Ke <addy.ke@rock-chips.com>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/i2c-rk3x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-rk3x.c
+++ b/drivers/i2c/busses/i2c-rk3x.c
@@ -399,7 +399,7 @@ static irqreturn_t rk3x_i2c_irq(int irqn
 	}
 
 	/* is there anything left to handle? */
-	if (unlikely(ipd == 0))
+	if (unlikely((ipd & REG_INT_ALL) == 0))
 		goto out;
 
 	switch (i2c->state) {


