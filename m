Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751510AbaF2FUz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 01:20:55 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:62177 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbaF2FUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 01:20:53 -0400
From: Anil Belur <askb23@gmail.com>
X-Google-Original-From: Anil Belur
To: m.chehab@samsung.com, crope@iki.fi, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Anil Belur <askb23@gmail.com>
Subject: [PATCH 1/1] staging: media: msi3101: sdr-msi3101.c - replace with time_before_eq()
Date: Sun, 29 Jun 2014 10:50:16 +0530
Message-Id: <1404019216-4726-1-git-send-email-askb23@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anil Belur <askb23@gmail.com>

- this fix replaces jiffies interval comparision with safer function to
  avoid any overflow and wrap around ?

Signed-off-by: Anil Belur <askb23@gmail.com>
---
 drivers/staging/media/msi3101/sdr-msi3101.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/msi3101/sdr-msi3101.c b/drivers/staging/media/msi3101/sdr-msi3101.c
index 08d0d09..b828857 100644
--- a/drivers/staging/media/msi3101/sdr-msi3101.c
+++ b/drivers/staging/media/msi3101/sdr-msi3101.c
@@ -180,6 +180,7 @@ static int msi3101_convert_stream_504(struct msi3101_state *s, u8 *dst,
 {
 	int i, i_max, dst_len = 0;
 	u32 sample_num[3];
+	unsigned long expires;
 
 	/* There could be 1-3 1024 bytes URB frames */
 	i_max = src_len / 1024;
@@ -208,7 +209,8 @@ static int msi3101_convert_stream_504(struct msi3101_state *s, u8 *dst,
 	}
 
 	/* calculate samping rate and output it in 10 seconds intervals */
-	if ((s->jiffies_next + msecs_to_jiffies(10000)) <= jiffies) {
+	expires = s->jiffies_next + msecs_to_jiffies(10000);
+	if (time_before_eq(expires, jiffies)) {
 		unsigned long jiffies_now = jiffies;
 		unsigned long msecs = jiffies_to_msecs(jiffies_now) - jiffies_to_msecs(s->jiffies_next);
 		unsigned int samples = sample_num[i_max - 1] - s->sample;
@@ -332,6 +334,7 @@ static int msi3101_convert_stream_384(struct msi3101_state *s, u8 *dst,
 {
 	int i, i_max, dst_len = 0;
 	u32 sample_num[3];
+	unsigned long expires;
 
 	/* There could be 1-3 1024 bytes URB frames */
 	i_max = src_len / 1024;
@@ -360,7 +363,8 @@ static int msi3101_convert_stream_384(struct msi3101_state *s, u8 *dst,
 	}
 
 	/* calculate samping rate and output it in 10 seconds intervals */
-	if ((s->jiffies_next + msecs_to_jiffies(10000)) <= jiffies) {
+	expires = s->jiffies_next + msecs_to_jiffies(10000);
+	if (time_before_eq(expires, jiffies)) {
 		unsigned long jiffies_now = jiffies;
 		unsigned long msecs = jiffies_to_msecs(jiffies_now) - jiffies_to_msecs(s->jiffies_next);
 		unsigned int samples = sample_num[i_max - 1] - s->sample;
@@ -397,6 +401,7 @@ static int msi3101_convert_stream_336(struct msi3101_state *s, u8 *dst,
 {
 	int i, i_max, dst_len = 0;
 	u32 sample_num[3];
+	unsigned long expires;
 
 	/* There could be 1-3 1024 bytes URB frames */
 	i_max = src_len / 1024;
@@ -425,7 +430,8 @@ static int msi3101_convert_stream_336(struct msi3101_state *s, u8 *dst,
 	}
 
 	/* calculate samping rate and output it in 10 seconds intervals */
-	if ((s->jiffies_next + msecs_to_jiffies(10000)) <= jiffies) {
+	expires = s->jiffies_next + msecs_to_jiffies(10000);
+	if (time_before_eq(expires, jiffies)) {
 		unsigned long jiffies_now = jiffies;
 		unsigned long msecs = jiffies_to_msecs(jiffies_now) - jiffies_to_msecs(s->jiffies_next);
 		unsigned int samples = sample_num[i_max - 1] - s->sample;
@@ -460,6 +466,7 @@ static int msi3101_convert_stream_252(struct msi3101_state *s, u8 *dst,
 {
 	int i, i_max, dst_len = 0;
 	u32 sample_num[3];
+	unsigned long expires;
 
 	/* There could be 1-3 1024 bytes URB frames */
 	i_max = src_len / 1024;
@@ -488,7 +495,8 @@ static int msi3101_convert_stream_252(struct msi3101_state *s, u8 *dst,
 	}
 
 	/* calculate samping rate and output it in 10 seconds intervals */
-	if ((s->jiffies_next + msecs_to_jiffies(10000)) <= jiffies) {
+	expires = s->jiffies_next + msecs_to_jiffies(10000);
+	if (time_before_eq(expires, jiffies)) {
 		unsigned long jiffies_now = jiffies;
 		unsigned long msecs = jiffies_to_msecs(jiffies_now) - jiffies_to_msecs(s->jiffies_next);
 		unsigned int samples = sample_num[i_max - 1] - s->sample;
-- 
1.9.1

