Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754Ab3HCRHM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 13:07:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44589 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752523Ab3HCRHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 13:07:09 -0400
Date: Sat, 3 Aug 2013 19:01:02 +0200
From: Oleg Nesterov <oleg@redhat.com>
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
        Al Viro <viro@zeniv.linux.org.uk>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Kees Cook <keescook@chromium.org>, Robin Holt <holt@sgi.com>
Subject: Re: [PATCHv2] Add per-process flag to control thp
Message-ID: <20130803170102.GD32568@redhat.com>
References: <20130802205735.GS26476@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130802205735.GS26476@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02, Alex Thorlton wrote:
>
> This patch implements functionality to allow processes to disable the use of
> transparent hugepages through the prctl syscall.
>
> We've determined that some jobs perform significantly better with thp disabled,
> and we needed a way to control thp on a per-process basis, without relying on
> madvise.

Well, I think the changelog should explain why madvise() is bad.

> @@ -1311,6 +1311,10 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>  	p->sequential_io_avg	= 0;
>  #endif
>
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +	p->thp_disabled = current->thp_disabled;
> +#endif

Unneeded. It will be copied by dup_task_struct() automagically.

But I simply can't understand why this flag is per-thread. It should be
mm flag, no?

Oleg

