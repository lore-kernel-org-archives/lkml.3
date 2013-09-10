Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146Ab3IJOHg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 10:07:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15371 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348Ab3IJOHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 10:07:35 -0400
Date: Tue, 10 Sep 2013 16:01:23 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] pidns: fix free_pid() to handle the first fork failure
Message-ID: <20130910140123.GA30152@redhat.com>
References: <20130829211114.GA20726@sergelap> <87mwo0xb9p.fsf@xmission.com> <20130830144232.GA18281@mail.hallyn.com> <87hae6vh0w.fsf_-_@xmission.com> <20130908175602.GA3172@redhat.com> <20130908180137.GA4915@redhat.com> <87bo43gg4h.fsf@xmission.com> <20130909151530.GA6755@redhat.com> <87bo41j2x9.fsf@tw-ebiederman.twitter.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bo41j2x9.fsf@tw-ebiederman.twitter.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09, Eric W. Biederman wrote:
>
> Oleg Nesterov <oleg@redhat.com> writes:
> >
> > Agreed, it also makes sense to clear ->nr_hashed. But I still think
> > that WARN_ON(ns->child_reaper) makes sense too.
>
> I don't know that I like warnings for impossible conditions.

But WARN_ON() should only check for "impossible" conditions ;)

> How could
> we even make a mistake that gets us there?

I do not know! I mean, this should not happen, that is why it adds
a warning.

And note that "ns->nr_hashed = 0" is not really needed, still I agree
it makes sense.

However I won't mind to remove this warning if you really dislike it.

> >> At which point I ask myself what of the pathlogocical case where the
> >> first fork fails but because we created the pid namespace with unshare
> >> there is a concurrent fork from another process into the pid namespace
> >> that succeeds.  Resulting in one pid in the pid namespace that is not
> >> the reaper.
> >
> > But how can setns() work before the first fork() succeeds and makes the
> > ->child_reaper visible in /proc ?
> >
> > Probably I missed something obvious, I didn't sleep today...
>
> Actually that is a very good point.  That is an accidental feature but
> one I very much appreciate today.

OK. Please review v2 then. I also shamelessly stole your comment.

Oleg.

