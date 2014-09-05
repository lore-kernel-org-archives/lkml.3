Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939AbaIELix (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 07:38:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25135 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756622AbaIELiu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 07:38:50 -0400
Date: Fri, 5 Sep 2014 13:35:53 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Hugh Dickins <hughd@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Kautuk Consul <consul.kautuk@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, David Rientjes <rientjes@google.com>,
        Ionut Alexa <ionut.m.alexa@gmail.com>,
        Guillaume Morin <guillaume@morinfr.org>, linux-kernel@vger.kernel.org,
        Kirill Tkhai <tkhai@yandex.ru>
Subject: Re: task_numa_fault() && TASK_DEAD
Message-ID: <20140905113553.GA24717@redhat.com>
References: <20140825155738.GA5944@redhat.com> <20140901153935.GQ27892@worktop.ger.corp.intel.com> <20140901175851.GA15210@redhat.com> <20140901190931.GD5806@worktop.ger.corp.intel.com> <20140902155208.GA28668@redhat.com> <20140902164714.GA17033@redhat.com> <20140903160819.GA7682@redhat.com> <20140904071139.GH3190@worktop.ger.corp.intel.com> <20140904103949.GA19300@redhat.com> <alpine.LSU.2.11.1409041210400.12218@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1409041210400.12218@eggly.anvils>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04, Hugh Dickins wrote:
>
> On Thu, 4 Sep 2014, Oleg Nesterov wrote:
> > On 09/04, Peter Zijlstra wrote:
> > > On Wed, Sep 03, 2014 at 06:08:19PM +0200, Oleg Nesterov wrote:
> > >
> > > > And a stupid (really, I don't understand this code) question:
> > > >
> > > > 	/* for example, ksmd faulting in a user's mm */
> > > > 	if (!p->mm)
> > > > 		return;
>
> I don't understand your difficulty with that, I thought the comment
> was helpful enough.

Yes, yes, sorry for confusion, the comment and the check itself look clear.

> Does the original commit comment help?
>
> commit 2832bc19f6668fd00116f61f821105040599ef8b
> Author: Hugh Dickins <hughd@google.com>
> Date:   Wed Dec 19 17:42:16 2012 -0800
>
>     sched: numa: ksm: fix oops in task_numa_placment()
>
>     task_numa_placement() oopsed on NULL p->mm

Yes. But I thought that even if task_numa_placment() didn't OOPS in case
when ->mm = NULL, it would be better to exclude ksmd. And other kthreads
which can have ->mm != NULL, and PTRACE_POKE or sys_process_vm_writev()
users:

	/* do nothing if this task accesses a foreign mm */
	if (p->mm != mm || (p->flags & PF_KTHREAD)
		return;

Please forget. This is minor, and my main question was the wrong usage
of TASK_DEAD.

Oleg.

