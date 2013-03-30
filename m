Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256Ab3C3TpR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 15:45:17 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44958 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757143Ab3C3TpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 15:45:16 -0400
Date: Sat, 30 Mar 2013 20:45:14 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Eric Wong <normalperson@yhbt.net>
Cc: "Myklebust, Trond" <Trond.Myklebust@netapp.com>,
        Zach Brown <zab@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Ric Wheeler <rwheeler@redhat.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chris L. Mason" <clmason@fusionio.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Viro <aviro@redhat.com>, "Martin K. Petersen" <mkp@mkp.net>,
        Hannes Reinecke <hare@suse.de>, Joel Becker <jlbec@evilplan.org>
Subject: Re: New copyfile system call - discuss before LSF?
Message-ID: <20130330194514.GA1005@amd.pavel.ucw.cz>
References: <512606DF.5050706@redhat.com>
 <4FA345DA4F4AE44899BD2B03EEEC2FA9235D998C@SACEXCMBX04-PRD.hq.netapp.com>
 <512635D2.4090207@redhat.com>
 <51267CEB.8070805@redhat.com>
 <4FA345DA4F4AE44899BD2B03EEEC2FA9235DAA99@SACEXCMBX04-PRD.hq.netapp.com>
 <20130221222449.GY22221@lenny.home.zabbo.net>
 <4FA345DA4F4AE44899BD2B03EEEC2FA9235DB089@SACEXCMBX04-PRD.hq.netapp.com>
 <20130223003239.GA1469@dcvr.yhbt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130223003239.GA1469@dcvr.yhbt.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > If I'm guessing correctly, sendfile64()+flags would be annoying because it's
> > > missing an out_fd_offset.  The host will want to offload the guest's copies by
> > > calling sendfile on block ranges of a guest disk image file that correspond to
> > > the mappings of the in and out files in the guest.
> > > 
> > > You could make it work with some locking and out_fd seeking to set the
> > > write offset before calling sendfile64()+flags, but ugh.
> > > 
> > >  ssize_t sendfile(int out_fd, int in_fd, off_t in_offset, off_t
> > >                   out_offset, size_t count, int flags);
> > > 
> > > That seems closer.
> > 
> > psendfile() ?
> > 
> > I fully agree that sounds reasonable... Just being an ass. :-)
> 
> splice() already has offset for both fds and a flags arg:
> 
>        ssize_t splice(int fd_in, loff_t *off_in, int fd_out,
>                       loff_t *off_out, size_t len, unsigned int flags);
> 
> The current downside is it requires one fd to be a pipe, so it's
> just not very easy to use from my perspective[1].
...
> [1] my splice() annoyances:
>     * need to create/manage a pipe
>     * copy size limited by pipe size
>     * doesn't reduce userspace syscalls (just data copy overhead)
>     * easy to misuse and starve with blocking sockets + big buffers
>     * not many users, so bugs creep in (v3.7.8 was the first usable
>       version of the 3.7 series for TCP sockets)

Could library be created to make it less annoying to use, and harder
to misuse?

splice man page does not mention pipe size limit... 
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
