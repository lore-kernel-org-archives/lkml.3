Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933487AbaDBWsG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 18:48:06 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:57335 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932414AbaDBWsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 18:48:03 -0400
From: Rocco Folino <lordzen87@gmail.com>
To: gregkh@linuxfoundation.org, insop.song@gainspeed.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Rocco Folino <lordzen87@gmail.com>
Subject: [PATCH] staging: gs_fpgaboot: Fixed code style issues
Date: Thu,  3 Apr 2014 00:47:46 +0200
Message-Id: <8af2f115877c14a09c779dfee93c7d45a85b2813.1396478434.git.lordzen87@gmail.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed missing a blank line after declarations warning

Signed-off-by: Rocco Folino <lordzen87@gmail.com>
---
 drivers/staging/gs_fpgaboot/gs_fpgaboot.c | 2 +-
 drivers/staging/gs_fpgaboot/io.c          | 6 ++++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/gs_fpgaboot/gs_fpgaboot.c b/drivers/staging/gs_fpgaboot/gs_fpgaboot.c
index 89bc84d..8e6f111 100644
--- a/drivers/staging/gs_fpgaboot/gs_fpgaboot.c
+++ b/drivers/staging/gs_fpgaboot/gs_fpgaboot.c
@@ -214,8 +214,8 @@ static int gs_download_image(struct fpgaimage *fimage, enum wbus bus_bytes)
 {
 	char *bitdata;
 	int size, i, cnt;
-	cnt = 0;
 
+	cnt = 0;
 	bitdata = (char *)fimage->fpgadata;
 	size = fimage->lendata;
 
diff --git a/drivers/staging/gs_fpgaboot/io.c b/drivers/staging/gs_fpgaboot/io.c
index b7be8e3..23c12f4 100644
--- a/drivers/staging/gs_fpgaboot/io.c
+++ b/drivers/staging/gs_fpgaboot/io.c
@@ -44,6 +44,7 @@ static inline void xl_cclk_b(int32_t i);
 void xl_shift_cclk(int count)
 {
 	int i;
+
 	for (i = 0; i < count; i++) {
 		xl_cclk_b(1);
 		xl_cclk_b(0);
@@ -85,6 +86,7 @@ void xl_shift_bytes_out(enum wbus bus_byte, unsigned char *pdata)
 static inline unsigned char bitswap(unsigned char s)
 {
 	unsigned char d;
+
 	d = (((s&0x80)>>7) | ((s&0x40)>>5) | ((s&0x20)>>3) | ((s&0x10)>>1) |
 		((s&0x08)<<1) | ((s&0x04)<<3) | ((s&0x02)<<5) | ((s&0x01)<<7));
 	return d;
@@ -135,6 +137,7 @@ static inline void mpc85xx_gpio_set_high(int32_t port, uint32_t gpios)
 static inline void gpio_set_value(int32_t port, uint32_t gpio, uint32_t value)
 {
 	int32_t g;
+
 	g = 31 - gpio;
 	if (value)
 		mpc85xx_gpio_set_high(port, 1U << g);
@@ -145,6 +148,7 @@ static inline void gpio_set_value(int32_t port, uint32_t gpio, uint32_t value)
 static inline int gpio_get_value(int32_t port, uint32_t gpio)
 {
 	int32_t g;
+
 	g = 31 - gpio;
 	return !!mpc85xx_gpio_get(port, 1U << g);
 }
@@ -184,6 +188,7 @@ int xl_get_done_b(void)
 static inline uint32_t bit_remap_byte0(uint32_t s)
 {
 	uint32_t d;
+
 	d = (((s&0x80)>>7) | ((s&0x40)>>5) | ((s&0x20)>>3) | ((s&0x10)>>1) |
 		((s&0x08)<<1) | ((s&0x04)<<3) | ((s&0x02)<<6) | ((s&0x01)<<9));
 	return d;
@@ -195,6 +200,7 @@ static inline uint32_t bit_remap_byte0(uint32_t s)
 static inline void byte0_out(unsigned char data)
 {
 	uint32_t swap32;
+
 	swap32 =  bit_remap_byte0((uint32_t) data) << 8;
 
 	mpc85xx_gpio_set(0, 0x0002BF00, (uint32_t) swap32);
-- 
1.9.0

