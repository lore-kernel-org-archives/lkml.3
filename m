Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932846AbbAGBwf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 20:52:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46250 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932567AbbAGBwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 20:52:22 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andrei Warkentin <andrey.warkentin@gmail.com>,
        Baruch Siach <baruch@tkos.co.il>, Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 3.10 08/38] mmc: block: add newline to sysfs display of force_ro
Date: Tue,  6 Jan 2015 17:50:20 -0800
Message-Id: <20150107014953.809724602@linuxfoundation.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <20150107014952.440109372@linuxfoundation.org>
References: <20150107014952.440109372@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baruch Siach <baruch@tkos.co.il>

commit 0031a98a85e9fca282624bfc887f9531b2768396 upstream.

Make force_ro consistent with other sysfs entries.

Fixes: 371a689f64b0d ('mmc: MMC boot partitions support')
Cc: Andrei Warkentin <andrey.warkentin@gmail.com>
Signed-off-by: Baruch Siach <baruch@tkos.co.il>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/card/block.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -257,7 +257,7 @@ static ssize_t force_ro_show(struct devi
 	int ret;
 	struct mmc_blk_data *md = mmc_blk_get(dev_to_disk(dev));
 
-	ret = snprintf(buf, PAGE_SIZE, "%d",
+	ret = snprintf(buf, PAGE_SIZE, "%d\n",
 		       get_disk_ro(dev_to_disk(dev)) ^
 		       md->read_only);
 	mmc_blk_put(md);


