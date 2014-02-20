Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372AbaBUBFL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 20:05:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45337 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691AbaBTXun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:50:43 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Paul Bolle <pebolle@tiscali.nl>, Jan Kara <jack@suse.cz>
Subject: [PATCH 3.4 07/25] raw: test against runtime value of max_raw_minors
Date: Thu, 20 Feb 2014 15:51:23 -0800
Message-Id: <20140220234842.689639289@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140220234842.483343851@linuxfoundation.org>
References: <20140220234842.483343851@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/char/raw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/raw.c
+++ b/drivers/char/raw.c
@@ -190,7 +190,7 @@ static int bind_get(int number, dev_t *d
 	struct raw_device_data *rawdev;
 	struct block_device *bdev;
 
-	if (number <= 0 || number >= MAX_RAW_MINORS)
+	if (number <= 0 || number >= max_raw_minors)
 		return -EINVAL;
 
 	rawdev = &raw_devices[number];


