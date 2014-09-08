Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094AbaIHWMG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 18:12:06 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:60403 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754254AbaIHWME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 18:12:04 -0400
Message-ID: <540E29B1.6090005@gmail.com>
Date: Tue, 09 Sep 2014 00:12:01 +0200
From: Hugues <morisset.hugues@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: gregkh@linuxfoundation.org
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] staging: lustre: Fix potential buffer underflow
References: <540E27FB.2070206@gmail.com> <540E287D.5090101@gmail.com> <540E28AD.2060607@gmail.com>
In-Reply-To: <540E28AD.2060607@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------010204070902090403060208"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010204070902090403060208
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

Fix potential buffer underflow

When the string 'name' start with a '-' ptr == name and so --ptr will
underflow, this patch corrected this by checking ptr before decrementing.

--------------010204070902090403060208
Content-Type: text/x-patch;
 name="0004-staging-lustre-Fix-potential-buffer-underflow.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0004-staging-lustre-Fix-potential-buffer-underflow.patch"

>From 5786040323bd1dc3149fb4afbea9f01e2bf4cfdf Mon Sep 17 00:00:00 2001
From: Hugues Morisset <morisset.hugues@gmail.com>
Date: Mon, 8 Sep 2014 22:59:04 +0200
Subject: [PATCH 4/4] staging: lustre: Fix potential buffer underflow

Signed-off-by: Hugues Morisset <morisset.hugues@gmail.com>
---
 drivers/staging/lustre/lustre/include/obd.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/include/obd.h b/drivers/staging/lustre/lustre/include/obd.h
index 409eae6..bb67e40 100644
--- a/drivers/staging/lustre/lustre/include/obd.h
+++ b/drivers/staging/lustre/lustre/include/obd.h
@@ -677,7 +677,12 @@ static inline int is_osp_on_mdt(char *name)
 	if (strncmp(ptr + 1, "MDT", 3) != 0)
 		return 0;
 
-	while (*(--ptr) != '-' && ptr != name);
+	if (ptr == name)
+		return 0;
+
+	--ptr;
+	while (ptr != '-' && ptr != name)
+		--ptr;
 
 	if (ptr == name)
 		return 0;
-- 
2.1.0


--------------010204070902090403060208--
