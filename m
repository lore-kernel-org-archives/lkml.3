Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668AbaJ1MNE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 08:13:04 -0400
Received: from mga09.intel.com ([134.134.136.24]:47493 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751700AbaJ1MNC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 08:13:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,802,1406617200"; 
   d="scan'208";a="597602675"
From: Andi Kleen <andi@firstfloor.org>
To: Alex Thorlton <athorlton@sgi.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Bob Liu <lliubbo@gmail.com>, David Rientjes <rientjes@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Mel Gorman <mgorman@suse.de>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vladimir Davydov <vdavydov@parallels.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] Convert khugepaged to a task_work function
References: <1414032567-109765-1-git-send-email-athorlton@sgi.com>
Date: Tue, 28 Oct 2014 05:12:26 -0700
In-Reply-To: <1414032567-109765-1-git-send-email-athorlton@sgi.com> (Alex
	Thorlton's message of "Wed, 22 Oct 2014 21:49:23 -0500")
Message-ID: <87lho0pf4l.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Thorlton <athorlton@sgi.com> writes:

> Last week, while discussing possible fixes for some unexpected/unwanted behavior
> from khugepaged (see: https://lkml.org/lkml/2014/10/8/515) several people
> mentioned possibly changing changing khugepaged to work as a task_work function
> instead of a kernel thread.  This will give us finer grained control over the
> page collapse scans, eliminate some unnecessary scans since tasks that are
> relatively inactive will not be scanned often, and eliminate the unwanted
> behavior described in the email thread I mentioned.

With your change, what would happen in a single threaded case?

Previously one core would scan and another would run the workload.
With your change both scanning and running would be on the same
core.

Would seem like a step backwards to me.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
