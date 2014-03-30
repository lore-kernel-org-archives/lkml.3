Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130AbaCaABt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 20:01:49 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37332 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753289AbaC3XnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:43:06 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Paul Bolle" <pebolle@tiscali.nl>, "Jan Kara" <jack@suse.cz>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.218007476@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 093/200] raw: test against runtime value of max_raw_minors
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/char/raw.c | 2 +-
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

