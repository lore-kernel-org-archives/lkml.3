Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153AbaDUQpy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 12:45:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37696 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752775AbaDUQpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 12:45:51 -0400
Date: Mon, 21 Apr 2014 12:42:10 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Rich Felker <dalias@libc.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, samba-technical@lists.samba.org,
        Ganesha NFS List <nfs-ganesha-devel@lists.sourceforge.net>,
        "Carlos O'Donell" <carlos@redhat.com>,
        libc-alpha <libc-alpha@sourceware.org>,
        "Stefan (metze) Metzmacher" <metze@samba.org>
Subject: Re: [PATCH] locks: rename file-private locks to file-description
 locks
Message-ID: <20140421124210.6c5d4e06@tlielax.poochiereds.net>
In-Reply-To: <20140421160927.GA19653@infradead.org>
References: <1398087935-14001-1-git-send-email-jlayton@redhat.com>
	<20140421140246.GB26358@brightrain.aerifal.cx>
	<535529FA.8070709@gmail.com>
	<20140421160927.GA19653@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Apr 2014 09:09:27 -0700
Christoph Hellwig <hch@infradead.org> wrote:

> On Mon, Apr 21, 2014 at 04:23:54PM +0200, Michael Kerrisk (man-pages) wrote:
> > 
> > There's at least two problems to solve here:
> > 
> > 1) "File private locks" is _meaningless_ as a term. Elsewhere
> >    (http://thread.gmane.org/gmane.network.samba.internals/76414/focus=1685376),
> 
> It's indeed not a very good choice, but the new name is even worse.
> Just call them non-broken locks? :)  Or not give them a name an just
> append a 2 to the fcntls? :)
> 

I think we'll need to give them a name, if only to make it possible to
document this stuff.

I'm in Jeremy's camp on this one. I don't really care what that name
*is*. I just need to know what it is so I can finish up the docs and
make any changes to the interface that are necessary.

> > 2) The new API constants (F_SETLKP, F_SETLKPW, F_GETLKP) have names
> >    that are visually very close to the traditional POSIX lock names 
> >    (F_SETLK, F_SETLKW, F_GETLK). That's an accident waiting to happen
> >    when someone mistypes in code and/or misses such a misttyping
> >    when reading code. That really must be fixed.
> 
> I don't think so.  They also should have a name very similar because
> they have the same semantics with a major bug fixed.  In fact I can't
> think of anyone who would actually want the old behavior.
> 

On this point, I agree with Michael. It would be easy to mix up the
names when scanning by eye, so I think there is some value in making
these more visually distinct. I rather like the idea of changing
F_SETLKP to F_*_SETLK. The question is what to put in place of the
wildcard there, and that sort of hinges on the name...

-- 
Jeff Layton <jlayton@redhat.com>
