Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031AbaLNGty (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 01:49:54 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:56975 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbaLNGtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 01:49:52 -0500
Date: Sun, 14 Dec 2014 08:49:47 +0200
From: Asaf Vertz <asaf.vertz@tandemg.com>
To: m.chehab@samsung.com
Cc: asaf.vertz@tandemg.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] media: stb0899_drv: use time_after()
Message-ID: <20141214064947.GA26820@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To be future-proof and for better readability the time comparisons are
modified to use time_after() instead of plain, error-prone math.

Signed-off-by: Asaf Vertz <asaf.vertz@tandemg.com>
---
 drivers/media/dvb-frontends/stb0899_drv.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/stb0899_drv.c b/drivers/media/dvb-frontends/stb0899_drv.c
index 07cd5ea..cb024af 100644
--- a/drivers/media/dvb-frontends/stb0899_drv.c
+++ b/drivers/media/dvb-frontends/stb0899_drv.c
@@ -20,6 +20,7 @@
 */
 
 #include <linux/init.h>
+#include <linux/jiffies.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/slab.h>
@@ -691,7 +692,7 @@ static int stb0899_wait_diseqc_fifo_empty(struct stb0899_state *state, int timeo
 		reg = stb0899_read_reg(state, STB0899_DISSTATUS);
 		if (!STB0899_GETFIELD(FIFOFULL, reg))
 			break;
-		if ((jiffies - start) > timeout) {
+		if (time_after(jiffies, start + timeout)) {
 			dprintk(state->verbose, FE_ERROR, 1, "timed out !!");
 			return -ETIMEDOUT;
 		}
@@ -733,7 +734,7 @@ static int stb0899_wait_diseqc_rxidle(struct stb0899_state *state, int timeout)
 
 	while (!STB0899_GETFIELD(RXEND, reg)) {
 		reg = stb0899_read_reg(state, STB0899_DISRX_ST0);
-		if (jiffies - start > timeout) {
+		if (time_after(jiffies, start + timeout)) {
 			dprintk(state->verbose, FE_ERROR, 1, "timed out!!");
 			return -ETIMEDOUT;
 		}
@@ -782,7 +783,7 @@ static int stb0899_wait_diseqc_txidle(struct stb0899_state *state, int timeout)
 
 	while (!STB0899_GETFIELD(TXIDLE, reg)) {
 		reg = stb0899_read_reg(state, STB0899_DISSTATUS);
-		if (jiffies - start > timeout) {
+		if (time_after(jiffies, start + timeout)) {
 			dprintk(state->verbose, FE_ERROR, 1, "timed out!!");
 			return -ETIMEDOUT;
 		}
-- 
1.7.0.4

