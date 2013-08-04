Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312Ab3HDOoZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 10:44:25 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:38987 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075Ab3HDOoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 10:44:23 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
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
        Kees Cook <keescook@chromium.org>, Robin Holt <holt@sgi.com>
Subject: Re: [PATCH] Add per-process flag to control thp
Organization: D03
References: <20130802194659.GP26476@sgi.com>
X-Hashcash: 1:20:130804:hannes@cmpxchg.org::8L+0hbEgUj/JpcOH:00000000000000000000000000000000000000000000v7K
X-Hashcash: 1:20:130804:srikar@linux.vnet.ibm.com::NCQEUpfuNoitVbeb:0000000000000000000000000000000000000OfP
X-Hashcash: 1:20:130804:viro@zeniv.linux.org.uk::1zZ1PB6jNrmJ7sx+:000000000000000000000000000000000000000DZZ
X-Hashcash: 1:20:130804:tglx@linutronix.de::10YiRcfQM1JwZ1hA:00000000000000000000000000000000000000000000MT5
X-Hashcash: 1:20:130804:dhowells@redhat.com::e7AtfjFf0eAX+GCk:0000000000000000000000000000000000000000000iYj
X-Hashcash: 1:20:130804:mingo@redhat.com::gMlNYW01SybMIoH1:00oCJ
X-Hashcash: 1:20:130804:linux-kernel@vger.kernel.org::DX0av0LjlfgNHWIN:00000000000000000000000000000000009wG
X-Hashcash: 1:20:130804:mtk.manpages@gmail.com::NSF8rfXcVl9Fe66J:0000000000000000000000000000000000000001FRL
X-Hashcash: 1:20:130804:mgorman@suse.de::rj85nWo+7vZ/1oUp:001Qv1
X-Hashcash: 1:20:130804:oleg@redhat.com::1mGE+KjtQY2N5a7s:001aBf
X-Hashcash: 1:20:130804:kirill.shutemov@linux.intel.com::YS6OSsK2GvaJOKrD:0000000000000000000000000000001qDy
X-Hashcash: 1:20:130804:athorlton@sgi.com::vGIacwnNNziL/5eq:000000000000000000000000000000000000000000002AVv
X-Hashcash: 1:20:130804:peterz@infradead.org::/a49G/beEBRDbJOp:000000000000000000000000000000000000000002WPt
X-Hashcash: 1:20:130804:akpm@linux-foundation.org::EZ6b3VN+mR/OgNz2:00000000000000000000000000000000000034BF
X-Hashcash: 1:20:130804:sedat.dilek@gmail.com::jraIqcBB4ipz/j/Q:00000000000000000000000000000000000000003wux
X-Hashcash: 1:20:130804:paulmck@linux.vnet.ibm.com::VmK+VwjRyXMyyl5r:000000000000000000000000000000000003nb9
X-Hashcash: 1:20:130804:fweisbec@gmail.com::8bgpNIYTSWGmm5/s:00000000000000000000000000000000000000000004GT1
X-Hashcash: 1:20:130804:davej@redhat.com::DC9oy0/bjRSd5ho7:054w5
X-Hashcash: 1:20:130804:holt@sgi.com::sXWcauk+40WCby40:000005XKP
X-Hashcash: 1:20:130804:keescook@chromium.org::vYy+plMuWtM3BiCz:00000000000000000000000000000000000000007+kx
X-Hashcash: 1:20:130804:ebiederm@xmission.com::VlyWJqLGhYhViCHy:00000000000000000000000000000000000000007W9L
X-Hashcash: 1:20:130804:riel@redhat.com::RvIAIbZy4JeChQZd:00AXlb
Date: Sun, 04 Aug 2013 14:44:17 +0000
In-Reply-To: <20130802194659.GP26476@sgi.com> (Alex Thorlton's message of
	"Fri, 2 Aug 2013 14:46:59 -0500")
Message-ID: <878v0hplby.fsf@rasmusvillemoes.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Thorlton <athorlton@sgi.com> writes:

> This patch implements functionality to allow processes to disable the use of
> transparent hugepages through the prctl syscall.

A few comments: 

Is there a reason it shouldn't be possible for a process to un-disable/reenable thp? 

> +static inline int transparent_hugepage_enabled(struct vm_area_struct *vma)
> +{
> +	return !current->thp_disabled & _transparent_hugepage_enabled(vma);
> +}

Should probably be &&.

> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 50d04b9..f084c76 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1406,6 +1406,9 @@ struct task_struct {
>  	unsigned int	sequential_io;
>  	unsigned int	sequential_io_avg;
>  #endif
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +	int thp_disabled;
> +#endif
>  };

Is there a reason this needs a whole int in task_struct and not just
a single bit?

Rasmus
