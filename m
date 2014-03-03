Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390AbaCCLJa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 06:09:30 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:55039 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753693AbaCCLJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 06:09:29 -0500
From: Nenghua Cao <nhcao@marvell.com>
To: Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        Mark Brown <broonie@kernel.org>, <linux-kernel@vger.kernel.org>
CC: Nenghua Cao <nhcao@marvell.com>
Subject: [PATCH] asoc: soc-core: fix coccinelle warnings
Date: Mon, 3 Mar 2014 19:08:23 +0800
Message-ID: <1393844903-1295-1-git-send-email-nhcao@marvell.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-03-03_01:2014-03-03,2014-03-02,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1403030018
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nenghua Cao <nhcao@marvell.com>

sound/soc/soc-core.c:2708:6-13: WARNING: Assignment of
bool to 0/1
sound/soc/soc-core.c:2726:3-10: WARNING: Assignment of
bool to 0/1

    More information about semantic patching is available at
http://coccinelle.lip6.fr/

Signed-off-by: Nenghua Cao <nhcao@marvell.com>
---
 sound/soc/soc-core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index fb598cb..d92eb93 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
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

