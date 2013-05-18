Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756929Ab3ERCRI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 22:17:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7265 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756777Ab3ERCQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 22:16:57 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=aUsD4yJnt7cA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=xjiacg3gJ5wA:10 a=i0EeH86SAAAA:8 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=Z4Rwk6OoAAAA:8 a=AOH2JziRS7aWt03D-MQA:9 a=hPjdaMEvmhQA:10 a=jEp0ucaQiEUA:10 a=jbrJJM5MRmoA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021648.688023639@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:16:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Anurup m <anurup.m@huawei.com>, shyju pv <shyju.pv@huawei.com>,
        Sanil kumar <sanil.kumar@huawei.com>, Nataraj m <nataraj.m@huawei.com>,
        Li Zefan <lizefan@huawei.com>, David Howells <dhowells@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [ 043/136 ] fs/fscache/stats.c: fix memory leak
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0043-fs-fscache-stats.c-fix-memory-leak.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Anurup m <anurup.m@huawei.com>

[ Upstream commit ec686c9239b4d472052a271c505d04dae84214cc ]

There is a kernel memory leak observed when the proc file
/proc/fs/fscache/stats is read.

The reason is that in fscache_stats_open, single_open is called and the
respective release function is not called during release.  Hence fix
with correct release function - single_release().

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=57101

Signed-off-by: Anurup m <anurup.m@huawei.com>
Cc: shyju pv <shyju.pv@huawei.com>
Cc: Sanil kumar <sanil.kumar@huawei.com>
Cc: Nataraj m <nataraj.m@huawei.com>
Cc: Li Zefan <lizefan@huawei.com>
Cc: David Howells <dhowells@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/fscache/stats.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/fscache/stats.c b/fs/fscache/stats.c
index 4765190..73c0bd7 100644
--- a/fs/fscache/stats.c
+++ b/fs/fscache/stats.c
@@ -276,5 +276,5 @@ const struct file_operations fscache_stats_fops = {
 	.open		= fscache_stats_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= seq_release,
+	.release        = single_release,
 };
-- 
1.7.10.4


