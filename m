Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537Ab3LMWcY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:32:24 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:32840 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161Ab3LMW2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:28:08 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 078/115] ion: don't use id 0 for handle cookie
Date: Fri, 13 Dec 2013 14:24:52 -0800
Message-Id: <1386973529-4884-79-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Cross <ccross@android.com>

ion userspace clients think that the cookie is a pointer, so they
use NULL to check if the handle has been initialized.  Set the first
id number to 1.

Signed-off-by: Colin Cross <ccross@android.com>
[jstultz: modified patch to apply to staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index ef0b2d7..273ec3a 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -424,7 +424,7 @@ static int ion_handle_add(struct ion_client *client, struct ion_handle *handle)
 		rc = idr_pre_get(&client->idr, GFP_KERNEL);
 		if (!rc)
 			return -ENOMEM;
-		rc = idr_get_new(&client->idr, handle, &id);
+		rc = idr_get_new_above(&client->idr, handle, 1, &id);
 		handle->id = id;
 	} while (rc == -EAGAIN);
 
-- 
1.8.3.2

