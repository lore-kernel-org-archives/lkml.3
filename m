Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab3A0SV2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 13:21:28 -0500
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:47747 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754490Ab3A0SVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 13:21:25 -0500
Date: Sun, 27 Jan 2013 18:23:21 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH review 5/6] userns: Allow the userns root to mount
 ramfs.
Message-ID: <20130127182321.GA338@mail.hallyn.com>
References: <87ehh8it9s.fsf@xmission.com>
 <87ip6khe7w.fsf@xmission.com>
 <20130126212918.GG11274@mail.hallyn.com>
 <87bocb5f8a.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bocb5f8a.fsf@xmission.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> "Serge E. Hallyn" <serge@hallyn.com> writes:
> 
> > Quoting Eric W. Biederman (ebiederm@xmission.com):
> >> 
> >> There is no backing store to ramfs and file creation
> >> rules are the same as for any other filesystem so
> >> it is semantically safe to allow unprivileged users
> >> to mount it.
> >> 
> >> The memory control group successfully limits how much
> >> memory ramfs can consume on any system that cares about
> >> a user namespace root using ramfs to exhaust memory
> >> the memory control group can be deployed.
> >
> > But that does mean that to avoid this new type of attack, when handed a
> > new kernel (i.e. by one's distro) one has to explicitly (know about and)
> > configure those limits.  The "your distro should do this for you"
> > argument doesn't seem right.  And I'd really prefer there not be
> > barriers to user namespaces being compiled in when there don't have to
> > be.
> 
> The thing is this really isn't a new type of attack.  There are a lot of

Of course.

> existing methods to exhaust memory with the default configuration on
> most distros.  All this is is a new method to method to implement such
> an attack.

Right.

...

> > What was your thought on the suggestion to only allow FS_USERNS_MOUNT
> > mounts by users confined in a non-init memory cgroup?
> 
> Over design.

Ok.  Fair.

> So shrug.  The mechanisms that I am suggesting people use already exist,
> and appear to have been present long enough to have made it into debian
> stable release February of 2011.

Heh - right, libcgroup does have its problems, but I don't think there
are any problems with the pam module actually.  I'm meant to talk with
the debian maintainer for them soon, will test.

thanks,
-serge
