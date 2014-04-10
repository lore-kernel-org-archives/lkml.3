Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934699AbaDJDWJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 23:22:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40790 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758385AbaDJDVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:21:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        "Serge E. Hallyn" <serge.hallyn@ubuntu.com>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ben Hutchings <ben@decadent.org.uk>,
        Qiang Huang <h.huangqiang@huawei.com>, Li Zefan <lizefan@huawei.com>,
        Jianguo Wu <wujianguo@huawei.com>
Subject: [PATCH 3.4 001/134] proc: pid/status: show all supplementary groups
Date: Wed,  9 Apr 2014 20:21:57 -0700
Message-Id: <20140410032259.806926913@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140410032259.587501440@linuxfoundation.org>
References: <20140410032259.587501440@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>


commit 8d238027b87e654be552eabdf492042a34c5c300 upstream.

We display a list of supplementary group for each process in
/proc/<pid>/status.  However, we show only the first 32 groups, not all of
them.

Although this is rare, but sometimes processes do have more than 32
supplementary groups, and this kernel limitation breaks user-space apps
that rely on the group list in /proc/<pid>/status.

Number 32 comes from the internal NGROUPS_SMALL macro which defines the
length for the internal kernel "small" groups buffer.  There is no
apparent reason to limit to this value.

This patch removes the 32 groups printing limit.

The Linux kernel limits the amount of supplementary groups by NGROUPS_MAX,
which is currently set to 65536.  And this is the maximum count of groups
we may possibly print.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Acked-by: Serge E. Hallyn <serge.hallyn@ubuntu.com>
Acked-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Qiang Huang <h.huangqiang@huawei.com>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Jianguo Wu <wujianguo@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/proc/array.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -204,7 +204,7 @@ static inline void task_state(struct seq
 	group_info = cred->group_info;
 	task_unlock(p);
 
-	for (g = 0; g < min(group_info->ngroups, NGROUPS_SMALL); g++)
+	for (g = 0; g < group_info->ngroups; g++)
 		seq_printf(m, "%d ", GROUP_AT(group_info, g));
 	put_cred(cred);
 


