Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab3JFANx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 20:13:53 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:33576 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592Ab3JFANv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 20:13:51 -0400
Date: Sat, 05 Oct 2013 19:13:48 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [RFC][PATCH 0/3] vfs: Detach mounts on unlink.
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <87li281wx6.fsf_-_@xmission.com> <1381014462.1974.162@driftwood>
	<20131005231915.GW13318@ZenIV.linux.org.uk>
In-Reply-To: <20131005231915.GW13318@ZenIV.linux.org.uk> (from
	viro@ZenIV.linux.org.uk on Sat Oct  5 18:19:15 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1381018428.1974.165@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2013 06:19:15 PM, Al Viro wrote:
> On Sat, Oct 05, 2013 at 06:07:42PM -0500, Rob Landley wrote:
> > A todo item I've had _forever_ is fixing chroot() to not be broken
> > so that you can trivially break out of a chroot via:
> >
> >   chdir("/");
> >   mkdir("sub");
> >   chroot("sub");
> >   chdir("./../../../../../../../..");
> >
> > (Because chroot() affects where "/" points but NOT where "." points
> > to, and chdir does an == check with the dentry "/" points at to know
> > when to stop, so if you move "/" under "." you can back up to the
> > actual root of the tree.)
> >
> > The above is why lxc uses pivot_root() instead of chroot().
> >
> > These days, we have multiple mount trees so there's no reason
> > chroot() can't trim the process local mount tree (creating a new
> > bind mount if necessary). Except my todo list runneth over and I
> > haven't had a chance to dig in and see what would be involved. (Last
> > time I brought this up people were wondering why chroot() didn't
> > just move "." to the new "/" if it wasn't under it. I had no idea,
> > still don't.)
> 
> 1) RTFUNIXFAQ.  chroot() never has been root-proof.
> 
> 2) your "fix" isn't - it will lead to mounts done by chrooted process
> not affecting other processes in the same namespace.

So if I write a lightweight container setup command, I need to use  
pivot_root just like lxc does?

Rob