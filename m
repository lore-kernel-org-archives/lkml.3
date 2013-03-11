Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815Ab3CKQXS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 12:23:18 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:42133 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137Ab3CKQXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 12:23:16 -0400
MIME-Version: 1.0
Date: Tue, 12 Mar 2013 00:23:15 +0800
Message-ID: <CAPgLHd9K-jMNYXY=sTkANCfzk_fCAF8arZUZHJmvBRAnCx1SUw@mail.gmail.com>
Subject: [PATCH] ASoC: wm_adsp: fix possible memory leak in wm_adsp_load_coeff()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: broonie@opensource.wolfsonmicro.com, lgirdwood@gmail.com, perex@perex.cz,
        tiwai@suse.de
Cc: yongjun_wei@trendmicro.com.cn, patches@opensource.wolfsonmicro.com,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

'file' is malloced in wm_adsp_load_coeff() and should be freed
before leaving from the error handling cases, otherwise it will cause
memory leak.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 sound/soc/codecs/wm_adsp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/wm_adsp.c b/sound/soc/codecs/wm_adsp.c
index f3f7e75..9af1bdd 100644
--- a/sound/soc/codecs/wm_adsp.c
+++ b/sound/soc/codecs/wm_adsp.c
@@ -828,7 +828,8 @@ static int wm_adsp_load_coeff(struct wm_adsp *dsp)
 						&buf_list);
 			if (!buf) {
 				adsp_err(dsp, "Out of memory\n");
-				return -ENOMEM;
+				ret = -ENOMEM;
+				goto out_fw;
 			}
 
 			adsp_dbg(dsp, "%s.%d: Writing %d bytes at %x\n",
@@ -865,7 +866,7 @@ out_fw:
 	wm_adsp_buf_free(&buf_list);
 out:
 	kfree(file);
-	return 0;
+	return ret;
 }
 
 int wm_adsp1_init(struct wm_adsp *adsp)


