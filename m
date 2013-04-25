Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297Ab3DYKGy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 06:06:54 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:53483 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584Ab3DYKGx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 06:06:53 -0400
From: Anurup m <anurup.m@huawei.com>
To: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
CC: shyju pv <shyju.pv@huawei.com>, Sanil kumar <sanil.kumar@huawei.com>,
        Nataraj m <nataraj.m@huawei.com>
Subject: [ PATCH ] Memory leak fix for bug 57101.  
Thread-Topic: [ PATCH ] Memory leak fix for bug 57101.  
Thread-Index: Ac5BnHLiKtw//4SASqizn6Zt16WO4Q==
Date: Thu, 25 Apr 2013 10:05:44 +0000
Message-ID: <D2393EB95A9993478029A6FE6A290A9F15F504C9@szxeml510-mbx.china.huawei.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.18.96.95]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

There is a kernel memory leak observed when the proc file /proc/fs/fscache/stats is read.
The reason is that in fscache_stats_open, single_open is called and respective release function is not called during release.
Hence fix with correct release function - single_release. The patch is as below

diff -uprN -X linux-3.9-rc8-vanilla/Documentation/dontdiff linux-3.9-rc8-vanilla/fs/fscache/stats.c linux-3.9-rc8.mod/fs/fscache/stats.c 
--- linux-3.9-rc8-vanilla/fs/fscache/stats.c        2013-04-22 03:08:45.000000000 +0530 
+++ linux-3.9-rc8.mod/fs/fscache/stats.c        2013-04-24 23:03:31.531296160 +0530 
@@ -287,5 +287,5 @@ const struct file_operations fscache_sta 
         .open                = fscache_stats_open, 
         .read                = seq_read, 
         .llseek                = seq_lseek, 
-        .release        = seq_release, 
+        .release        = single_release, 
 };

Regards,
Anurup M
