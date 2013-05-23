Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758890Ab3EWTGi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 15:06:38 -0400
Received: from fieldses.org ([174.143.236.118]:53619 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758071Ab3EWTGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 15:06:37 -0400
Date: Thu, 23 May 2013 15:06:02 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Stanislav Kinsbursky <skinsbursky@parallels.com>, viro@zeniv.linux.org.uk,
        serge.hallyn@canonical.com, jlayton@redhat.com,
        lucas.demarchi@profusion.mobi, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org, oleg@redhat.com, bharrosh@panasas.com,
        linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
        devel@openvz.org
Subject: Re: [RFC PATCH] fs: call_usermodehelper_root helper introduced
Message-ID: <20130523190602.GB10246@fieldses.org>
References: <20130522072840.27720.85023.stgit@localhost.localdomain>
 <878v36ex6n.fsf@xmission.com>
 <87wqqqdfqr.fsf@xmission.com>
 <20130522192339.GB31069@fieldses.org>
 <87vc6abc3w.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87vc6abc3w.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 08:37:23PM -0700, Eric W. Biederman wrote:
> "J. Bruce Fields" <bfields@fieldses.org> writes:
> 
> > On Wed, May 22, 2013 at 11:35:56AM -0700, Eric W. Biederman wrote:
> >> ebiederm@xmission.com (Eric W. Biederman) writes:
> >> 
> >> > I am missing a lot of context here and capturing the context of a
> >> > process at time time we mount the filesystem and reconstituing it in
> >> > call user mode helper seems like something we could do.
> >
> > So it's not enough just to ensure that the user namespace is set
> > correctly?  (To the namespace of the mount process in the nfs case, or
> > of the process that starts nfsd in the nfsd case.)
> 
> No.  By just setting the user namespace, you gain the ability to create
> processes outside of your curremt rlimits, and cgroups, and pid
> namespace, etc.
> 
> With the wrong set of namespaces you will talk to the wrong processes,
> or utilize the wrong resources.
> 
> Outside of your current cgroup you gain the ability to use more
> resources than you were limited to.
> 
> Having thought about it what I would propose is to fork a process from
> the context of the mounting process (or possibly from the context of the
> process that writes to the sysctl that sets the program to spawn) and
> have that process be a daemon that becomes responsible for spawning user
> mode helpers with context.  Either that or whe need the user mode helper
> userspace infrastructure to become namespace aware and call setns.
> 
> >> If we want to do something like this the only sane thing I can see is to
> >> have a per container version of kthread call it uthread.  That the user
> >> mode helper code would use to launch a new process.
> >> 
> >> Anything else and I expect we will be tearing our hair out for the rest
> >> of our lives with weird corner cases or unexpected semantics.
> >
> > Could you give examples of weird corner cases or unexpected semantics?
> 
> I gave a couple and it is the classic problem with suid executables
> where a lot of unexpected things are inherited from the environment, and
> so things become a never ending race.  We replaced daemonize in the
> kernel with just forking processes from kthreadd for this very reason.
> There was always something else that needed to be reset to make a
> process a proper kernel thread.

Got it, thanks for the explanation.

--b.
