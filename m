Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756AbaJPVrN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 17:47:13 -0400
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:55853
	"EHLO mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbaJPVrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 17:47:11 -0400
Date: Thu, 16 Oct 2014 23:47:10 +0200
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Aditya Kali <adityakali@google.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, Serge Hallyn <serge.hallyn@ubuntu.com>,
        Andy Lutomirski <luto@amacapital.net>, cgroups@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Rohit Jnagal <jnagal@google.com>
Subject: Re: [PATCHv1 7/8] cgroup: cgroup namespace setns support
Message-ID: <20141016214710.GA4759@mail.hallyn.com>
References: <1413235430-22944-1-git-send-email-adityakali@google.com>
 <1413235430-22944-8-git-send-email-adityakali@google.com>
 <20141016211236.GA4308@mail.hallyn.com>
 <CAGr1F2EH0ynfFihTh1dv=n1faxUh0zS3ggk303bwGnDnW2PUCw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGr1F2EH0ynfFihTh1dv=n1faxUh0zS3ggk303bwGnDnW2PUCw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Aditya Kali (adityakali@google.com):
> On Thu, Oct 16, 2014 at 2:12 PM, Serge E. Hallyn <serge@hallyn.com> wrote:
> > Quoting Aditya Kali (adityakali@google.com):
> >> setns on a cgroup namespace is allowed only if
> >> * task has CAP_SYS_ADMIN in its current user-namespace and
> >>   over the user-namespace associated with target cgroupns.
> >> * task's current cgroup is descendent of the target cgroupns-root
> >>   cgroup.
> >
> > What is the point of this?
> >
> > If I'm a user logged into
> > /lxc/c1/user.slice/user-1000.slice/session-c12.scope and I start
> > a container which is in
> > /lxc/c1/user.slice/user-1000.slice/session-c12.scope/x1
> > then I will want to be able to enter the container's cgroup.
> > The container's cgroup root is under my own (satisfying the
> > below condition0 but my cgroup is not a descendent of the
> > container's cgroup.
> >
> This condition is there because we don't want to do implicit cgroup
> changes when a process attaches to another cgroupns. cgroupns tries to
> preserve the invariant that at any point, your current cgroup is
> always under the cgroupns-root of your cgroup namespace. But in your
> example, if we allow a process in "session-c12.scope" container to
> attach to cgroupns root'ed at "session-c12.scope/x1" container
> (without implicitly moving its cgroup), then this invariant won't
> hold.

Oh, I see.  Guess that should be workable.  Thanks.

-serge
