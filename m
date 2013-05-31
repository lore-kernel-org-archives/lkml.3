Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068Ab3EaAsE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 20:48:04 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:30159 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578Ab3EaAr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 20:47:58 -0400
X-AuditID: cbfee68e-b7f276d000002279-fa-51a7f33caa4a
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'Jonghwan Choi'" <jhbird.choi@samsung.com>, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org,
        "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        "'Vinod Koul'" <vinod.koul@intel.com>, cpgs@samsung.com
References: 
In-reply-to: 
Subject: [PATCH 3.9-stable]  ASoC: wm8994: use the correct pointer to get the
 control
Date: Fri, 31 May 2013 09:47:56 +0900
Message-id: <000f01ce5d98$7dd38770$797a9650$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4vhL6OHdYi6A9aR4m9yzeDEXJPogAflJswAu8tBWABA4TFIAFsOElwAIhNXzAAnKxWYACLd58QADUgf7AB+cfNsAAATvIgAMqg8eAAkzGCMAAA5gYwAMf3LxA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t8zA12bz8sDDQ5+tLH4N/sUm8XLQ5oW
	S5q5LS7vmsNmsWDjI0aLl337WRzYPBbvecnk8XLibzaPvi2rGD0+b5ILYInisklJzcksSy3S
	t0vgyti1biFrwS/2inNHG1kaGO+ydTFyckgImEgsPPyCHcIWk7hwbz1QnItDSGAZo8Tl+5uZ
	YIpapp5khUhMZ5Q4u2kOI4Tzl1Fi47m9YO1sAroSx9ZvYQWxRQS8JU5N+cUMYjMLtDNKnH4F
	ZHMANXBLrG4OAglzCvBIrPvTCVYiLBAusWzRcrCLWARUJdZ3fgZbzCtgJ9G97S4rhC0o8WPy
	PRaIkVoS63ceZ4Kw5SU2r3kLNl5CQF3i0V9dkNNEBHoYJZ71XYWqF5HY9+Id2M0SAtfYJe5N
	P8wIsUxA4tvkQywQzbISmw4wQzwsKXFwxQ2WCYwSs5CsnoVk9Swkq2chWbGAkWUVo2hqQXJB
	cVJ6kZFecWJucWleul5yfu4mRkic9u1gvHnA+hBjMtD6icxSosn5wDjPK4k3NDYzsjA1MTU2
	Mrc0I01YSZxXrcU6UEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVANjRbRR32SB52WNbhEXhSel
	cjzZf27mhkf756htLPQyOndHovHhgykbr/e3+ytLXCwR1Ulo2XR03oyefWLWe0WepS1s+HFY
	8PFq/4MBBnFTJPtT34pm/X9z18nafP6MK4f/CJr+bxZKqhJpu/yz6eCSimB11QZ56W+L6+fO
	2BAc/4o1KvzS4Rs5SizFGYmGWsxFxYkAQY/Rg+kCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsVy+t9jQV2bz8sDDV6ft7D4N/sUm8XLQ5oW
	S5q5LS7vmsNmsWDjI0aLl337WRzYPBbvecnk8XLibzaPvi2rGD0+b5ILYIlqYLTJSE1MSS1S
	SM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqtpFCWmFMKFApILC5W
	0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsY8zYtW4ha8Ev9opzRxtZGhjvsnUxcnJICJhItEw9
	yQphi0lcuLceKM7FISQwnVHi7KY5jBDOX0aJjef2soNUsQnoShxbvwWsQ0TAW+LUlF/MIDaz
	QDujxOlXQDYHUAO3xOrmIJAwpwCPxLo/nWAlwgLhEssWLQdbzCKgKrG+8zMTiM0rYCfRve0u
	K4QtKPFj8j0WiJFaEut3HmeCsOUlNq95CzZeQkBd4tFfXZDTRAR6GCWe9V2FqheR2PfiHeME
	RqFZSEbNQjJqFpJRs5C0LGBkWcUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRnASeSe9gXNVg
	cYhRgINRiYf3YMryQCHWxLLiytxDjBIczEoivJ3ngEK8KYmVValF+fFFpTmpxYcYk4E+ncgs
	JZqcD0xQeSXxhsYmZkaWRmYWRibm5qQJK4nzHmy1DhQSSE8sSc1OTS1ILYLZwsTBKdXAyPqC
	85GRulnZp5vb+h7OvLtrMdNG37MHdZdd152yee6SbXein03+tnZh8tc9RVfCwlzZ9yY5RgWx
	OF+TcyzfciC6/YaRf9aCisdym+d27L9k9dtk2l+Vo2eqq6qZxK9FpzT2fdTftb3XtcpS3r0+
	YlJhmfi61jfqZtkrdwXd3LTgUpGy1mWd6UosxRmJhlrMRcWJALZ3a/NGAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch looks like it should be in the 3.9-stable tree, should we apply
it?

------------------

From: "Vinod Koul <vinod.koul@intel.com>"

commit d3134e211e8db7fa833c40b5879fc022693e16c2 upstream

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 sound/soc/codecs/wm8994.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm8994.c b/sound/soc/codecs/wm8994.c
index 3b269fa..8b769ba 100644
--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -1031,7 +1031,7 @@ static int aif1clk_ev(struct snd_soc_dapm_widget *w,
 {
 	struct snd_soc_codec *codec = w->codec;
 	struct wm8994_priv *wm8994 = snd_soc_codec_get_drvdata(codec);
-	struct wm8994 *control = codec->control_data;
+	struct wm8994 *control = wm8994->wm8994;
 	int mask = WM8994_AIF1DAC1L_ENA | WM8994_AIF1DAC1R_ENA;
 	int i;
 	int dac;
-- 
1.7.9.5

