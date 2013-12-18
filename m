Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373Ab3LRV3J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:29:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36466 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244Ab3LRVNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:13:47 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Hans Petter Selasky <hps@bitfrost.no>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 3.12 072/118] media: tef6862/radio-tea5764: actually assign clamp result
Date: Wed, 18 Dec 2013 13:11:49 -0800
Message-Id: <20131218211221.490809910@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211219.461663463@linuxfoundation.org>
References: <20131218211219.461663463@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Verkuil <hverkuil@xs4all.nl>

commit 9ba6a91f19b8c118d11c549495fa4f7a20505d80 upstream.

When adding frequency clamping to the tef6862 and radio-tea5764 drivers
I forgot to actually *assign* the clamp result to the frequency.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reported-by: Hans Petter Selasky <hps@bitfrost.no>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/radio/radio-tea5764.c |    2 +-
 drivers/media/radio/tef6862.c       |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/radio/radio-tea5764.c
+++ b/drivers/media/radio/radio-tea5764.c
@@ -356,7 +356,7 @@ static int vidioc_s_frequency(struct fil
 		   So we keep it as-is. */
 		return -EINVAL;
 	}
-	clamp(freq, FREQ_MIN * FREQ_MUL, FREQ_MAX * FREQ_MUL);
+	freq = clamp(freq, FREQ_MIN * FREQ_MUL, FREQ_MAX * FREQ_MUL);
 	tea5764_power_up(radio);
 	tea5764_tune(radio, (freq * 125) / 2);
 	return 0;
--- a/drivers/media/radio/tef6862.c
+++ b/drivers/media/radio/tef6862.c
@@ -112,7 +112,7 @@ static int tef6862_s_frequency(struct v4
 	if (f->tuner != 0)
 		return -EINVAL;
 
-	clamp(freq, TEF6862_LO_FREQ, TEF6862_HI_FREQ);
+	freq = clamp(freq, TEF6862_LO_FREQ, TEF6862_HI_FREQ);
 	pll = 1964 + ((freq - TEF6862_LO_FREQ) * 20) / FREQ_MUL;
 	i2cmsg[0] = (MODE_PRESET << MODE_SHIFT) | WM_SUB_PLLM;
 	i2cmsg[1] = (pll >> 8) & 0xff;


