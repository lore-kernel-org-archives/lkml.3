Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759403Ab3K0BgU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:36:20 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39258 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932363Ab3K0A6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:58:23 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Colin Cross <ccross@android.com>,
        Android Kernel Team <kernel-team@android.com>,
        Glauber Costa <glommer@openvz.org>,
        YongQin Liu <yongqin.liu@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 3.12 015/116] staging: ashmem: Fix ASHMEM_PURGE_ALL_CACHES return value
Date: Tue, 26 Nov 2013 16:56:28 -0800
Message-Id: <20131127005737.991090042@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005736.915454872@linuxfoundation.org>
References: <20131127005736.915454872@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Stultz <john.stultz@linaro.org>

commit 5957324045ba2c127c9401fa3ac61ac52e043ca8 upstream.

Hopefully this isn't too late for 3.12.

In commit 7dc19d5aff (convert shrinkers to new count/scan API)
the return value to PURGE_ALL_CACHES was dropped, causing -EPERM
to always be returned.

This patch re-adds the ret assignment, setting it to the the
ashmem_shrink_count(), which is the lru_count.

(Sorry this was missed in the review!)

Fixes: 7dc19d5affd7 ("convert shrinkers to new count/scan API")
Cc: Colin Cross <ccross@android.com>
Cc: Android Kernel Team <kernel-team@android.com>
Cc: Glauber Costa <glommer@openvz.org>
Reported-by: YongQin Liu <yongqin.liu@linaro.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Acked-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/android/ashmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/android/ashmem.c
+++ b/drivers/staging/android/ashmem.c
@@ -706,7 +706,7 @@ static long ashmem_ioctl(struct file *fi
 				.gfp_mask = GFP_KERNEL,
 				.nr_to_scan = LONG_MAX,
 			};
-
+			ret = ashmem_shrink_count(&ashmem_shrinker, &sc);
 			nodes_setall(sc.nodes_to_scan);
 			ashmem_shrink_scan(&ashmem_shrinker, &sc);
 		}


