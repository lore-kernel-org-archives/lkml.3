Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751665AbaIJNcb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 09:32:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65315 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634AbaIJNca (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 09:32:30 -0400
Date: Wed, 10 Sep 2014 14:29:33 +0100
From: Aaron Tomlin <atomlin@redhat.com>
To: Chuck Ebbert <cebbert.lkml@gmail.com>
Cc: peterz@infradead.org, mingo@redhat.com, dzickus@redhat.com, bmr@redhat.com,
        jcastillo@redhat.com, oleg@redhat.com, pzijlstr@redhat.com,
        riel@redhat.com, prarit@redhat.com, jgh@redhat.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, x86@kernel.org,
        rostedt@goodmis.org, hannes@cmpxchg.org,
        aneesh.kumar@linux.vnet.ibm.com, akpm@linux-foundation.org,
        akpm@google.com, linuxppc-dev@lists.ozlabs.org, minchan@kernel.org
Subject: Re: [PATCH v2 1/3] init/main.c: Give init_task a canary
Message-ID: <20140910132933.GG1436@atomlin.usersys.redhat.com>
References: <20140904161124.GD1436@atomlin.usersys.redhat.com>
 <1410255749-2956-1-git-send-email-atomlin@redhat.com>
 <1410255749-2956-2-git-send-email-atomlin@redhat.com>
 <20140910022654.29abc9f3@as>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140910022654.29abc9f3@as>
X-PGP-Key: http://pgp.mit.edu/pks/lookup?search=atomlin%40redhat.com
X-PGP-Fingerprint: 7906 84EB FA8A 9638 8D1E  6E9B E2DE 9658 19CC 77D6
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 02:26:54AM -0500, Chuck Ebbert wrote:
> On Tue,  9 Sep 2014 10:42:27 +0100
> Aaron Tomlin <atomlin@redhat.com> wrote:
> 
> > +void task_stack_end_magic(struct task_struct *tsk)
> > +{
> > +	unsigned long *stackend;
> > +
> > +	stackend = end_of_stack(tsk);
> > +	*stackend = STACK_END_MAGIC;	/* for overflow detection */
> > +}
> > +
> 
> For clarity this should probably be called set_task_stack_end_magic().

Agreed.

> And has this been tested on parisc and metag, which use STACK_GROWSUP ?
> I can't see how end_of_stack() as it's defined now could work on those archs.

AFAIU, dup_task_struct() has always done this explicitly.
I see no reason why init_task requires special attention.

-- 
Aaron Tomlin
