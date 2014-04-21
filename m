Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315AbaDUTFE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 15:05:04 -0400
Received: from imap.thunk.org ([74.207.234.97]:52199 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753499AbaDUTFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 15:05:00 -0400
Date: Mon, 21 Apr 2014 15:04:10 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Rich Felker <dalias@libc.org>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Jeff Layton <jlayton@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, samba-technical@lists.samba.org,
        Ganesha NFS List <nfs-ganesha-devel@lists.sourceforge.net>,
        "Carlos O'Donell" <carlos@redhat.com>,
        libc-alpha <libc-alpha@sourceware.org>,
        "Stefan (metze) Metzmacher" <metze@samba.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] locks: rename file-private locks to file-description
 locks
Message-ID: <20140421190410.GC5105@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Rich Felker <dalias@libc.org>,
	"Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
	Jeff Layton <jlayton@redhat.com>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, samba-technical@lists.samba.org,
	Ganesha NFS List <nfs-ganesha-devel@lists.sourceforge.net>,
	Carlos O'Donell <carlos@redhat.com>,
	libc-alpha <libc-alpha@sourceware.org>,
	"Stefan (metze) Metzmacher" <metze@samba.org>,
	Christoph Hellwig <hch@infradead.org>
References: <1398087935-14001-1-git-send-email-jlayton@redhat.com>
 <20140421140246.GB26358@brightrain.aerifal.cx>
 <535529FA.8070709@gmail.com>
 <20140421161004.GC26358@brightrain.aerifal.cx>
 <5355644C.7000801@gmail.com>
 <20140421184841.GA5105@thunk.org>
 <20140421185144.GF26358@brightrain.aerifal.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140421185144.GF26358@brightrain.aerifal.cx>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2014 at 02:51:44PM -0400, Rich Felker wrote:
> I don't think "struct file" has any meaning to any userspace
> developers, and as such doesn't belong in documentation for userspace
> programming. It's an implementation detail of the kernel that
> userspace developers have no need to be aware of. There's already
> enough leakage of broken kernel internals (e.g. tid vs pid vs tgid)
> into userspace documentation that's immensely confusing for new
> developers without adding more of it.

Userspace programmers who are using dup(2) or dup(2) need to
understand this "implementation detail".  The fact that the file
descriptor is an integer index into an array which points to a "struct
file" object is a fundamental part of the Unix/POSIX interface.  So
the fact that it has leaked out there.

I think what you mean is that there is no need that we expose the name
"struct file".  My point is that "struct file" is actually a much
_better_ name than "file description".  Heck, "open file object" would
be better name than "file description".

Hmm, how about "open file object"?  And what I'd recommend is that we
try very hard to push that name across the documentation, into the
dup/dup2 man page, with an parenthetical explanation that if you read
reading POSIX specification, you may run across the term "file
description", which is the same thing.

Realistically, far more people are likely to be looking at the man
pages rather than the POSIX specification (if for no other reason than
you have to register your e-mail address to gain access to it
on-line).  So getting the man pages to be easily understandable is,
IMHO, more important than being in 100% alignment with POSIX.

						- Ted
