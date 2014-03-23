Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114AbaCWAkX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 20:40:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:42724 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751877AbaCWAkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 20:40:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,711,1389772800"; 
   d="scan'208";a="497630321"
Date: Sun, 23 Mar 2014 08:40:09 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: [aio] e52ddd946a: xfstests generic/211 fail
Message-ID: <20140323004009.GA13869@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

We noticed xfstests fail and the first bad commit is

commit e52ddd946ab1def55c8282c8b3d0e80403abae12
Author:     Benjamin LaHaise <bcrl@kvack.org>
AuthorDate: Fri Mar 21 14:26:43 2014 -0400

    aio: ensure access to ctx->ring_pages is correctly serialised
    
# good: [dcb99fd9b08cfe1afe426af4d8d3cbc429190f15] Linux 3.14-rc7
git bisect good dcb99fd9b08cfe1afe426af4d8d3cbc429190f15
# bad: [61fabf948117a9f91e679323b49e6a0cf56d25a6] 0day head guard for 'devel-hourly-2014032214'
git bisect bad 61fabf948117a9f91e679323b49e6a0cf56d25a6
# good: [56ba91913d9f2c108be0e33eeb4a473863d91600] Merge 'regulator/topic/bcm590xx' into devel-hourly-2014032214
git bisect good 56ba91913d9f2c108be0e33eeb4a473863d91600
# good: [a3b8ced9d666d7e4da8e4867d58767e8e5e0a7c9] Merge 'kees/nak_fw-relative' into devel-hourly-2014032214
git bisect good a3b8ced9d666d7e4da8e4867d58767e8e5e0a7c9
# bad: [7a74b3c608ebb48fd99791f570c24387104dd425] Merge 'kees/nak_recv-leak' into devel-hourly-2014032214
git bisect bad 7a74b3c608ebb48fd99791f570c24387104dd425
# good: [4b518d474c67c909d82f4ed6242dee38a681daf8] Merge 'ath6kl/ath-next-test' into devel-hourly-2014032214
git bisect good 4b518d474c67c909d82f4ed6242dee38a681daf8
# good: [37e32762b783f435265c1a8a86dd074c81ad87f2] Merge 'spi/for-next' into devel-hourly-2014032214
git bisect good 37e32762b783f435265c1a8a86dd074c81ad87f2
# bad: [655a90c342c5878de4a3fef60b1a7a0cd18bc08c] Merge 'aio-next/master' into devel-hourly-2014032214
git bisect bad 655a90c342c5878de4a3fef60b1a7a0cd18bc08c
# good: [v3.14-rc6] Linux 3.14-rc6
git bisect good v3.14-rc6
# bad: [e52ddd946ab1def55c8282c8b3d0e80403abae12] aio: ensure access to ctx->ring_pages is correctly serialised
git bisect bad e52ddd946ab1def55c8282c8b3d0e80403abae12
# good: [v3.14-rc6] Linux 3.14-rc6
git bisect good v3.14-rc6
# bad: [e52ddd946ab1def55c8282c8b3d0e80403abae12] aio: ensure access to ctx->ring_pages is correctly serialised
git bisect bad e52ddd946ab1def55c8282c8b3d0e80403abae12
# good: [e6a4b6f5eaa8478b7a0b9a17e40c51463631db1a] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs
git bisect good e6a4b6f5eaa8478b7a0b9a17e40c51463631db1a
# good: [8712a00514e50aafa7c9bf5cd3955fa60758e53b] Merge branch 'akpm' (patches from Andrew Morton)
git bisect good 8712a00514e50aafa7c9bf5cd3955fa60758e53b
# first bad commit: [e52ddd946ab1def55c8282c8b3d0e80403abae12] aio: ensure access to ctx->ring_pages is correctly serialised

Thanks,
Fengguang
