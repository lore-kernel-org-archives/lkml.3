Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686AbaEUWd2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 18:33:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50199 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647AbaEUWd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 18:33:26 -0400
Date: Wed, 21 May 2014 22:33:19 +0000
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Seth Forshee <seth.forshee@canonical.com>, Jens Axboe <axboe@kernel.dk>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        LXC development mailing-list 
	<lxc-devel@lists.linuxcontainers.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [lxc-devel] [RFC PATCH 00/11] Add support for devtmpfs in user
 namespaces
Message-ID: <20140521223319.GF29211@ubuntumail>
References: <20140515221551.GB13306@kroah.com>
 <20140516014959.GD22591@ubuntumail>
 <20140516043532.GA14149@kroah.com>
 <20140516140607.GA23902@ubuntu-hedt>
 <20140516185749.GA5131@kroah.com>
 <1400268515.2221.91.camel@dabdike.int.hansenpartnership.com>
 <20140516201841.GC23902@ubuntu-hedt>
 <87mwedfh7c.fsf@x220.int.ebiederm.org>
 <20140520142103.GC137220@ubuntu-hedt>
 <87y4xubxmm.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y4xubxmm.fsf@x220.int.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> 
> 
> >> Ultimately the technical challenge is how do we create a block device
> >> that is safe for a user who does not have any capabilities to use, and
> >> what can we do with that block device to make it useful.
> >
> > Yes, and I'd like to get started solving those challenges. But I also
> > don't think we can address these two points (support partition blkdevs,
> > help prevent more priveleged users from using a namespace's loop
> > devices) sufficiently while having an implementation completely
> > contained within the loop driver as Greg is requesting.
> 
> My key take away from the conversation is that we should reduce the
> scope of what is being done to something that makes sense and the
> propblems are immediately visible.
> 
> Part of me would like to suggest that fuse and it's ability to imitate
> device nodes might be a more appropriate solution, to something that

Do you have a link to more info on this?  Some googling got me to an
interesting but old thread on CUSE, but nothing specifically about fuse
doing this.

> just needs block device access and nothing else.
> 
> For purposes of discussion let's call it unprivloopfs.  That can reuse
> code from the loop device or not as appropriate.  Not supporting
> paritioning I think is a very reasonable first step until it is shown
> that we can make good use of partitioning support, and there are not
> better ways of solving the problem.
> 
> I expect the most productive thing to talk about is what is your
> immediate goal?  Mounting a filesystem?  Building an iso?

For me it would be taking an iso and making some changes to it to
localize it (i.e. take an install iso and add preseed file).

Now of course in the end there is no reason why we can't do all of
this with a new suite of libraries which simply uses read/write with
knowledge of the fs layouts to parse and modify the backing files.
My concern there is that duplicating all of the fs code seems unlikely
to improve the soundness of either implementation.  Perhaps we can
autogenerate this from the kernel source?  Does fuse already do
something like that?

> We have a long history with the namespace support of punting on issues
> and not solving them until a long term maintainable solution becomes
> clear.  Let's do what we can to make the problem and the solution clear.

-serge
