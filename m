Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106Ab3GaGaf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 02:30:35 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:54464 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245Ab3GaGae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 02:30:34 -0400
Message-ID: <51F8AEF5.3070300@huawei.com>
Date: Wed, 31 Jul 2013 14:30:13 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] Staging: rtl8192u/ieee80211: add missing single_release()
References: <51F8AEC7.7080407@huawei.com>
In-Reply-To: <51F8AEC7.7080407@huawei.com>
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
 drivers/staging/rtl8192u/ieee80211/ieee80211_module.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_module.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_module.c
index e0870c0..434c431 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_module.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_module.c
@@ -268,7 +268,8 @@ static const struct file_operations fops = {
 	.open = open_debug_level,
 	.read = seq_read,
 	.llseek = seq_lseek,
-	.write = write_debug_level
+	.write = write_debug_level,
+	.release = single_release,
 };
 
 int __init ieee80211_debug_init(void)
-- 
1.8.0.2
