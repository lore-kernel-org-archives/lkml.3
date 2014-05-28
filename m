Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665AbaE1J1j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 05:27:39 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:49659 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368AbaE1J1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 05:27:00 -0400
Date: Wed, 28 May 2014 11:26:55 +0200
From: Seth Forshee <seth.forshee@canonical.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: LXC development mailing-list 
	<lxc-devel@lists.linuxcontainers.org>,
        Serge Hallyn <serge.hallyn@ubuntu.com>, Jens Axboe <axboe@kernel.dk>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [lxc-devel] [RFC PATCH 00/11] Add support for devtmpfs in user
 namespaces
Message-ID: <20140528092655.GD19433@ubuntu-mba51>
Mail-Followup-To: "Eric W. Biederman" <ebiederm@xmission.com>,
	LXC development mailing-list <lxc-devel@lists.linuxcontainers.org>,
	Serge Hallyn <serge.hallyn@ubuntu.com>,
	Jens Axboe <axboe@kernel.dk>,
	Serge Hallyn <serge.hallyn@canonical.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-kernel@vger.kernel.org,
	James Bottomley <James.Bottomley@HansenPartnership.com>
References: <20140516043532.GA14149@kroah.com>
 <20140516140607.GA23902@ubuntu-hedt>
 <20140516185749.GA5131@kroah.com>
 <1400268515.2221.91.camel@dabdike.int.hansenpartnership.com>
 <20140516201841.GC23902@ubuntu-hedt>
 <87mwedfh7c.fsf@x220.int.ebiederm.org>
 <20140520142103.GC137220@ubuntu-hedt>
 <87y4xubxmm.fsf@x220.int.ebiederm.org>
 <20140521223319.GF29211@ubuntumail>
 <87ioow9ls9.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ioow9ls9.fsf@x220.int.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2014 at 03:23:50PM -0700, Eric W. Biederman wrote:
> Serge Hallyn <serge.hallyn@ubuntu.com> writes:
> 
> > Quoting Eric W. Biederman (ebiederm@xmission.com):
> >> 
> >> 
> >> >> Ultimately the technical challenge is how do we create a block device
> >> >> that is safe for a user who does not have any capabilities to use, and
> >> >> what can we do with that block device to make it useful.
> >> >
> >> > Yes, and I'd like to get started solving those challenges. But I also
> >> > don't think we can address these two points (support partition blkdevs,
> >> > help prevent more priveleged users from using a namespace's loop
> >> > devices) sufficiently while having an implementation completely
> >> > contained within the loop driver as Greg is requesting.
> >> 
> >> My key take away from the conversation is that we should reduce the
> >> scope of what is being done to something that makes sense and the
> >> propblems are immediately visible.
> >> 
> >> Part of me would like to suggest that fuse and it's ability to imitate
> >> device nodes might be a more appropriate solution, to something that
> >
> > Do you have a link to more info on this?  Some googling got me to an
> > interesting but old thread on CUSE, but nothing specifically about fuse
> > doing this.
> 
> CUSE is probably what I was thinking of.  It is all part of the fuse
> code base in the kernel.  And now that I am reminded it is called CUSE
> I go Duh that is a character device...
> 
> Fuse and everything it can do is definitely the filesystem I would like
> to see most have the audits to be enabled in user namespace.  Fuse
> was built to be sufficiently paranoid to allow this and so it should not
> take a lot to take fuse the rest of the way.

I was aware of FUSE but hadn't ever looked at it much. Looking at it
now, this isn't going to satisfy any of the use cases I know about,
which are wanting to use filesystems supported in-kernel (isofs, ext*).
I don't see that any of these have a FUSE implementation, and I think we
gain more from figuring out how to use in-kernel filesystems in
containers than trying to find a way to shoehorn selected filesystems
into FUSE.

