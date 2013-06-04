Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922Ab3FDXCu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 19:02:50 -0400
Received: from 1wt.eu ([62.212.114.60]:35653 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753570Ab3FDWnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:43:05 -0400
Message-Id: <20130604172135.036646700@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:23:24 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Anurup m <anurup.m@huawei.com>, shyju pv <shyju.pv@huawei.com>,
        Sanil kumar <sanil.kumar@huawei.com>, Nataraj m <nataraj.m@huawei.com>,
        Li Zefan <lizefan@huawei.com>, David Howells <dhowells@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 114/184] fs/fscache/stats.c: fix memory leak
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Anurup m <anurup.m@huawei.com>

commit ec686c9239b4d472052a271c505d04dae84214cc upstream.

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 fs/fscache/stats.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/fscache/stats.c b/fs/fscache/stats.c
index 46435f3a..4fd7e1c 100644
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
1.7.12.2.21.g234cd45.dirty



