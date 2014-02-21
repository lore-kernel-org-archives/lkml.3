Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933391AbaBUNck (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:32:40 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47134 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932449AbaBUMvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:51:06 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Paul Bolle <pebolle@tiscali.nl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 083/121] raw: test against runtime value of max_raw_minors
Date: Fri, 21 Feb 2014 12:48:27 +0000
Message-Id: <1392986945-9693-84-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/char/raw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/raw.c b/drivers/char/raw.c
index f3223aa..6e8d65e 100644
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
1.9.0

