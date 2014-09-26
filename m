Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533AbaIZHEo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 03:04:44 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:7401 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293AbaIZHEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 03:04:42 -0400
Message-ID: <54250FF4.1030400@huawei.com>
Date: Fri, 26 Sep 2014 15:04:20 +0800
From: zhangzhiqiang <zhangzhiqiang.zhang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: <gregkh@linuxfoundation.org>, <lizefan@huawei.com>, <wangnan0@huawei.com>,
        <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [request for stable inclusion] perf kmem: Make it work again on non
 NUMA machines
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.58.157]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi all,

Now on non NUMA machines with 3.10 stable,perf kmem command does not work well. For instance,
when exec perf kmem record sleep 2, we can get the perf.data file correctly. but when we exec
perf kmem stat there is nothing return.
In upstream the bug has been fixed and perf kmem work well on non NUMA machines.

Can we cherry-pick it to stable repo.

The commit id is 4921e320244e099bdf237fd10428594ce5f5b87d,the detail as follows:

commit 4921e320244e099bdf237fd10428594ce5f5b87d
Author: Jiri Olsa <jolsa@redhat.com>
Date:   Thu Sep 12 18:39:36 2013 +0200

    perf kmem: Make it work again on non NUMA machines

    The commit '2814eb0 perf kmem: Remove die() calls' disabled 'perf kmem'
    command for machines without numa support. It made the command fail if
    '/sys/devices/system/node' dir wasn't found.

    Skipping the numa based initialization in case the directory is not
    found and continue execution.

    Signed-off-by: Jiri Olsa <jolsa@redhat.com>
    Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
    Cc: Frederic Weisbecker <fweisbec@gmail.com>
    Cc: Namhyung Kim <namhyung@kernel.org>
    Cc: Paul Mackerras <paulus@samba.org>
    Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Link: http://lkml.kernel.org/r/1379003976-5839-5-git-send-email-jolsa@redhat.com
    Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index c2dff9c..9b5f077 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -101,7 +101,7 @@ static int setup_cpunode_map(void)

        dir1 = opendir(PATH_SYS_NODE);
        if (!dir1)
-           return -1;
+         return 0;

        while ((dent1 = readdir(dir1)) != NULL) {
                if (dent1->d_type != DT_DIR ||



