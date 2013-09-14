Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281Ab3INSPI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 14:15:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25769 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754179Ab3INSPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 14:15:05 -0400
Date: Sat, 14 Sep 2013 20:08:52 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steve Grubb <sgrubb@redhat.com>
Cc: linux-audit@redhat.com, Richard Guy Briggs <rgb@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: audit looks unmaintained? [was: Re: [PATCH 11/12] pid: rewrite
	task helper functions avoiding task->pid and task->tgid]
Message-ID: <20130914180852.GA24970@redhat.com>
References: <cover.1377032086.git.rgb@redhat.com> <3996102.evTQ9SbNnV@x2> <20130908155435.GC4663@redhat.com> <3158155.5GaQBOllp8@x2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3158155.5GaQBOllp8@x2>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13, Steve Grubb wrote:
>
> On Sunday, September 08, 2013 05:54:35 PM Oleg Nesterov wrote:
> >
> > Then why audit_alloc() doesn't set TIF_SYSCALL_AUDIT unconditionally?
>
> The code I'm looking at does right at the end of the function.

The code I'm looking at does right at the end too ;) but it also
returns at the start if audit_filter_task() returns AUDIT_DISABLED.

> > And I do not understand "when context == NULL" above. Say,
> > audit_syscall_entry() does nothing if !audit_context, and nobody except
> > copy_process() does audit_alloc(). So why do we need to trigger the audit's
> > paths if it is NULL?
>
> Because if you enter the audit framework,

framework? TIF_SYSCALL_AUDIT has only meaning in entry.S, we need it
to ensure that the audited task can't miss audit_syscall_*().

> that means auditing has been turned
> on at some point in the past, and could be turned back on at some point in the
> future.

And this will change nothing, afaics (wrt TIF_SYSCALL_AUDIT).

Oleg.

