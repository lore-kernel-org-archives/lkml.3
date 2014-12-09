Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756304AbaLIBLL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 20:11:11 -0500
Received: from m12-18.163.com ([220.181.12.18]:53966 "EHLO m12-18.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103AbaLIBLK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 20:11:10 -0500
X-Coremail-DSSMTP: 114.221.144.142
From: weiyj_lk@163.com
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Vinod Koul <vinod.koul@intel.com>,
        Mengdong Lin <mengdong.lin@intel.com>,
        kbuild test robot <fengguang.wu@intel.com>,
        "Subhransu S. Prusty" <subhransu.s.prusty@intel.com>
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH -next] ASoC: Intel: fix sparse non static symbol warnings
Date: Tue,  9 Dec 2014 09:10:44 +0800
Message-Id: <1418087444-14504-1-git-send-email-weiyj_lk@163.com>
X-Mailer: git-send-email 1.9.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: EsCowEDpq28VTIZUTehgAw--.711S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7WryUGw4fXFW3tr4xJFyDGFg_yoW8Jry5pa
	4qgayDurWY9F4ru34Uta1UAF1rZr95A3WfJr45Zw4ftF4rKr1kWFWSqFWUAFWrGrWkKFsI
	y3W7JFy8AF45Z3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jmJPiUUUUU=
X-Originating-IP: [114.221.144.142]
X-CM-SenderInfo: pzhl5yxbonqiywtou0bp/1tbiRx5d1lD+XeWMLAAAsk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fixes the following sparse warnings:

sound/soc/intel/sst/sst_acpi.c:248:5: warning:
 symbol 'sst_acpi_probe' was not declared. Should it be static?
sound/soc/intel/sst/sst_acpi.c:335:5: warning:
 symbol 'sst_acpi_remove' was not declared. Should it be static?

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 sound/soc/intel/sst/sst_acpi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/intel/sst/sst_acpi.c b/sound/soc/intel/sst/sst_acpi.c
index 31124aa..98a8f66 100644
--- a/sound/soc/intel/sst/sst_acpi.c
+++ b/sound/soc/intel/sst/sst_acpi.c
@@ -245,7 +245,7 @@ static struct sst_machines *sst_acpi_find_machine(
 	return NULL;
 }
 
-int sst_acpi_probe(struct platform_device *pdev)
+static int sst_acpi_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	int ret = 0;
@@ -332,7 +332,7 @@ do_sst_cleanup:
 * This function is called by OS when a device is unloaded
 * This frees the interrupt etc
 */
-int sst_acpi_remove(struct platform_device *pdev)
+static int sst_acpi_remove(struct platform_device *pdev)
 {
 	struct intel_sst_drv *ctx;
 

