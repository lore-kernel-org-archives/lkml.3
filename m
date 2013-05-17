Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758412Ab3EQWWJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 18:22:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54059 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756894Ab3EQVhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:37:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>, Shuah Khan <shuah.khan@hp.com>,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: [ 026/102] hp_accel: Ignore the error from lis3lv02d_poweron() at resume
Date: Fri, 17 May 2013 14:35:41 -0700
Message-Id: <20130517213247.126136610@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517213244.277411019@linuxfoundation.org>
References: <20130517213244.277411019@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuah Khan <shuah.khan@hp.com>

commit 7783819920ca52fc582a2782f654fe6ed373f465 upstream.

The error in lis3lv02_poweron() is harmless in the resume path, so
we should ignore it. It is inline with the other usages of lis3lv02_poweron()
and matches the 3.0 code for this routine. This patch is in suse git and
might have missed making it into the mainline.
opensuse - commit id: 66ccdac87c322cf7af12bddba8c805af640b1cff

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Shuah Khan <shuah.khan@hp.com>
Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/platform/x86/hp_accel.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/platform/x86/hp_accel.c
+++ b/drivers/platform/x86/hp_accel.c
@@ -362,7 +362,8 @@ static int lis3lv02d_suspend(struct devi
 
 static int lis3lv02d_resume(struct device *dev)
 {
-	return lis3lv02d_poweron(&lis3_dev);
+	lis3lv02d_poweron(&lis3_dev);
+	return 0;
 }
 
 static SIMPLE_DEV_PM_OPS(hp_accel_pm, lis3lv02d_suspend, lis3lv02d_resume);


