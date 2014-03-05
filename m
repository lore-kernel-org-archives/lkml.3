Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758645AbaCEPNB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 10:13:01 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41017 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755608AbaCEOZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:25:56 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Colin Cross <ccross@android.com>,
        Android Kernel Team <kernel-team@android.com>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Jeremy Compostella <jeremy.compostella@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 065/131] staging: binder: Fix death notifications
Date: Wed,  5 Mar 2014 14:23:09 +0000
Message-Id: <1394029455-23128-66-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
References: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>

commit e194fd8a5d8e0a7eeed239a8534460724b62fe2d upstream.

The change (008fa749e0fe5b2fffd20b7fe4891bb80d072c6a) that moved the
node release code to a separate function broke death notifications in
some cases. When it encountered a reference without a death
notification request, it would skip looking at the remaining
references, and therefore fail to send death notifications for them.

Cc: Colin Cross <ccross@android.com>
Cc: Android Kernel Team <kernel-team@android.com>
Signed-off-by: Arve Hjønnevåg <arve@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Jeremy Compostella <jeremy.compostella@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/staging/android/binder.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index 119d486..8b986af 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -2903,7 +2903,7 @@ static int binder_node_release(struct binder_node *node, int refs)
 		refs++;
 
 		if (!ref->death)
-			goto out;
+			continue;
 
 		death++;
 
@@ -2916,7 +2916,6 @@ static int binder_node_release(struct binder_node *node, int refs)
 			BUG();
 	}
 
-out:
 	binder_debug(BINDER_DEBUG_DEAD_BINDER,
 		     "node %d now dead, refs %d, death %d\n",
 		     node->debug_id, refs, death);
-- 
1.9.0

