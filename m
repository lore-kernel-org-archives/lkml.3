Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257Ab3EJOVM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:21:12 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57137 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753578Ab3EJOVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:21:09 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Anurup m" <anurup.m@huawei.com>,
        "David Howells" <dhowells@redhat.com>,
        "Sanil kumar" <sanil.kumar@huawei.com>,
        "shyju pv" <shyju.pv@huawei.com>, "Nataraj m" <nataraj.m@huawei.com>,
        "Li Zefan" <lizefan@huawei.com>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.159546939@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [065/118] fs/fscache/stats.c: fix memory leak
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/fscache/stats.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/fscache/stats.c
+++ b/fs/fscache/stats.c
@@ -276,5 +276,5 @@ const struct file_operations fscache_sta
 	.open		= fscache_stats_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= seq_release,
+	.release        = single_release,
 };

