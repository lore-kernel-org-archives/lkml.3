Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbaDUSt5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 14:49:57 -0400
Received: from imap.thunk.org ([74.207.234.97]:52140 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752779AbaDUStu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 14:49:50 -0400
Date: Mon, 21 Apr 2014 14:48:41 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Rich Felker <dalias@libc.org>, Jeff Layton <jlayton@redhat.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        samba-technical@lists.samba.org,
        Ganesha NFS List <nfs-ganesha-devel@lists.sourceforge.net>,
        "Carlos O'Donell" <carlos@redhat.com>,
        libc-alpha <libc-alpha@sourceware.org>,
        "Stefan (metze) Metzmacher" <metze@samba.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] locks: rename file-private locks to file-description
 locks
Message-ID: <20140421184841.GA5105@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	"Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
	Rich Felker <dalias@libc.org>, Jeff Layton <jlayton@redhat.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	samba-technical@lists.samba.org,
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5355644C.7000801@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2014 at 08:32:44PM +0200, Michael Kerrisk (man-pages) wrote:
> So, can you *please* answer this question: what do you call (i.e., 
> what  everyday technical language term do use for) the thing
> that sits between a file descriptor and an i-node? 
> 
> (Please don't say 'struct file' -- that is not is an implementation 
> detail, and does not qualify as the kind of term that I could use 
> when documenting this feature in man pages.)

At least in a few places, if you are going to use "file description",
could you at least add a parenthetical comment:

	(commonly called a "struct file" by Linux kernel developers)

Yes, it's an implementation detail, but it's one that's been around
for over two decades, and IMHO highly unlikely to change in the
future.  So if you really want to use the POSIX terminology, it would
probably be a good idea to also use the term of art which is in common
use by the kernel developers, and I suspect has leaked out beyond
that.

I think it's actually a better and more functional name than what
POSIX uses, so maybe the best compromise is to use both, to make sure
there is no confusion.  In particular, if we have text in the man
pages where we have "file description" and "file descriptor" in the
close proximity it would probably be good to add "(i.e., a struct file
by Linux kernel developers)" just for clarity.

Cheers,

							- Ted
