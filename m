Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751373AbbAQGNM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 01:13:12 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:56741 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbbAQGNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 01:13:11 -0500
From: Shailendra Verma <shailendra.capricorn@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Mitchel Humpherys <mitchelh@codeaurora.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org,
        Shailendra Verma <shailendra.capricorn@gmail.com>
Subject: [PATCH 1/1] Fix Kernel Panic due to dereference of the invalid handle. First validate the handle and then derefer it in BUG_ON.
Date: Sat, 17 Jan 2015 11:42:41 +0530
Message-Id: <1421475161-17755-1-git-send-email-shailendra.capricorn@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Shailendra Verma <shailendra.capricorn@gmail.com>
---
 drivers/staging/android/ion/ion.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index 296d347..9e56d32 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -536,8 +536,6 @@ void ion_free(struct ion_client *client, struct ion_handle *handle)
 {
 	bool valid_handle;

-	BUG_ON(client != handle->client);
-
 	mutex_lock(&client->lock);
 	valid_handle = ion_handle_validate(client, handle);

@@ -547,6 +545,7 @@ void ion_free(struct ion_client *client, struct ion_handle *handle)
 		return;
 	}
 	mutex_unlock(&client->lock);
+	BUG_ON(client != handle->client);
 	ion_handle_put(handle);
 }
 EXPORT_SYMBOL(ion_free);
--
1.7.9.5

