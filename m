Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725AbaBUMxO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 07:53:14 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47328 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932699AbaBUMvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:51:55 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jingoo Han <jg1.han@samsung.com>, Borislav Petkov <bp@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 118/121] EDAC: Replace strict_strtol() with kstrtol()
Date: Fri, 21 Feb 2014 12:49:02 +0000
Message-Id: <1392986945-9693-119-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jingoo Han <jg1.han@samsung.com>

commit c542b53da9ffa4fe9de61149818a06aacae531f8 upstream.

The usage of strict_strtol() is not preferred, because strict_strtol()
is obsolete. Thus, kstrtol() should be used.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/edac/edac_mc_sysfs.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index e7c32c4..9f7e0e60 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -58,8 +58,10 @@ static int edac_set_poll_msec(const char *val, struct kernel_param *kp)
 	if (!val)
 		return -EINVAL;
 
-	ret = strict_strtol(val, 0, &l);
-	if (ret == -EINVAL || ((int)l != l))
+	ret = kstrtol(val, 0, &l);
+	if (ret)
+		return ret;
+	if ((int)l != l)
 		return -EINVAL;
 	*((int *)kp->arg) = l;
 
-- 
1.9.0

