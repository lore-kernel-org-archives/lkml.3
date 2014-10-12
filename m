Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751388AbaJLKrZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 06:47:25 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:63978 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbaJLKrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 06:47:24 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Torsten Duwe <duwe@lst.de>, "Theodore Ts'o" <tytso@mit.edu>,
        Jason Cooper <jason@lakedaemon.net>, Amit Shah <amit.shah@redhat.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Kees Cook <keescook@chromium.org>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2] char: hw_random: core.c:  Changed from using strncat to strlcat
Date: Sun, 12 Oct 2014 12:49:31 +0200
Message-Id: <1413110971-17392-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed from using strncat to strlcat to simplify the code

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/char/hw_random/core.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index aa30a25..1500cfd 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -281,7 +281,6 @@ static ssize_t hwrng_attr_available_show(struct device *dev,
 					 char *buf)
 {
 	int err;
-	ssize_t ret = 0;
 	struct hwrng *rng;
 
 	err = mutex_lock_interruptible(&rng_mutex);
@@ -289,16 +288,13 @@ static ssize_t hwrng_attr_available_show(struct device *dev,
 		return -ERESTARTSYS;
 	buf[0] = '\0';
 	list_for_each_entry(rng, &rng_list, list) {
-		strncat(buf, rng->name, PAGE_SIZE - ret - 1);
-		ret += strlen(rng->name);
-		strncat(buf, " ", PAGE_SIZE - ret - 1);
-		ret++;
+		strlcat(buf, rng->name, PAGE_SIZE);
+		strlcat(buf, " ", PAGE_SIZE);
 	}
-	strncat(buf, "\n", PAGE_SIZE - ret - 1);
-	ret++;
+	strlcat(buf, "\n", PAGE_SIZE);
 	mutex_unlock(&rng_mutex);
 
-	return ret;
+	return strlen(buf);
 }
 
 static DEVICE_ATTR(rng_current, S_IRUGO | S_IWUSR,
-- 
1.7.10.4

