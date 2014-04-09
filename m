Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758210AbaDIHWc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 03:22:32 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:53047 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbaDIHWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 03:22:31 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-f7-5344f534bf4e
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH] ASoC: core: Fix Sparse incompatible types warning
Date: Wed, 09 Apr 2014 09:21:48 +0200
Message-id: <1397028108-10976-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.8.3.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMJMWRmVeSWpSXmKPExsVy+t/xK7omX12CDSYvFLK4cvEQk8XUh0/Y
	LF6/MLT4dqWDyeLyrjlsFp27+lktXm5+w+TA7rHhcxObx85Zd9k9Nq3qZPPY93YZm0ffllWM
	HptPV3t83iQXwB7FZZOSmpNZllqkb5fAlTH/2h/mgn62ij9zzRoYp7F2MXJwSAiYSKz669DF
	yAlkiklcuLeeDcQWEljKKNF7hreLkQvI7mOS+L9wCwtIgk3AWGLz8iVgRSICxxklPjzzALGZ
	BQwlfr77ww5iCws4SXzqfM8MYrMIqEp0XusHs3kF3CUu/N3GBLFMQWLZl7XMExi5FzAyrGIU
	TS1NLihOSs811CtOzC0uzUvXS87P3cQICZgvOxgXH7M6xCjAwajEw6tg6RIsxJpYVlyZe4hR
	goNZSYT3eTZQiDclsbIqtSg/vqg0J7X4ECMTB6dUA2PqZ37xtil779bJxcx/EPAtU87eKKp8
	z1q3d9ejDt2xsEz2NLv4Kif43XKvPyzSAor6yQt3bt105GbDiktPxb4c/6qtPWvV7jT3X62F
	T7b/NS2yOC405/rnl3t3GMuJKygESbkXZNvma885479WPGQ/j9endpOpc8Qi1A9FF19jNNjP
	9dOyPEOJpTgj0VCLuag4EQDh/t639gEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following Sparse warning:
sound/soc/soc-core.c:252:20: error: incompatible types in comparison expression (different type sizes)

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 sound/soc/soc-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index 051c006281f5..41f6178249df 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -249,7 +249,7 @@ static ssize_t codec_reg_write_file(struct file *file,
 	struct snd_soc_codec *codec = file->private_data;
 	int ret;
 
-	buf_size = min(count, (sizeof(buf)-1));
+	buf_size = min(count, (size_t)(sizeof(buf)-1));
 	if (copy_from_user(buf, user_buf, buf_size))
 		return -EFAULT;
 	buf[buf_size] = 0;
-- 
1.8.3.2

