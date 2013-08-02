Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853Ab3HBUKN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 16:10:13 -0400
Received: from mga01.intel.com ([192.55.52.88]:32712 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753031Ab3HBUKL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 16:10:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,803,1367996400"; 
   d="scan'208";a="380367677"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Alex Thorlton <athorlton@sgi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Jones <davej@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Al Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Kees Cook <keescook@chromium.org>, Robin Holt <holt@sgi.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20130802194659.GP26476@sgi.com>
References: <20130802194659.GP26476@sgi.com>
Subject: RE: [PATCH] Add per-process flag to control thp
Content-Transfer-Encoding: 7bit
Message-Id: <20130802201301.A872BE0090@blue.fi.intel.com>
Date: Fri,  2 Aug 2013 23:13:01 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Thorlton wrote:
> This patch implements functionality to allow processes to disable the use of
> transparent hugepages through the prctl syscall.
> 
> We've determined that some jobs perform significantly better with thp disabled,
> and we need a way to control thp on a per-process basis, without relying on
> madvise.

What kind of workloads are you talking about?

What's wrong with madvise? Could you elaborate?

And I think thp_disabled should be reset to 0 on exec.

-- 
 Kirill A. Shutemov
