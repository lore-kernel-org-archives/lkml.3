Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757912Ab3HMG4e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 02:56:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60476 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756230Ab3HMGdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 02:33:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Shawn Guo <shawn.guo@linaro.org>, Lucas Stach <l.stach@pengutronix.de>,
        Marek Vasut <marex@denx.de>, Wolfram Sang <wsa@the-dreams.de>
Subject: [ 18/60] i2c: i2c-mxs: Use DMA mode even for small transfers
Date: Mon, 12 Aug 2013 23:33:45 -0700
Message-Id: <20130813063334.693669695@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130813063331.950321483@linuxfoundation.org>
References: <20130813063331.950321483@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <fabio.estevam@freescale.com>

commit d6e102f498cbcc8dd2e36721a01213f036397112 upstream.

Recently we have been seing some reports about PIO mode not working properly.

- http://www.spinics.net/lists/linux-i2c/msg11985.html
- http://marc.info/?l=linux-i2c&m=137235593101385&w=2
- https://lkml.org/lkml/2013/6/24/430

Let's use DMA mode even for small transfers.

Without this patch, i2c reads the incorrect sgtl5000 version on a mx28evk when
touchscreen is enabled:

[    5.856270] sgtl5000 0-000a: Device with ID register 0 is not a sgtl5000
[    9.877307] sgtl5000 0-000a: ASoC: failed to probe CODEC -19
[    9.883528] mxs-sgtl5000 sound.12: ASoC: failed to instantiate card -19
[    9.892955] mxs-sgtl5000 sound.12: snd_soc_register_card failed (-19)

[wsa: we have a proper solution for -next, so this non intrusive
solution is OK for now]

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Acked-by: Shawn Guo <shawn.guo@linaro.org>
Acked-by: Lucas Stach <l.stach@pengutronix.de>
Acked-by: Marek Vasut <marex@denx.de>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/i2c-mxs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-mxs.c
+++ b/drivers/i2c/busses/i2c-mxs.c
@@ -494,7 +494,7 @@ static int mxs_i2c_xfer_msg(struct i2c_a
 	 * based on this empirical measurement and a lot of previous frobbing.
 	 */
 	i2c->cmd_err = 0;
-	if (msg->len < 8) {
+	if (0) {	/* disable PIO mode until a proper fix is made */
 		ret = mxs_i2c_pio_setup_xfer(adap, msg, flags);
 		if (ret)
 			mxs_i2c_reset(i2c);


