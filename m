Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753777AbaBUIH4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 03:07:56 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:23762 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753686AbaBUIHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 03:07:53 -0500
From: Nenghua Cao <nhcao@marvell.com>
To: Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        Mark Brown <broonie@kernel.org>, <linux-kernel@vger.kernel.org>
CC: Nenghua Cao <nhcao@marvell.com>
Subject: [PATCH 2/2] asoc: soc-core: fix coccinelle warnings
Date: Fri, 21 Feb 2014 16:06:10 +0800
Message-ID: <1392969970-28037-1-git-send-email-nhcao@marvell.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-02-21_03:2014-02-21,2014-02-21,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1402200242
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nenghua Cao <nhcao@marvell.com>

sound/soc/soc-core.c:2708:6-13: WARNING: Assignment of
bool to 0/1
sound/soc/soc-core.c:2726:3-10: WARNING: Assignment of
bool to 0/1
sound/soc/soc-core.c:2264:1-7: Replace memcpy with
struct assignment

    More information about semantic patching is available at
http://coccinelle.lip6.fr/

Signed-off-by: Nenghua Cao <nhcao@marvell.com>
---
 sound/soc/soc-core.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index fb598cb..c59b3ea 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -2413,7 +2413,7 @@ struct snd_kcontrol *snd_soc_cnew(const struct snd_kcontrol_new *_template,
 	struct snd_kcontrol *kcontrol;
 	char *name = NULL;
 
-	memcpy(&template, _template, sizeof(template));
+	memcpy(&template, _template, sizeof(struct snd_kcontrol_new));
 	template.index = 0;
 
 	if (!long_name)
@@ -2818,7 +2818,7 @@ int snd_soc_put_volsw(struct snd_kcontrol *kcontrol,
 	unsigned int mask = (1 << fls(max)) - 1;
 	unsigned int invert = mc->invert;
 	int err;
-	bool type_2r = 0;
+	bool type_2r = false;
 	unsigned int val2 = 0;
 	unsigned int val, val_mask;
 
@@ -2836,7 +2836,7 @@ int snd_soc_put_volsw(struct snd_kcontrol *kcontrol,
 			val |= val2 << rshift;
 		} else {
 			val2 = val2 << shift;
-			type_2r = 1;
+			type_2r = true;
 		}
 	}
 	err = snd_soc_update_bits_locked(codec, reg, val_mask, val);
-- 
1.7.0.4

