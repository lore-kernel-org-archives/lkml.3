Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343AbaE1NND (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 09:13:03 -0400
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:58040
	"EHLO mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230AbaE1NNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 09:13:01 -0400
Date: Wed, 28 May 2014 15:12:59 +0200
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        LXC development mailing-list 
	<lxc-devel@lists.linuxcontainers.org>,
        Serge Hallyn <serge.hallyn@ubuntu.com>, Jens Axboe <axboe@kernel.dk>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [lxc-devel] [RFC PATCH 00/11] Add support for devtmpfs in user
 namespaces
Message-ID: <20140528131259.GA31213@mail.hallyn.com>
References: <20140516140607.GA23902@ubuntu-hedt>
 <20140516185749.GA5131@kroah.com>
 <1400268515.2221.91.camel@dabdike.int.hansenpartnership.com>
 <20140516201841.GC23902@ubuntu-hedt>
 <87mwedfh7c.fsf@x220.int.ebiederm.org>
 <20140520142103.GC137220@ubuntu-hedt>
 <87y4xubxmm.fsf@x220.int.ebiederm.org>
 <20140521223319.GF29211@ubuntumail>
 <87ioow9ls9.fsf@x220.int.ebiederm.org>
 <20140528092655.GD19433@ubuntu-mba51>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140528092655.GD19433@ubuntu-mba51>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Seth Forshee (seth.forshee@canonical.com):
> On Fri, May 23, 2014 at 03:23:50PM -0700, Eric W. Biederman wrote:
> > Serge Hallyn <serge.hallyn@ubuntu.com> writes:
> > 
> > > Quoting Eric W. Biederman (ebiederm@xmission.com):
> > >> 
> > >> 
> > >> >> Ultimately the technical challenge is how do we create a block device
> > >> >> that is safe for a user who does not have any capabilities to use, and
> > >> >> what can we do with that block device to make it useful.
> > >> >
> > >> > Yes, and I'd like to get started solving those challenges. But I also
> > >> > don't think we can address these two points (support partition blkdevs,
> > >> > help prevent more priveleged users from using a namespace's loop
> > >> > devices) sufficiently while having an implementation completely
> > >> > contained within the loop driver as Greg is requesting.
> > >> 
> > >> My key take away from the conversation is that we should reduce the
> > >> scope of what is being done to something that makes sense and the
> > >> propblems are immediately visible.
> > >> 
> > >> Part of me would like to suggest that fuse and it's ability to imitate
> > >> device nodes might be a more appropriate solution, to something that
> > >
> > > Do you have a link to more info on this?  Some googling got me to an
> > > interesting but old thread on CUSE, but nothing specifically about fuse
> > > doing this.
> > 
> > CUSE is probably what I was thinking of.  It is all part of the fuse
> > code base in the kernel.  And now that I am reminded it is called CUSE
> > I go Duh that is a character device...
> > 
> > Fuse and everything it can do is definitely the filesystem I would like
> > to see most have the audits to be enabled in user namespace.  Fuse
> > was built to be sufficiently paranoid to allow this and so it should not
> > take a lot to take fuse the rest of the way.
> 
> I was aware of FUSE but hadn't ever looked at it much. Looking at it
> now, this isn't going to satisfy any of the use cases I know about,
> which are wanting to use filesystems supported in-kernel (isofs, ext*).
> I don't see that any of these have a FUSE implementation, and I think we
> gain more from figuring out how to use in-kernel filesystems in
> containers than trying to find a way to shoehorn selected filesystems
> into FUSE.

That's why I was wondering how much work it would be to auto-generate
fuse fs support from the in-kernel source.

-serge
