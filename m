Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402Ab3GBVzd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 17:55:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13010 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752453Ab3GBVzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 17:55:32 -0400
Date: Tue, 2 Jul 2013 17:55:19 -0400
From: Luiz Capitulino <lcapitulino@redhat.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, mhocko@suse.cz,
        minchan@kernel.org, anton@enomsg.org, akpm@linux-foundation.org
Subject: Re: [PATCH] vmpressure: implement strict mode
Message-ID: <20130702175519.16148e5c@redhat.com>
In-Reply-To: <20130702194703.GA19373@amd.pavel.ucw.cz>
References: <20130625175129.7c0d79e1@redhat.com>
	<20130701085103.GA19798@amd.pavel.ucw.cz>
	<20130702110628.5dbb75e0@redhat.com>
	<20130702194703.GA19373@amd.pavel.ucw.cz>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Jul 2013 21:47:03 +0200
Pavel Machek <pavel@ucw.cz> wrote:

> On Tue 2013-07-02 11:06:28, Luiz Capitulino wrote:
> > On Mon, 1 Jul 2013 10:51:03 +0200
> > Pavel Machek <pavel@ucw.cz> wrote:
> > 
> > > Hi!
> > > 
> > > > diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
> > > > index ddf4f93..3c589cf 100644
> > > > --- a/Documentation/cgroups/memory.txt
> > > > +++ b/Documentation/cgroups/memory.txt
> > > > @@ -807,12 +807,14 @@ register a notification, an application must:
> > > >  
> > > >  - create an eventfd using eventfd(2);
> > > >  - open memory.pressure_level;
> > > > -- write string like "<event_fd> <fd of memory.pressure_level> <level>"
> > > > +- write string like "<event_fd> <fd of memory.pressure_level> <level> [strict]"
> > > >    to cgroup.event_control.
> > > >  
> > > 
> > > This is.. pretty strange interface. Would it be cleaner to do ioctl()?
> > > New syscall?
> > 
> > Are you referring to my new mode or to the whole thing?
> 
> Well. The interface was already very strange and you made it even
> worse.

The existing interface is the cgroup's notification mechanism, I think
discussing it is a bit out of scope for my extension.

Now, regarding my extension itself and the current vmpressure API, I
believe that delivering all events to user-space (ie. w/o any filtering
in the kernel) is a better solution.

Point is whether we can do it with the current vmpressure API (which
is cgroup based) or whether we should move to something else.
