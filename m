Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530Ab3LSL6n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 06:58:43 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45077 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755449Ab3LSL6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:58:35 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 136/208] [media] tef6862/radio-tea5764: actually assign clamp result
Date: Thu, 19 Dec 2013 11:53:54 +0000
Message-Id: <1387454106-19326-137-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Verkuil <hverkuil@xs4all.nl>

commit 9ba6a91f19b8c118d11c549495fa4f7a20505d80 upstream.

When adding frequency clamping to the tef6862 and radio-tea5764 drivers
I forgot to actually *assign* the clamp result to the frequency.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reported-by: Hans Petter Selasky <hps@bitfrost.no>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/media/radio/radio-tea5764.c | 2 +-
 drivers/media/radio/tef6862.c       | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/radio/radio-tea5764.c b/drivers/media/radio/radio-tea5764.c
index 036e2f5..3ed1f56 100644
--- a/drivers/media/radio/radio-tea5764.c
+++ b/drivers/media/radio/radio-tea5764.c
@@ -356,7 +356,7 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 		   So we keep it as-is. */
 		return -EINVAL;
 	}
-	clamp(freq, FREQ_MIN * FREQ_MUL, FREQ_MAX * FREQ_MUL);
+	freq = clamp(freq, FREQ_MIN * FREQ_MUL, FREQ_MAX * FREQ_MUL);
 	tea5764_power_up(radio);
 	tea5764_tune(radio, (freq * 125) / 2);
 	return 0;
diff --git a/drivers/media/radio/tef6862.c b/drivers/media/radio/tef6862.c
index 06ac692..f4bb456 100644
--- a/drivers/media/radio/tef6862.c
+++ b/drivers/media/radio/tef6862.c
@@ -112,7 +112,7 @@ static int tef6862_s_frequency(struct v4l2_subdev *sd, const struct v4l2_frequen
 	if (f->tuner != 0)
 		return -EINVAL;
 
-	clamp(freq, TEF6862_LO_FREQ, TEF6862_HI_FREQ);
+	freq = clamp(freq, TEF6862_LO_FREQ, TEF6862_HI_FREQ);
 	pll = 1964 + ((freq - TEF6862_LO_FREQ) * 20) / FREQ_MUL;
 	i2cmsg[0] = (MODE_PRESET << MODE_SHIFT) | WM_SUB_PLLM;
 	i2cmsg[1] = (pll >> 8) & 0xff;
-- 
1.8.3.2

