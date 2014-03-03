Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353AbaCCS7R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 13:59:17 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:56118 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755320AbaCCS7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 13:59:05 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Paul Bolle <pebolle@tiscali.nl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 47/67] raw: test against runtime value of max_raw_minors
Date: Mon,  3 Mar 2014 10:55:35 -0800
Message-Id: <1393872955-28810-48-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393872955-28810-1-git-send-email-kamal@canonical.com>
References: <1393872955-28810-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.19 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Bolle <pebolle@tiscali.nl>

commit 5bbb2ae3d6f896f8d2082d1eceb6131c2420b7cf upstream.

bind_get() checks the device number it is called with. It uses
MAX_RAW_MINORS for the upper bound. But MAX_RAW_MINORS is set at compile
time while the actual number of raw devices can be set at runtime. This
means the test can either be too strict or too lenient. And if the test
ends up being too lenient bind_get() might try to access memory beyond
what was allocated for "raw_devices".

So check against the runtime value (max_raw_minors) in this function.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Acked-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/char/raw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/raw.c b/drivers/char/raw.c
index 54a3a6d..5959669 100644
--- a/drivers/char/raw.c
+++ b/drivers/char/raw.c
@@ -190,7 +190,7 @@ static int bind_get(int number, dev_t *dev)
 	struct raw_device_data *rawdev;
 	struct block_device *bdev;
 
-	if (number <= 0 || number >= MAX_RAW_MINORS)
+	if (number <= 0 || number >= max_raw_minors)
 		return -EINVAL;
 
 	rawdev = &raw_devices[number];
-- 
1.8.3.2

