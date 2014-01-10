Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038AbaAJFds (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 00:33:48 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:2067 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750702AbaAJFdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 00:33:45 -0500
From: Nenghua Cao <nhcao@marvell.com>
To: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>
CC: Nenghua Cao <nhcao@marvell.com>
Subject: [PATCH] ASoC: dpcm: don't do hw_param when BE has done hw_param
Date: Fri, 10 Jan 2014 13:36:35 +0800
Message-ID: <1389332195-15900-1-git-send-email-nhcao@marvell.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-01-10_02:2014-01-09,2014-01-10,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=2
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1401090258
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nenghua Cao <nhcao@marvell.com>

    It fixes the following case:
    Two FEs connects the same BE; FE1 & BE path has been opened and hw_paramed.
At this momment, FE2 & BE path is being opened and hw_paramed. The BE
dai will do hw_param again even if it has done hw_param. It is not
reasonable.
FE1------------>BE
FE2-------------^

Signed-off-by: Nenghua Cao <nhcao@marvell.com>
---
 sound/soc/soc-pcm.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/sound/soc/soc-pcm.c b/sound/soc/soc-pcm.c
index 891b9a9..ec07e37 100644
--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -1339,7 +1339,6 @@ static int dpcm_be_dai_hw_params(struct snd_soc_pcm_runtime *fe, int stream)
 			continue;
 
 		if ((be->dpcm[stream].state != SND_SOC_DPCM_STATE_OPEN) &&
-		    (be->dpcm[stream].state != SND_SOC_DPCM_STATE_HW_PARAMS) &&
 		    (be->dpcm[stream].state != SND_SOC_DPCM_STATE_HW_FREE))
 			continue;
 
-- 
1.7.0.4

