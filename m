Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870Ab3CDK3A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 05:29:00 -0500
Received: from dcvr.yhbt.net ([64.71.152.64]:45321 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756361Ab3CDK27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 05:28:59 -0500
Date: Mon, 4 Mar 2013 10:28:59 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Ulrich Drepper <drepper@gmail.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: sendfile and EAGAIN
Message-ID: <20130304102859.GA23311@dcvr.yhbt.net>
References: <CAOPLpQcs5GgVRqXhnxF0Ui0k-39-xX5N2nYWYY4DhVWMYCMQ7w@mail.gmail.com>
 <1361820175.6781.13.camel@edumazet-glaptop>
 <CAOPLpQe5SfdWYv5QD4Fu90PXyS7SrSN_5Gntk2x5D5ea8ke64g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOPLpQe5SfdWYv5QD4Fu90PXyS7SrSN_5Gntk2x5D5ea8ke64g@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper <drepper@gmail.com> wrote:
> On Mon, Feb 25, 2013 at 2:22 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > I don't understand the issue.
> >
> > sendfile() returns -EAGAIN only if no bytes were copied to the socket.
> 
> There is something wrong/unexpected/...
> 
> I have a program which can use either sendfile or send.  When using
> sendfile to transmit a large block (I've seen it with 900k) the
> sendfile call does not transmit everything.  There receiver gets only
> about 600k.  This is the situation when I think I've seen EAGAIN
> errors from sendmail but I cannot just now reproduce it.  This is with
> sockets of AF_UNIX type.

If you manage to reproduce it, can you pass an offset to sendfile() and
see if the offset changed when you get EAGAIN?

Also, which kernel version are you using?  Perhaps it's triggered
by memory pressure.
