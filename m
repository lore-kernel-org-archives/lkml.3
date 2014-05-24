Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751366AbaEXSsI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 14:48:08 -0400
Received: from mout.gmx.net ([212.227.17.21]:52062 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208AbaEXSsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 14:48:07 -0400
From: =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
To: crope@iki.fi
Cc: m.chehab@samsung.com, gregkh@linuxfoundation.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
Subject: [PATCH] msi3103: Use time_before_eq()
Date: Sat, 24 May 2014 20:47:56 +0200
Message-Id: <1400957276-13222-1-git-send-email-manuel.schoelling@gmx.de>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:GacWvQapIEfR/EiaQglRPVSFFssosk9sPSV3c8q8NRFhoaZOQmm
 TXoYUUOSLy3HKy7jpPxNJEVhKO9ld9N4Hz4v7hw0SnfzDuI4IUk1PY0iOKUrs9L4g0HAcol
 BaibABoCbM3ayf9gRrhS2RZdBUyaP4XM1g8n/ivblJ38c5jHkdh8xWf1V56lD+WDn4XEw+f
 MiP64d390xIOAlk8f5bPw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To be future-proof and for better readability the time comparisons are
modified to use time_before_eq() instead of plain, error-prone math.

Signed-off-by: Manuel Schölling <manuel.schoelling@gmx.de>
---
 drivers/staging/media/msi3101/sdr-msi3101.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/msi3101/sdr-msi3101.c b/drivers/staging/media/msi3101/sdr-msi3101.c
index 65d351f..b52726b 100644
--- a/drivers/staging/media/msi3101/sdr-msi3101.c
+++ b/drivers/staging/media/msi3101/sdr-msi3101.c
@@ -208,7 +208,7 @@ static int msi3101_convert_stream_504(struct msi3101_state *s, u8 *dst,
 	}
 
 	/* calculate samping rate and output it in 10 seconds intervals */
-	if ((s->jiffies_next + msecs_to_jiffies(10000)) <= jiffies) {
+	if (time_before_eq(s->jiffies_next + 10 * HZ, jiffies)) {
 		unsigned long jiffies_now = jiffies;
 		unsigned long msecs = jiffies_to_msecs(jiffies_now) - jiffies_to_msecs(s->jiffies_next);
 		unsigned int samples = sample_num[i_max - 1] - s->sample;
@@ -360,7 +360,7 @@ static int msi3101_convert_stream_384(struct msi3101_state *s, u8 *dst,
 	}
 
 	/* calculate samping rate and output it in 10 seconds intervals */
-	if ((s->jiffies_next + msecs_to_jiffies(10000)) <= jiffies) {
+	if (time_before_eq(s->jiffies_next + 10 * HZ, jiffies)) {
 		unsigned long jiffies_now = jiffies;
 		unsigned long msecs = jiffies_to_msecs(jiffies_now) - jiffies_to_msecs(s->jiffies_next);
 		unsigned int samples = sample_num[i_max - 1] - s->sample;
@@ -425,7 +425,7 @@ static int msi3101_convert_stream_336(struct msi3101_state *s, u8 *dst,
 	}
 
 	/* calculate samping rate and output it in 10 seconds intervals */
-	if ((s->jiffies_next + msecs_to_jiffies(10000)) <= jiffies) {
+	if (time_before_eq(s->jiffies_next + 10 * HZ, jiffies)) {
 		unsigned long jiffies_now = jiffies;
 		unsigned long msecs = jiffies_to_msecs(jiffies_now) - jiffies_to_msecs(s->jiffies_next);
 		unsigned int samples = sample_num[i_max - 1] - s->sample;
@@ -488,7 +488,7 @@ static int msi3101_convert_stream_252(struct msi3101_state *s, u8 *dst,
 	}
 
 	/* calculate samping rate and output it in 10 seconds intervals */
-	if ((s->jiffies_next + msecs_to_jiffies(10000)) <= jiffies) {
+	if (time_before_eq(s->jiffies_next + 10 * HZ, jiffies)) {
 		unsigned long jiffies_now = jiffies;
 		unsigned long msecs = jiffies_to_msecs(jiffies_now) - jiffies_to_msecs(s->jiffies_next);
 		unsigned int samples = sample_num[i_max - 1] - s->sample;
-- 
1.7.10.4

