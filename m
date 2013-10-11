Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759515Ab3JKUgq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 16:36:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45706 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758917Ab3JKTkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:40:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Mark Brown <broonie@linaro.org>
Subject: [ 047/110] ASoC: max98095: a couple array underflows
Date: Fri, 11 Oct 2013 12:38:27 -0700
Message-Id: <20131011193812.948694865@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193807.584188672@linuxfoundation.org>
References: <20131011193807.584188672@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit f8d7b13e14357ed19d2ca2799539600418dc3939 upstream.

The ->put() function are called from snd_ctl_elem_write() with user
supplied data.  The limit checks here could underflow leading to a
crash.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/max98095.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/soc/codecs/max98095.c
+++ b/sound/soc/codecs/max98095.c
@@ -1863,7 +1863,7 @@ static int max98095_put_eq_enum(struct s
 	struct max98095_pdata *pdata = max98095->pdata;
 	int channel = max98095_get_eq_channel(kcontrol->id.name);
 	struct max98095_cdata *cdata;
-	int sel = ucontrol->value.integer.value[0];
+	unsigned int sel = ucontrol->value.integer.value[0];
 	struct max98095_eq_cfg *coef_set;
 	int fs, best, best_val, i;
 	int regmask, regsave;
@@ -2016,7 +2016,7 @@ static int max98095_put_bq_enum(struct s
 	struct max98095_pdata *pdata = max98095->pdata;
 	int channel = max98095_get_bq_channel(codec, kcontrol->id.name);
 	struct max98095_cdata *cdata;
-	int sel = ucontrol->value.integer.value[0];
+	unsigned int sel = ucontrol->value.integer.value[0];
 	struct max98095_biquad_cfg *coef_set;
 	int fs, best, best_val, i;
 	int regmask, regsave;


