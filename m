Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476AbaDUUWM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 16:22:12 -0400
Received: from 216-12-86-13.cv.mvl.ntelos.net ([216.12.86.13]:41860 "EHLO
	brightrain.aerifal.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489AbaDUUWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 16:22:09 -0400
Date: Mon, 21 Apr 2014 16:20:59 -0400
From: Rich Felker <dalias@libc.org>
To: "Theodore Ts'o" <tytso@mit.edu>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Jeff Layton <jlayton@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, samba-technical@lists.samba.org,
        Ganesha NFS List <nfs-ganesha-devel@lists.sourceforge.net>,
        "Carlos O'Donell" <carlos@redhat.com>,
        libc-alpha <libc-alpha@sourceware.org>,
        "Stefan (metze) Metzmacher" <metze@samba.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] locks: rename file-private locks to file-description
 locks
Message-ID: <20140421202059.GG26358@brightrain.aerifal.cx>
References: <1398087935-14001-1-git-send-email-jlayton@redhat.com>
 <20140421140246.GB26358@brightrain.aerifal.cx>
 <535529FA.8070709@gmail.com>
 <20140421161004.GC26358@brightrain.aerifal.cx>
 <5355644C.7000801@gmail.com>
 <20140421184841.GA5105@thunk.org>
 <20140421185144.GF26358@brightrain.aerifal.cx>
 <20140421190410.GC5105@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140421190410.GC5105@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2014 at 03:04:10PM -0400, Theodore Ts'o wrote:
> On Mon, Apr 21, 2014 at 02:51:44PM -0400, Rich Felker wrote:
> > I don't think "struct file" has any meaning to any userspace
> > developers, and as such doesn't belong in documentation for userspace
> > programming. It's an implementation detail of the kernel that
> > userspace developers have no need to be aware of. There's already
> > enough leakage of broken kernel internals (e.g. tid vs pid vs tgid)
> > into userspace documentation that's immensely confusing for new
> > developers without adding more of it.
> 
> Userspace programmers who are using dup(2) or dup(2) need to
> understand this "implementation detail".  The fact that the file

No they don't. They need to understand the concept of an open file
description, not the kernel's "struct file" which is one (of many)
possible implementation of that. Irrelevant implementation details do
not belong in documentation.

Rich
