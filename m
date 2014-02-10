Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869AbaBJLhh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 06:37:37 -0500
Received: from mga09.intel.com ([134.134.136.24]:63583 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752174AbaBJLhe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 06:37:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,817,1384329600"; 
   d="scan'208";a="472709247"
Date: Mon, 10 Feb 2014 19:37:32 +0800
From: kernel test robot <fengguang.wu@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [userns] 6e9f18123077: xfstests generic/317,318 TFAIL
Message-ID: <20140210113732.GD11951@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

FYI, we noticed xfstests generic/317 and generic/318 TFAILs in

git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace.git userns-always-map-user-v151

commit 6e9f18123077643a3b88c092c865cc6905f2d90d
Author:     Eric W. Biederman <ebiederm@xmission.com>
AuthorDate: Mon Feb 3 15:40:35 2014 -0800
Commit:     Eric W. Biederman <ebiederm@xmission.com>
CommitDate: Thu Feb 6 18:42:56 2014 -0800

    userns:  Don't allow more user namespaces than pids.
    
    To prevent denial of service attacks and general foolishness limit the
    total number of user namespaces to the maximum number of pids we allow.
    
    We may want to make the limit dynamic later but for now make the limit
    the maximum number of pids our kernel can be configured to support.
    
    Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>

 kernel/user_namespace.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

# good: [38dbfb59d1175ef458d006556061adeaa8751b72] Linus 3.14-rc1
git bisect good 38dbfb59d1175ef458d006556061adeaa8751b72
# bad: [7c4f56c0167ab5bf4cfa8c51c279f8a86d3bf7d0] 0day head guard for 'devel-hourly-2014020717'
git bisect bad 7c4f56c0167ab5bf4cfa8c51c279f8a86d3bf7d0
# good: [3b80e366643eb774a6aaa89091129529d6be92af] Merge 'tip/x86/urgent' into devel-hourly-2014020717
git bisect good 3b80e366643eb774a6aaa89091129529d6be92af
# good: [668abb889ee1326eda659b546d6086b0156efa09] Merge 'trace/ftrace/core' into devel-hourly-2014020717
git bisect good 668abb889ee1326eda659b546d6086b0156efa09
# good: [575877fbe7b25b1ae1461b384c28f454457f9955] Merge 'spi/for-next' into devel-hourly-2014020717
git bisect good 575877fbe7b25b1ae1461b384c28f454457f9955
# bad: [7c5f6b4dfe9ac34586a96e323e0135edce43c41c] Merge 'dhowells-fs/fscache' into devel-hourly-2014020717
git bisect bad 7c5f6b4dfe9ac34586a96e323e0135edce43c41c
# bad: [c5d14676653d58df4a4dcbe7e2e01414d7e2eed8] Merge 'userns/userns-always-map-user-v151' into devel-hourly-2014020717
git bisect bad c5d14676653d58df4a4dcbe7e2e01414d7e2eed8
# good: [v3.14-rc1] Linus 3.14-rc1
git bisect good v3.14-rc1
# bad: [d7eb936fa850669c4bc17780ab47f0f6fd8903c9] fdtable: Avoid triggering OOMs from alloc_fdmem
git bisect bad d7eb936fa850669c4bc17780ab47f0f6fd8903c9
# good: [v3.14-rc1] Linus 3.14-rc1
git bisect good v3.14-rc1
# bad: [d7eb936fa850669c4bc17780ab47f0f6fd8903c9] fdtable: Avoid triggering OOMs from alloc_fdmem
git bisect bad d7eb936fa850669c4bc17780ab47f0f6fd8903c9
# good: [b39b3f1f2aeda8b70900881d2202b7d424365fb2] pid: Modify is_idle_task to test pid pointers instead of pid numbers
git bisect good b39b3f1f2aeda8b70900881d2202b7d424365fb2
# good: [d8ee4242a90a5205bfb47f979295257117da4612] keys: In keyctl_session_to_parent by more explicit about invalid parents
git bisect good d8ee4242a90a5205bfb47f979295257117da4612
# good: [3e27cd90f82df0fe5e00358fe3b48d13efee7b88] proc:  Remove hard coded magic number
git bisect good 3e27cd90f82df0fe5e00358fe3b48d13efee7b88
# good: [49701868f32410737aa2964374d60eac365b5215] sysctl: Attempt to handle deletion of sysctl with submounts
git bisect good 49701868f32410737aa2964374d60eac365b5215
# good: [a2c004614a7f8d3ce830442ee7cc5c26101f563d] vfs: Modify prepend_name to return a pointer
git bisect good a2c004614a7f8d3ce830442ee7cc5c26101f563d
# good: [6bd028500e699991e8e118726566c1141dd61fe0] vfs: Comment what a positive error code in prepend_path means
git bisect good 6bd028500e699991e8e118726566c1141dd61fe0
# bad: [6e9f18123077643a3b88c092c865cc6905f2d90d] userns:  Don't allow more user namespaces than pids.
git bisect bad 6e9f18123077643a3b88c092c865cc6905f2d90d
# first bad commit: [6e9f18123077643a3b88c092c865cc6905f2d90d] userns:  Don't allow more user namespaces than pids.

Thanks,
Fengguang
