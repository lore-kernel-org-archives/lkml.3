Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759789Ab3GaO2B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 10:28:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15098 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753117Ab3GaO2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 10:28:00 -0400
Date: Wed, 31 Jul 2013 16:22:36 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [for-next-3.11][PATCH 0/8] ftrace/tracing: Event file fixes
	and ftrace function hash fixes
Message-ID: <20130731142236.GA31073@redhat.com>
References: <20130730112718.273490378@goodmis.org> <20130731114722.GA4416@redhat.com> <1375279617.19999.1.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375279617.19999.1.camel@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31, Steven Rostedt wrote:
>
> On Wed, 2013-07-31 at 13:47 +0200, Oleg Nesterov wrote:
> > On 07/30, Steven Rostedt wrote:
> > >
> > > Using the i_private and event_mutex
> > > to verify that the event still exists to solve the race.
> >
> > To remind, we also need the "debugfs: debugfs_remove_recursive() must
> > not rely on list_empty(d_subdirs)" patch, otherwise we still have the
> > problems with the opened files.
>
> Do these patches depend on that patch?

No,

> Should I rebase to have that
> patch first?

And no.

That patch fixes the buggy debugfs_remove_recursive() and nothing else.

The test-case from the changelog can trigger the problem with or without
the recent changes. You can't (I hope) crash the kernel this way after
these changes, but the undeleted directory is still obviously bad.

Just I think that "open/delete fixes" is not complete without this fix.

Oleg.

