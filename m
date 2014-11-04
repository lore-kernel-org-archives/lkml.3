Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573AbaKDPvB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 10:51:01 -0500
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:51567
	"EHLO mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470AbaKDPu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 10:50:57 -0500
Date: Tue, 4 Nov 2014 16:50:52 +0100
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Tejun Heo <tj@kernel.org>, Linux API <linux-api@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>, cgroups@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCHv2 7/7] cgroup: mount cgroupns-root when inside non-init
 cgroupns
Message-ID: <20141104155052.GA7027@mail.hallyn.com>
References: <1414783141-6947-1-git-send-email-adityakali@google.com>
 <1414783141-6947-8-git-send-email-adityakali@google.com>
 <87y4rvrakn.fsf@x220.int.ebiederm.org>
 <CAGr1F2Hd_PS_AscBGMXdZC9qkHGRUp-MeQvJksDOQkRBB3RGoA@mail.gmail.com>
 <20141104134633.GA14014@htj.dyndns.org>
 <CALCETrUggQCJyxsTWRNrjt3GM=R0VMU6RjMkU1aw3YUNMx1xEw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrUggQCJyxsTWRNrjt3GM=R0VMU6RjMkU1aw3YUNMx1xEw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andy Lutomirski (luto@amacapital.net):
> On Tue, Nov 4, 2014 at 5:46 AM, Tejun Heo <tj@kernel.org> wrote:
> > Hello, Aditya.
> >
> > On Mon, Nov 03, 2014 at 02:43:47PM -0800, Aditya Kali wrote:
> >> I agree that this is effectively bind-mounting, but doing this in kernel
> >> makes it really convenient for the userspace. The process that sets up the
> >> container doesn't need to care whether it should bind-mount cgroupfs inside
> >> the container or not. The tasks inside the container can mount cgroupfs on
> >> as-needed basis. The root container manager can simply unshare cgroupns and
> >> forget about the internal setup. I think this is useful just for the reason
> >> that it makes life much simpler for userspace.
> >
> > If it's okay to require userland to just do bind mounting, I'd be far
> > happier with that.  cgroup mount code is already overcomplicated
> > because of the dynamic matching of supers to mounts when it could just
> > have told userland to use bind mounting.  Doesn't the host side have
> > to set up some of the filesystem layouts anyway?  Does it really
> > matter that we require the host to set up cgroup hierarchy too?
> >
> 
> Sort of, but only sort of.
> 
> You can create a container by unsharing namespaces, mounting
> everything, and then calling pivot_root.  But this is unpleasant
> because of the strange way that pid namespaces work -- you generally
> have to fork first, so this gets tedious.  And it doesn't integrate
> well with things like fstab or other container-side configuration
> mechanisms.
> 
> It's nicer if you can unshare namespaces, mount the bare minimum,
> pivot_root, and let the contained software do as much setup as
> possible.

Also, the bind-mount requires the container manager to know where
the guest distro will want the cgroups mounted.

-serge
