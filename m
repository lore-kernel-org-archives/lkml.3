Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341Ab3JCEGJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 00:06:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46743 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299Ab3JCEGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 00:06:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [ 12/13] hwmon: (applesmc) Silence uninitialized warnings
Date: Wed,  2 Oct 2013 21:04:37 -0700
Message-Id: <20131003040401.601131211@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20131003040400.753642257@linuxfoundation.org>
References: <20131003040400.753642257@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henrik Rydberg <rydberg@euromail.se>

commit 0fc86eca1b338d06ec500b34ef7def79c32b602b upstream.

Some error paths do not set a result, leading to the (false)
assumption that the value may be used uninitialized. Set results for
those paths as well.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/applesmc.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -344,8 +344,10 @@ static int applesmc_get_lower_bound(unsi
 	while (begin != end) {
 		int middle = begin + (end - begin) / 2;
 		entry = applesmc_get_entry_by_index(middle);
-		if (IS_ERR(entry))
+		if (IS_ERR(entry)) {
+			*lo = 0;
 			return PTR_ERR(entry);
+		}
 		if (strcmp(entry->key, key) < 0)
 			begin = middle + 1;
 		else
@@ -364,8 +366,10 @@ static int applesmc_get_upper_bound(unsi
 	while (begin != end) {
 		int middle = begin + (end - begin) / 2;
 		entry = applesmc_get_entry_by_index(middle);
-		if (IS_ERR(entry))
+		if (IS_ERR(entry)) {
+			*hi = smcreg.key_count;
 			return PTR_ERR(entry);
+		}
 		if (strcmp(key, entry->key) < 0)
 			end = middle;
 		else


