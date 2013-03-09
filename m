Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751139Ab3CISj2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 13:39:28 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:11456 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab3CISj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 13:39:27 -0500
Message-ID: <1362854362.3188.3.camel@lorien2>
Subject: [PATCH] hp_accel: Ignore the error from lis3lv02d_poweron() at
 resume
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: eric.piel@tremplin-utc.net, matthew.garrett@nebula.com, tiwai@suse.de
Cc: platform-driver-x86@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        shuahkhan@gmail.com
Date: Sat, 09 Mar 2013 11:39:22 -0700
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The error in lis3lv02_poweron() is harmless in the resume path, so
we should ignore it. It is inline with the other usages of lis3lv02_poweron()
and matches the 3.0 code for this routine. This patch is in suse git and
might have missed making it into the mainline.
opensuse - commit id: 66ccdac87c322cf7af12bddba8c805af640b1cff 

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Shuah Khan <shuah.khan@hp.com>
CC: stable@vger.kernel.org 3.8, 3.4, 3.5, 3.2
---
 drivers/platform/x86/hp_accel.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/hp_accel.c b/drivers/platform/x86/hp_accel.c
index e64a7a8..a8e43cf 100644
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



