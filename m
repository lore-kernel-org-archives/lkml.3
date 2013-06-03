Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759915Ab3FCWW7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 18:22:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23462 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758747Ab3FCWL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 18:11:57 -0400
X-Authority-Analysis: v=2.0 cv=fZsvOjsF c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=u4YxOwFJu3UA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=1myszQgcEMsA:10 a=cH6R9-kdAAAA:8 a=VwQbUJbxAAAA:8 a=hhmn9ELmAAAA:8 a=u6Kjp6XQMGfe5Rn6x1sA:9 a=bt0zGP92IBIA:10 a=0kPLrQdw3YYA:10 a=gpwweziqXSoA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130603221153.838851512@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 03 Jun 2013 18:10:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Takashi Iwai <tiwai@suse.de>, Shuah Khan <shuah.khan@hp.com>,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: [10/65] hp_accel: Ignore the error from lis3lv02d_poweron() at resume
References: <20130603221016.243553628@goodmis.org>
Content-Disposition: inline; filename=0010-hp_accel-Ignore-the-error-from-lis3lv02d_poweron-at-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.5 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Shuah Khan <shuah.khan@hp.com>

[ Upstream commit 7783819920ca52fc582a2782f654fe6ed373f465 ]

The error in lis3lv02_poweron() is harmless in the resume path, so
we should ignore it. It is inline with the other usages of lis3lv02_poweron()
and matches the 3.0 code for this routine. This patch is in suse git and
might have missed making it into the mainline.
opensuse - commit id: 66ccdac87c322cf7af12bddba8c805af640b1cff

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Shuah Khan <shuah.khan@hp.com>
CC: stable@vger.kernel.org 3.8, 3.4, 3.5, 3.2
Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/platform/x86/hp_accel.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/hp_accel.c b/drivers/platform/x86/hp_accel.c
index 6b9af98..45f6b5c 100644
--- a/drivers/platform/x86/hp_accel.c
+++ b/drivers/platform/x86/hp_accel.c
@@ -362,7 +362,8 @@ static int lis3lv02d_suspend(struct device *dev)
 
 static int lis3lv02d_resume(struct device *dev)
 {
-	return lis3lv02d_poweron(&lis3_dev);
+	lis3lv02d_poweron(&lis3_dev);
+	return 0;
 }
 
 static SIMPLE_DEV_PM_OPS(hp_accel_pm, lis3lv02d_suspend, lis3lv02d_resume);
-- 
1.7.10.4


