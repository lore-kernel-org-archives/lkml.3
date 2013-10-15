Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751756Ab3JOFKt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:10:49 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:45671 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab3JOFKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:10:46 -0400
X-AuditID: cbfee68e-b7f486d0000040b6-cd-525cce541b24
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, hs@denx.de
Cc: khali@linux-fr.org, ben-linux@fluff.org, grant.likely@secretlab.ca,
        sjg@chromium.org, naveenkrishna.ch@gmail.com, d.mueller@elsoft.ch,
        trini@ti.com, mk7.kang@samsung.com, cpgs@samsung.com
Subject: [PATCH 1/3 v3] exynos: i2c: Fix i2c driver to handle NACKs properly
Date: Tue, 15 Oct 2013 10:42:51 +0530
Message-id: <1381813971-16006-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1380799354-14460-1-git-send-email-ch.naveen@samsung.com>
References: <1380799354-14460-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDIsWRmVeSWpSXmKPExsWyRsSkSjfkXEyQwelGVYtJ6w4wWbw8pGmx
	4HAzs8WrMxvZLHbcuc9s0fg30qLj7xdGi8u75rBZzDi/j8mi40gLo8Wibf+ZLb5t2cZoMXnx
	fGYHXo/ZDRdZPObNOsHi0bT1EbPH31UvmD12zrrL7nGl4SSbR9+WVYweP1/qeBy/sZ3J4/Mm
	uQCuKC6blNSczLLUIn27BK6MRc+PMRZ8cqx48r6VvYHxpGEXIyeHhICJxKmj15kgbDGJC/fW
	s3UxcnEICSxllLj3cyYLTNHFv03sEInpjBK/3n+Equphkrhxfx4jSBWbgJnEwUWr2UFsEYEc
	iVenV7GCFDELHGaUeN31jA0kISzgI3Hn0RlmEJtFQFVizbT9YDavgKvEpAf/2CDWKUp0P5sA
	ZnMKuEm8vr+fFcQWAqpZ/ekDI8hQCYGX7BLH++6yQgwSkPg2+RDQrRxACVmJTQeYIeZIShxc
	cYNlAqPwAkaGVYyiqQXJBcVJ6UVGesWJucWleel6yfm5mxiBMXX637O+HYw3D1gfYkwGGjeR
	WUo0OR8Yk3kl8YbGZkYWpiamxkbmlmakCSuJ86q1WAcKCaQnlqRmp6YWpBbFF5XmpBYfYmTi
	4JRqYFxpvdA1gEG97NcrtWm3bmkraQVePCzow3nSXKzh8+3csGlRLRU/D7cwc8V8VM23+VWQ
	emx5ttDR9UIcP6ef2/xR2Nm1KmLPs/qzCecYGaOT1p950txcsqD6zm5OBdE/UzYJ7T2bH/7g
	3feta7e+zsnfO7ebvYDr2suKF1MuHDw/dV1KvPnlWe5KLMUZiYZazEXFiQB5yROZvwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkleLIzCtJLcpLzFFi42I5/e+xoG7IuZgggw1vJSwmrTvAZPHykKbF
	gsPNzBavzmxks9hx5z6zRePfSIuOv18YLS7vmsNmMeP8PiaLjiMtjBaLtv1ntvi2ZRujxeTF
	85kdeD1mN1xk8Zg36wSLR9PWR8wef1e9YPbYOesuu8eVhpNsHn1bVjF6/Hyp43H8xnYmj8+b
	5AK4ohoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOA
	bldSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYwZix6foyx4JNjxZP3rewN
	jCcNuxg5OSQETCQu/m1ih7DFJC7cW8/WxcjFISQwnVHi1/uPUE4Pk8SN+/MYQarYBMwkDi5a
	DdYhIpAj8er0KlaQImaBw4wSr7uesYEkhAV8JO48OsMMYrMIqEqsmbYfzOYVcJWY9OAfG8Q6
	RYnuZxPAbE4BN4nX9/ezgthCQDWrP31gnMDIu4CRYRWjaGpBckFxUnquoV5xYm5xaV66XnJ+
	7iZGcMQ+k9rBuLLB4hCjAAejEg/vD96YICHWxLLiytxDjBIczEoivDnVQCHelMTKqtSi/Pii
	0pzU4kOMyUBXTWSWEk3OByaTvJJ4Q2MTc1NjU0sTCxMzS9KElcR5D7RaBwoJpCeWpGanphak
	FsFsYeLglGpg3OvYc08sZ+NevpI30jnaPLo8f5MFduVuOBFpz88+sfna9A/bpzjmXLvc6MTL
	+eFRLsd7l5A9xUYnva1z8jcHKAZKGN1L50v89CVqqfW0jmPF31+bbVj6LlRyU2zm25fikUaW
	O27aKnBa9c5h0pu6/pa+4iRtiSkLGCMTXj1Y9HHTxqNMdl/vKrEUZyQaajEXFScCAHPDKUMc	AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Exynos5 i2c driver does not handle NACKs properly. This change:

- fixes the NACK processing problem (do not continue transaction if
  address cycle was NACKed)

- eliminates a fair amount of duplicate code

Signed-off-by: Vadim Bendebury <vbendeb@chromium.org>
Reviewed-by: Simon Glass <sjg@google.com>
Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
---
Changes since v1:
Fixed complilation warning in function i2c_init()

Changes since v2:
None

 drivers/i2c/s3c24x0_i2c.c |  214 +++++++++++++++++++--------------------------
 1 file changed, 90 insertions(+), 124 deletions(-)

diff --git a/drivers/i2c/s3c24x0_i2c.c b/drivers/i2c/s3c24x0_i2c.c
index cd09c78..c65360d 100644
--- a/drivers/i2c/s3c24x0_i2c.c
+++ b/drivers/i2c/s3c24x0_i2c.c
@@ -43,7 +43,7 @@
 #define I2C_START_STOP	0x20	/* START / STOP */
 #define I2C_TXRX_ENA	0x10	/* I2C Tx/Rx enable */
 
-#define I2C_TIMEOUT 1		/* 1 second */
+#define I2C_TIMEOUT_MS 1000		/* 1 second */
 
 
 /*
@@ -84,22 +84,26 @@ static void SetI2CSCL(int x)
 }
 #endif
 
+/*
+ * Wait til the byte transfer is completed.
+ *
+ * @param i2c- pointer to the appropriate i2c register bank.
+ * @return I2C_OK, if transmission was ACKED
+ *         I2C_NACK, if transmission was NACKED
+ *         I2C_NOK_TIMEOUT, if transaction did not complete in I2C_TIMEOUT_MS
+ */
+
 static int WaitForXfer(struct s3c24x0_i2c *i2c)
 {
-	int i;
+	ulong start_time = get_timer(0);
 
-	i = I2C_TIMEOUT * 10000;
-	while (!(readl(&i2c->iiccon) & I2CCON_IRPND) && (i > 0)) {
-		udelay(100);
-		i--;
-	}
+	do {
+		if (readl(&i2c->iiccon) & I2CCON_IRPND)
+			return (readl(&i2c->iicstat) & I2CSTAT_NACK) ?
+				I2C_NACK : I2C_OK;
+	} while (get_timer(start_time) < I2C_TIMEOUT_MS);
 
-	return (readl(&i2c->iiccon) & I2CCON_IRPND) ? I2C_OK : I2C_NOK_TOUT;
-}
-
-static int IsACK(struct s3c24x0_i2c *i2c)
-{
-	return !(readl(&i2c->iicstat) & I2CSTAT_NACK);
+	return I2C_NOK_TOUT;
 }
 
 static void ReadWriteByte(struct s3c24x0_i2c *i2c)
@@ -180,21 +184,27 @@ unsigned int i2c_get_bus_num(void)
 
 void i2c_init(int speed, int slaveadd)
 {
+	int i;
 	struct s3c24x0_i2c *i2c;
 #if !(defined CONFIG_EXYNOS4 || defined CONFIG_EXYNOS5)
 	struct s3c24x0_gpio *gpio = s3c24x0_get_base_gpio();
 #endif
-	int i;
+	ulong start_time = get_timer(0);
 
 	/* By default i2c channel 0 is the current bus */
 	g_current_bus = 0;
 	i2c = get_base_i2c();
 
-	/* wait for some time to give previous transfer a chance to finish */
-	i = I2C_TIMEOUT * 1000;
-	while ((readl(&i2c->iicstat) & I2CSTAT_BSY) && (i > 0)) {
-		udelay(1000);
-		i--;
+	/*
+	 * In case the previous transfer is still going, wait to give it a
+	 * chance to finish.
+	 */
+	while (readl(&i2c->iicstat) & I2CSTAT_BSY) {
+		if (get_timer(start_time) > I2C_TIMEOUT_MS) {
+			printf("%s: I2C bus busy for %p\n", __func__,
+			       &i2c->iicstat);
+			return;
+		}
 	}
 
 #if !(defined CONFIG_EXYNOS4 || defined CONFIG_EXYNOS5)
@@ -260,7 +270,8 @@ static int i2c_transfer(struct s3c24x0_i2c *i2c,
 			unsigned char data[],
 			unsigned short data_len)
 {
-	int i, result;
+	int i = 0, result;
+	ulong start_time = get_timer(0);
 
 	if (data == 0 || data_len == 0) {
 		/*Don't support data transfer of no length or to address 0 */
@@ -268,128 +279,78 @@ static int i2c_transfer(struct s3c24x0_i2c *i2c,
 		return I2C_NOK;
 	}
 
-	/* Check I2C bus idle */
-	i = I2C_TIMEOUT * 1000;
-	while ((readl(&i2c->iicstat) & I2CSTAT_BSY) && (i > 0)) {
-		udelay(1000);
-		i--;
+	while (readl(&i2c->iicstat) & I2CSTAT_BSY) {
+		if (get_timer(start_time) > I2C_TIMEOUT_MS)
+			return I2C_NOK_TOUT;
 	}
 
-	if (readl(&i2c->iicstat) & I2CSTAT_BSY)
-		return I2C_NOK_TOUT;
-
 	writel(readl(&i2c->iiccon) | I2CCON_ACKGEN, &i2c->iiccon);
-	result = I2C_OK;
 
-	switch (cmd_type) {
-	case I2C_WRITE:
-		if (addr && addr_len) {
-			writel(chip, &i2c->iicds);
-			/* send START */
-			writel(I2C_MODE_MT | I2C_TXRX_ENA | I2C_START_STOP,
-			       &i2c->iicstat);
-			i = 0;
-			while ((i < addr_len) && (result == I2C_OK)) {
-				result = WaitForXfer(i2c);
-				writel(addr[i], &i2c->iicds);
-				ReadWriteByte(i2c);
-				i++;
-			}
-			i = 0;
-			while ((i < data_len) && (result == I2C_OK)) {
-				result = WaitForXfer(i2c);
-				writel(data[i], &i2c->iicds);
-				ReadWriteByte(i2c);
-				i++;
-			}
-		} else {
-			writel(chip, &i2c->iicds);
-			/* send START */
-			writel(I2C_MODE_MT | I2C_TXRX_ENA | I2C_START_STOP,
-			       &i2c->iicstat);
-			i = 0;
-			while ((i < data_len) && (result == I2C_OK)) {
-				result = WaitForXfer(i2c);
-				writel(data[i], &i2c->iicds);
-				ReadWriteByte(i2c);
-				i++;
-			}
+	/* Get the slave chip address going */
+	writel(chip, &i2c->iicds);
+	if ((cmd_type == I2C_WRITE) || (addr && addr_len))
+		writel(I2C_MODE_MT | I2C_TXRX_ENA | I2C_START_STOP,
+		       &i2c->iicstat);
+	else
+		writel(I2C_MODE_MR | I2C_TXRX_ENA | I2C_START_STOP,
+		       &i2c->iicstat);
+
+	/* Wait for chip address to transmit. */
+	result = WaitForXfer(i2c);
+	if (result != I2C_OK)
+		goto bailout;
+
+	/* If register address needs to be transmitted - do it now. */
+	if (addr && addr_len) {
+		while ((i < addr_len) && (result == I2C_OK)) {
+			writel(addr[i++], &i2c->iicds);
+			ReadWriteByte(i2c);
+			result = WaitForXfer(i2c);
 		}
+		i = 0;
+		if (result != I2C_OK)
+			goto bailout;
+	}
 
-		if (result == I2C_OK)
+	switch (cmd_type) {
+	case I2C_WRITE:
+		while ((i < data_len) && (result == I2C_OK)) {
+			writel(data[i++], &i2c->iicds);
+			ReadWriteByte(i2c);
 			result = WaitForXfer(i2c);
-
-		/* send STOP */
-		writel(I2C_MODE_MT | I2C_TXRX_ENA, &i2c->iicstat);
-		ReadWriteByte(i2c);
+		}
 		break;
 
 	case I2C_READ:
 		if (addr && addr_len) {
+			/*
+			 * Register address has been sent, now send slave chip
+			 * address again to start the actual read transaction.
+			 */
 			writel(chip, &i2c->iicds);
-			/* send START */
-			writel(I2C_MODE_MT | I2C_TXRX_ENA | I2C_START_STOP,
-				&i2c->iicstat);
-			result = WaitForXfer(i2c);
-			if (IsACK(i2c)) {
-				i = 0;
-				while ((i < addr_len) && (result == I2C_OK)) {
-					writel(addr[i], &i2c->iicds);
-					ReadWriteByte(i2c);
-					result = WaitForXfer(i2c);
-					i++;
-				}
-
-				writel(chip, &i2c->iicds);
-				/* resend START */
-				writel(I2C_MODE_MR | I2C_TXRX_ENA |
-				       I2C_START_STOP, &i2c->iicstat);
-			ReadWriteByte(i2c);
-			result = WaitForXfer(i2c);
-				i = 0;
-				while ((i < data_len) && (result == I2C_OK)) {
-					/* disable ACK for final READ */
-					if (i == data_len - 1)
-						writel(readl(&i2c->iiccon)
-							& ~I2CCON_ACKGEN,
-							&i2c->iiccon);
-				ReadWriteByte(i2c);
-				result = WaitForXfer(i2c);
-					data[i] = readl(&i2c->iicds);
-					i++;
-				}
-			} else {
-				result = I2C_NACK;
-			}
-
-		} else {
-			writel(chip, &i2c->iicds);
-			/* send START */
+
+			/* Generate a re-START. */
 			writel(I2C_MODE_MR | I2C_TXRX_ENA | I2C_START_STOP,
 				&i2c->iicstat);
+			ReadWriteByte(i2c);
 			result = WaitForXfer(i2c);
 
-			if (IsACK(i2c)) {
-				i = 0;
-				while ((i < data_len) && (result == I2C_OK)) {
-					/* disable ACK for final READ */
-					if (i == data_len - 1)
-						writel(readl(&i2c->iiccon) &
-							~I2CCON_ACKGEN,
-							&i2c->iiccon);
-					ReadWriteByte(i2c);
-					result = WaitForXfer(i2c);
-					data[i] = readl(&i2c->iicds);
-					i++;
-				}
-			} else {
-				result = I2C_NACK;
-			}
+			if (result != I2C_OK)
+				goto bailout;
 		}
 
-		/* send STOP */
-		writel(I2C_MODE_MR | I2C_TXRX_ENA, &i2c->iicstat);
-		ReadWriteByte(i2c);
+		while ((i < data_len) && (result == I2C_OK)) {
+			/* disable ACK for final READ */
+			if (i == data_len - 1)
+				writel(readl(&i2c->iiccon)
+				       & ~I2CCON_ACKGEN,
+				       &i2c->iiccon);
+			ReadWriteByte(i2c);
+			result = WaitForXfer(i2c);
+			data[i++] = readl(&i2c->iicds);
+		}
+		if (result == I2C_NACK)
+			result = I2C_OK; /* Normal terminated read. */
 		break;
 
 	default:
@@ -398,6 +359,11 @@ static int i2c_transfer(struct s3c24x0_i2c *i2c,
 		break;
 	}
 
+bailout:
+	/* Send STOP. */
+	writel(I2C_MODE_MR | I2C_TXRX_ENA, &i2c->iicstat);
+	ReadWriteByte(i2c);
+
 	return result;
 }
 
-- 
1.7.10.4

