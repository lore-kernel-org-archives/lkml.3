Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878Ab3LMWqU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:46:20 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:39527 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584Ab3LMW0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:26:36 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        Olav Haugan <ohaugan@codeaurora.org>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 020/115] gpu: ion: Add missing argument to WARN call
Date: Fri, 13 Dec 2013 14:23:54 -0800
Message-Id: <1386973529-4884-21-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Olav Haugan <ohaugan@codeaurora.org>

The condition argument to the WARN call in ion_free and
ion_share_dma_buf are missing. Add the argument to
allow correct printing of warning message.

Signed-off-by: Olav Haugan <ohaugan@codeaurora.org>
[jstultz: modified patch to apply to staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index d4e4c68..5872dd3 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -408,7 +408,7 @@ void ion_free(struct ion_client *client, struct ion_handle *handle)
 	mutex_unlock(&client->lock);
 
 	if (!valid_handle) {
-		WARN("%s: invalid handle passed to free.\n", __func__);
+		WARN(1, "%s: invalid handle passed to free.\n", __func__);
 		return;
 	}
 	ion_handle_put(handle);
@@ -906,7 +906,7 @@ int ion_share_dma_buf(struct ion_client *client, struct ion_handle *handle)
 	valid_handle = ion_handle_validate(client, handle);
 	mutex_unlock(&client->lock);
 	if (!valid_handle) {
-		WARN("%s: invalid handle passed to share.\n", __func__);
+		WARN(1, "%s: invalid handle passed to share.\n", __func__);
 		return -EINVAL;
 	}
 
-- 
1.8.3.2

