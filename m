Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370Ab3JJPtC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:49:02 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52899 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755703Ab3JJPs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:48:59 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Mark Brown <broonie@linaro.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 080/104] ASoC: 88pm860x: array overflow in snd_soc_put_volsw_2r_st()
Date: Thu, 10 Oct 2013 08:42:08 -0700
Message-Id: <1381419752-29733-81-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381419752-29733-1-git-send-email-kamal@canonical.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit d967967e8d1116fb38bad25e58714b5dddd03cca upstream.

This is called from snd_ctl_elem_write() with user supplied data so we
need to add some bounds checking.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/soc/codecs/88pm860x-codec.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/codecs/88pm860x-codec.c b/sound/soc/codecs/88pm860x-codec.c
index 60159c0..6fd174b 100644
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
1.8.1.2

