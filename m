Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930Ab3JUIvt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 04:51:49 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39577 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753050Ab3JUIvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:51:39 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Dan Carpenter" <dan.carpenter@oracle.com>,
        "Mark Brown" <broonie@linaro.org>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.803170454@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 074/149] ASoC: 88pm860x: array overflow in
 snd_soc_put_volsw_2r_st()
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit d967967e8d1116fb38bad25e58714b5dddd03cca upstream.

This is called from snd_ctl_elem_write() with user supplied data so we
need to add some bounds checking.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/soc/codecs/88pm860x-codec.c | 3 +++
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

