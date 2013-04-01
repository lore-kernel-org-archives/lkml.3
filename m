Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758366Ab3DAWDT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 18:03:19 -0400
Received: from mail-da0-f43.google.com ([209.85.210.43]:62142 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757295Ab3DAWDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 18:03:17 -0400
Date: Mon, 1 Apr 2013 15:03:09 -0700
From: Tejun Heo <tj@kernel.org>
To: Tim Hockin <thockin@hockin.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Paul Menage <paul@paulmenage.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Containers <containers@lists.linux-foundation.org>,
        Glauber Costa <glommer@gmail.com>, Cgroups <cgroups@vger.kernel.org>,
        Daniel J Walsh <dwalsh@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Max Kellermann <mk@cm4all.com>,
        Mandeep Singh Baines <msb@chromium.org>
Subject: Re: [PATCH 00/10] cgroups: Task counter subsystem v8
Message-ID: <20130401220309.GA2487@htj.dyndns.org>
References: <1328067470-5980-1-git-send-email-fweisbec@gmail.com>
 <CAAAKZwv9=NFmt6xj1KF2va1i6=UCvka0YkmdOY9JNUMHDOWpGw@mail.gmail.com>
 <20130401184617.GB31435@htj.dyndns.org>
 <CAAAKZwvemKDLeuKr6wWMUSVczkRVDZKSzYrXXEMcZ8qvcFR0zQ@mail.gmail.com>
 <20130401202943.GC31435@htj.dyndns.org>
 <CAAAKZwuZwN68vtk1qO08GXB_OnQNVtqqp+v_NQfP27W0P_aWZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAAKZwuZwN68vtk1qO08GXB_OnQNVtqqp+v_NQfP27W0P_aWZw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Tim.

On Mon, Apr 01, 2013 at 02:02:06PM -0700, Tim Hockin wrote:
> We run dozens of jobs from dozens users on a single machine.  We
> regularly experience users who leak threads, running into the tens of
> thousands.  We are unable to raise the PID_MAX significantly due to
> some bad, but really thoroughly baked-in decisions that were made a
> long time ago.  What we experience on a daily basis is users

Ummmm.... so that's why you guys can't use kernel memory limit? :(

> complaining about getting a "pthread_create(): resource unavailable"
> error because someone on the machine has leaked.
...
> What I really don't understand is why so much push back?  We have this
> nicely structured cgroup system.  Each cgroup controller's code is
> pretty well partitioned - why would we not want more complete
> functionality built around it?  We accept device drivers for the most
> random, useless crap on the assertion that "if you don't need it,
> don't compile it in".  I can think of a half dozen more really useful,
> cool things we can do with cgroups, but I know the pushback will be
> tremendous, and I just don't grok why.

In general, because it adds to maintenance overhead.  e.g. We've been
trying to make all cgroups follow consistent nesting rules.  We're now
almost there with a couple controllers left.  This one would have been
another thing to do, which is fine if it's necessary but if it isn't
we're just adding up work for no good reason.

More importantly, because cgroup is already plagued with so many bad
design decisions - some from core design decisions - e.g. not being
able to actually identify a resource outside of a context of a task.
Others are added on by each controller going out doing whatever it
wants without thinking about how the whole thing would come together
afterwards - e.g. double accounting between cpu and cpuacct,
completely illogical and unusable hierarchy implementations in
anything other than cpu controllers (they're getting better), and so
on.  Right now it's in a state where there's not many things coherent
about it.  Sure, every controller and feature supports the ones their
makers intended them to but when collected together it's just a mess,
which is one of the common complaints against cgroup.

So, no free-for-all, please.

Thanks.

-- 
tejun
