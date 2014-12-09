Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222AbaLINPR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 08:15:17 -0500
Received: from m12-18.163.com ([220.181.12.18]:44632 "EHLO m12-18.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757207AbaLINPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 08:15:15 -0500
X-Coremail-DSSMTP: 117.88.175.67
From: weiyj_lk@163.com
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Vinod Koul <vinod.koul@intel.com>,
        kbuild test robot <fengguang.wu@intel.com>,
        Mengdong Lin <mengdong.lin@intel.com>,
        "Subhransu S. Prusty" <subhransu.s.prusty@intel.com>
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH -next] ASoC: Intel: fix return value check in sst_acpi_probe()
Date: Tue,  9 Dec 2014 21:14:37 +0800
Message-Id: <1418130877-28923-1-git-send-email-weiyj_lk@163.com>
X-Mailer: git-send-email 1.9.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: EsCowEBJzUnA9YZU_BKIAw--.62S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxJF1rCF4DXrW7XFyftF45trb_yoW8Gryrpa
	yDWFWqqrya9F4S9343t3WUXF15ZryI9a1fGr18AwsFk3Z5GrnYgrWaqayUtayrZ3yvqF1q
	vayDWrW8ZF45ZaUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jt18QUUUUU=
X-Originating-IP: [117.88.175.67]
X-CM-SenderInfo: pzhl5yxbonqiywtou0bp/1tbiGQFd1lEAQCV9uQAAsj
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

In case of error, the function platform_device_register_data()
returns ERR_PTR() and never returns NULL. The NULL test in the
return value check should be replaced with IS_ERR().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 sound/soc/intel/sst/sst_acpi.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/soc/intel/sst/sst_acpi.c b/sound/soc/intel/sst/sst_acpi.c
index 31124aa..f59972a 100644
--- a/sound/soc/intel/sst/sst_acpi.c
+++ b/sound/soc/intel/sst/sst_acpi.c
@@ -277,16 +277,16 @@ int sst_acpi_probe(struct platform_device *pdev)
 	dev_dbg(dev, "ACPI device id: %x\n", dev_id);
 
 	plat_dev = platform_device_register_data(dev, mach->pdata->platform, -1, NULL, 0);
-	if (plat_dev == NULL) {
+	if (IS_ERR(plat_dev)) {
 		dev_err(dev, "Failed to create machine device: %s\n", mach->pdata->platform);
-		return -ENODEV;
+		return PTR_ERR(plat_dev);
 	}
 
 	/* Create platform device for sst machine driver */
 	mdev = platform_device_register_data(dev, mach->machine, -1, NULL, 0);
-	if (mdev == NULL) {
+	if (IS_ERR(mdev)) {
 		dev_err(dev, "Failed to create machine device: %s\n", mach->machine);
-		return -ENODEV;
+		return PTR_ERR(mdev);
 	}
 
 	ret = sst_alloc_drv_context(&ctx, dev, dev_id);

