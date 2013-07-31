Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519Ab3GaG3p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 02:29:45 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:54284 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659Ab3GaG3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 02:29:44 -0400
Message-ID: <51F8AEC7.7080407@huawei.com>
Date: Wed, 31 Jul 2013 14:29:27 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] Staging: rtl8192e: add missing single_release()
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The debug file is opened with single_open(), but there's no
single_release().

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 drivers/staging/rtl8192e/rtllib_module.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8192e/rtllib_module.c b/drivers/staging/rtl8192e/rtllib_module.c
index 84ea721..51d46e0 100644
--- a/drivers/staging/rtl8192e/rtllib_module.c
+++ b/drivers/staging/rtl8192e/rtllib_module.c
@@ -233,7 +233,8 @@ static const struct file_operations fops = {
 	.open = open_debug_level,
 	.read = seq_read,
 	.llseek = seq_lseek,
-	.write = write_debug_level
+	.write = write_debug_level,
+	.release = single_release,
 };
 
 int __init rtllib_init(void)
-- 
1.8.0.2
