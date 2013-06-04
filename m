Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755750Ab3FDRiz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 13:38:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50829 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754464Ab3FDRix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 13:38:53 -0400
Date: Tue, 4 Jun 2013 19:35:00 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Michal Hocko <mhocko@suse.cz>, Sergey Dyasly <dserrg@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] proc: avoid ->f_pos overflows in
	proc_task_readdir() paths
Message-ID: <20130604173500.GB22223@redhat.com>
References: <20130603190640.GA11481@redhat.com> <20130603190705.GA11517@redhat.com> <20130604005853.GA13110@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130604005853.GA13110@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04, Al Viro wrote:
>
> On Mon, Jun 03, 2013 at 09:07:05PM +0200, Oleg Nesterov wrote:
> > 1. proc_task_readdir() truncates f_pos to long, this can lead
> >    to wrong result on 32bit.
> >
> > 2. first_tid() truncates f_pos to int, this is wrong even on
> >    64bit.
> >
> >    We could check that f_pos < PID_MAX or even INT_MAX in
> >    proc_task_readdir(), but this patch simply checks the
> >    potential overflow in first_tid(), this check is nop on
> >    64bit. We do not care if it was negative and the new
> >    unsigned value is huge, all we need to ensure is that we
> >    never wrongly return !NULL.
> >
> > 3. Remove the 2nd "nr != 0" check before get_nr_threads(),
> >    nr_threads == 0 is not distinguishable from !pid_task()
> >    above.
>
> Oleg, please take a look at the series in vfs.git#experimental; at the very
> least, we don't want to access file->f_pos in any foo_readdir() - it's too
> messy and race-prone.  It's pretty much independent from the issues you
> are dealing with, but let's avoid creating pointless conflicts...

Yes, thanks.

Sadly, 3/4 conflicts with 08c35e10 too. I'll rediff/resend this
cleanup later then.

Oleg.

