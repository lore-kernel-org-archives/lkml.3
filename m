Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbaBCWCI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 17:02:08 -0500
Received: from dcvr.yhbt.net ([64.71.152.64]:57697 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789AbaBCWCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 17:02:07 -0500
X-Greylist: delayed 612 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Feb 2014 17:02:07 EST
Date: Mon, 3 Feb 2014 21:51:51 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Nathaniel Yazdani <n1ght.4nd.d4y@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/3] epoll: read(),write(),ioctl() interface
Message-ID: <20140203215151.GA25594@dcvr.yhbt.net>
References: <1391393832-8754-1-git-send-email-n1ght.4nd.d4y@gmail.com>
 <52EFEF0A.9080101@amacapital.net>
 <CAJ3m7Br60ph=Ja_ggJAp9cb5fNJy2O1rRHeJW_jjeTJbYmG3UA@mail.gmail.com>
 <CALCETrXBRW=x9myjxzZB+ChtPiH9zjNOd=YLtCp61ib3bqEpKA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXBRW=x9myjxzZB+ChtPiH9zjNOd=YLtCp61ib3bqEpKA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> wrote:
> >> On 02/02/2014 06:17 PM, Nathaniel Yazdani wrote:
> > So are you saying that those features you mentioned are specifically sought
> > after for the kernel? If so I'd like to take a crack at some of them,
> > may as well
> > get some use out of my new knowledge of epoll internals :)
> 
> If by "sought after", you mean "is there at least one epoll user who
> wants them", then yes :)
> 
> I think that EPOLLET and EPOLLONESHOT are giant hacks, and that what
> everyone really wants is the ability to very efficiently toggle events
> on and off.  The ability to do it simultaneously and inexpensively
> with epoll_wait would make it happen.

Everybody using single-threaded epoll, you mean?  I suppose there's
quite a few of those.

I've pondered an epoll_xchg syscall which would behave like *BSD kevent
to satisfy single-threaded users, but never got around to it.  All my
epoll uses are multithreaded w/ oneshot nowadays, so xchg would only
save one syscall per thread.
