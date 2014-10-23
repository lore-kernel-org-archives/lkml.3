Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932502AbaJWTlD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 15:41:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44775 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932071AbaJWTlC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 15:41:02 -0400
Date: Thu, 23 Oct 2014 21:37:06 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Alex Thorlton <athorlton@sgi.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Bob Liu <lliubbo@gmail.com>, David Rientjes <rientjes@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Mel Gorman <mgorman@suse.de>, Peter Zijlstra <peterz@infradead.org>,
        Rik van Riel <riel@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Vladimir Davydov <vdavydov@parallels.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] Add pgcollapse controls to task_struct
Message-ID: <20141023193706.GB6751@redhat.com>
References: <1414089963-73165-1-git-send-email-athorlton@sgi.com> <1414089963-73165-3-git-send-email-athorlton@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414089963-73165-3-git-send-email-athorlton@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23, Alex Thorlton wrote:
>
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1661,6 +1661,18 @@ struct task_struct {
>  	unsigned int	sequential_io;
>  	unsigned int	sequential_io_avg;
>  #endif
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +	struct callback_head pgcollapse_work;
> +	/* default scan 8*512 pte (or vmas) every 30 second */
> +	unsigned int pgcollapse_pages_to_scan;
> +	unsigned int pgcollapse_pages_collapsed;
> +	unsigned int pgcollapse_full_scans;
> +	unsigned int pgcollapse_scan_sleep_millisecs;
> +	/* during fragmentation poll the hugepage allocator once every minute */
> +	unsigned int pgcollapse_alloc_sleep_millisecs;
> +	unsigned long pgcollapse_last_scan;
> +	unsigned long pgcollapse_scan_address;
> +#endif

Shouldn't this all live in mm_struct?

Except pgcollapse_work can't, exit_mm() called before exit_mm(). Probably
it can be allocated.

Oleg.

