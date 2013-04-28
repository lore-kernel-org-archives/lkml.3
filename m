Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945Ab3D1Ls5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Apr 2013 07:48:57 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:6660 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754955Ab3D1Ls4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Apr 2013 07:48:56 -0400
Message-ID: <517D0C1E.4090004@huawei.com>
Date: Sun, 28 Apr 2013 19:46:38 +0800
From: Zhao Hongjiang <zhaohongjiang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: <bharrosh@panasas.com>, <bhalevy@tonian.com>
CC: Andrew Morton <akpm@linux-foundation.org>, <osd-dev@open-osd.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] =?UTF-8?B?ZXhvZnPvvJogZG9uJ3QgaW5jcmVhc2UgdXJpbGVuIGlmIGs=?=
 =?UTF-8?B?cmVhbGxvYygpIGZhaWxz?=
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.200]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without the patch, edp->urilen is increased before krealloc(). If krealloc() fails,
edp->urilen is too high. Fix that by only updating edp->urilen if krealloc() is successful.

Signed-off-by: Zhao Hongjiang <zhaohongjiang@huawei.com>
---
 fs/exofs/sys.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/exofs/sys.c b/fs/exofs/sys.c
index 1b4f2f9..79b0a85 100644
--- a/fs/exofs/sys.c
+++ b/fs/exofs/sys.c
@@ -82,11 +82,11 @@ static ssize_t uri_store(struct exofs_dev *edp, const char *buf, size_t len)
 {
 	uint8_t *new_uri;
 
-	edp->urilen = strlen(buf) + 1;
-	new_uri = krealloc(edp->uri, edp->urilen, GFP_KERNEL);
+	new_uri = krealloc(edp->uri, strlen(buf) + 1, GFP_KERNEL);
 	if (new_uri == NULL)
 		return -ENOMEM;
 	edp->uri = new_uri;
+	edp->urilen = strlen(buf) + 1;
 	strncpy(edp->uri, buf, edp->urilen);
 	return edp->urilen;
 }
-- 1.7.1

