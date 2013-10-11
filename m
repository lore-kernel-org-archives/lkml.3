Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758179Ab3JKThT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 15:37:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45316 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758035Ab3JKThN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:37:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Mark Brown <broonie@linaro.org>
Subject: [ 21/48] ASoC: 88pm860x: array overflow in snd_soc_put_volsw_2r_st()
Date: Fri, 11 Oct 2013 12:36:28 -0700
Message-Id: <20131011193639.556205450@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193637.253208688@linuxfoundation.org>
References: <20131011193637.253208688@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit d967967e8d1116fb38bad25e58714b5dddd03cca upstream.

This is called from snd_ctl_elem_write() with user supplied data so we
need to add some bounds checking.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/88pm860x-codec.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/soc/codecs/88pm860x-codec.c
+++ b/sound/soc/codecs/88pm860x-codec.c
@@ -351,6 +351,9 @@ static int snd_soc_put_volsw_2r_st(struc
 	val = ucontrol->value.integer.value[0];
 	val2 = ucontrol->value.integer.value[1];
 
+	if (val >= ARRAY_SIZE(st_table) || val2 >= ARRAY_SIZE(st_table))
+		return -EINVAL;
+
 	err = snd_soc_update_bits(codec, reg, 0x3f, st_table[val].m);
 	if (err < 0)
 		return err;


