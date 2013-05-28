Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310Ab3E1VXq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 17:23:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59590 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757016Ab3E1VXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 17:23:42 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>, Shuah Khan <shuah.khan@hp.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 28/78] hp_accel: Ignore the error from lis3lv02d_poweron() at resume
Date: Tue, 28 May 2013 14:19:37 -0700
Message-Id: <1369776027-17859-29-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369776027-17859-1-git-send-email-kamal@canonical.com>
References: <1369776027-17859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.1 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/platform/x86/hp_accel.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/hp_accel.c b/drivers/platform/x86/hp_accel.c
index 18d74f2..1c43168 100644
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
1.8.1.2

