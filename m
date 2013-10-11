Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758266Ab3JKKwB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 06:52:01 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58725 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932280Ab3JKKn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:43:57 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Mark Brown <broonie@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 075/100] ASoC: 88pm860x: array overflow in snd_soc_put_volsw_2r_st()
Date: Fri, 11 Oct 2013 11:41:45 +0100
Message-Id: <1381488130-30235-76-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
References: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.23 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit d967967e8d1116fb38bad25e58714b5dddd03cca upstream.

This is called from snd_ctl_elem_write() with user supplied data so we
need to add some bounds checking.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/soc/codecs/88pm860x-codec.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/codecs/88pm860x-codec.c b/sound/soc/codecs/88pm860x-codec.c
index 9fd3b68..3ff2b94 100644
--- a/sound/soc/codecs/88pm860x-codec.c
+++ b/sound/soc/codecs/88pm860x-codec.c
@@ -351,6 +351,9 @@ static int snd_soc_put_volsw_2r_st(struct snd_kcontrol *kcontrol,
 	val = ucontrol->value.integer.value[0];
 	val2 = ucontrol->value.integer.value[1];
 
+	if (val >= ARRAY_SIZE(st_table) || val2 >= ARRAY_SIZE(st_table))
+		return -EINVAL;
+
 	err = snd_soc_update_bits(codec, reg, 0x3f, st_table[val].m);
 	if (err < 0)
 		return err;
-- 
1.8.3.2

