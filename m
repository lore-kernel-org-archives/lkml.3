Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045AbaDUSsp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 14:48:45 -0400
Received: from 216-12-86-13.cv.mvl.ntelos.net ([216.12.86.13]:41835 "EHLO
	brightrain.aerifal.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328AbaDUSsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 14:48:37 -0400
Date: Mon, 21 Apr 2014 14:48:29 -0400
From: Rich Felker <dalias@libc.org>
To: Jeff Layton <jlayton@redhat.com>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        samba-technical@lists.samba.org,
        Ganesha NFS List <nfs-ganesha-devel@lists.sourceforge.net>,
        "Carlos O'Donell" <carlos@redhat.com>,
        libc-alpha <libc-alpha@sourceware.org>,
        "Stefan (metze) Metzmacher" <metze@samba.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] locks: rename file-private locks to file-description
 locks
Message-ID: <20140421184829.GE26358@brightrain.aerifal.cx>
References: <1398087935-14001-1-git-send-email-jlayton@redhat.com>
 <20140421140246.GB26358@brightrain.aerifal.cx>
 <535529FA.8070709@gmail.com>
 <20140421161004.GC26358@brightrain.aerifal.cx>
 <20140421124508.4f2c9ca7@tlielax.poochiereds.net>
 <5355610A.6090606@gmail.com>
 <20140421143238.668c818d@tlielax.poochiereds.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140421143238.668c818d@tlielax.poochiereds.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2014 at 02:32:38PM -0400, Jeff Layton wrote:
> > > Fair enough. Assuming we kept "file-description locks" as a name, what
> > > would you propose as new macro names?
> > 
> > I assume you meant, "assume we kept the term 'file-private locks'..."
> > In that case, at least make the constants something like
> > 
> > F_FP_SETLK
> > F_FP_SETLKW
> > F_FP_GETLK
> > 
> > so that they are not confused with the traditional constants.
> > 
> > Cheer,
> > 
> 
> Actually no, I was asking how Rich would name the constants if we use
> the name "file-description locks" (as per the patch I posted this
> morning), since his objection was the use if *_FD_* names.
> 
> I would assume that if we stick with "file-private locks" as the name,
> then we'll still change the constants to a form like *_FP_*.
> 
> Also, to be clear...Frank is correct that the name "file-private" came
> from allowing the locks to be "private" to a particular open file
> description. Though I agree that it's a crappy name at best...

As I mentioned in a reply to Michael just now, I think FP is bad
because the whole problem is that legacy fcntl locks are associated
with the underlying file rather than the open file description (open
instance). So open-private (OP) might be a better choice than
file-private.

Rich
