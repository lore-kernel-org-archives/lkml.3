Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932263AbaA1UUp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 15:20:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13239 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932117AbaA1UUn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 15:20:43 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CA+55aFz3Zi_PyQwnCS45XHO-om+XSesBby4g0WS0JcQp5i_m+Q@mail.gmail.com>
References: <CA+55aFz3Zi_PyQwnCS45XHO-om+XSesBby4g0WS0JcQp5i_m+Q@mail.gmail.com> <20140126122729.32113.19659.stgit@warthog.procyon.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-afs@lists.infradead.org,
        =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: Re: [PATCH] afs: proc cells and rootcell are writeable
Date: Tue, 28 Jan 2014 20:20:12 +0000
Message-ID: <10828.1390940412@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > -       p = proc_create("cells", 0, proc_afs, &afs_proc_cells_fops);
> > +       p = proc_create("cells", S_IFREG | S_IRUGO | S_IWUSR, proc_afs, &afs_proc_cells_fops);
> > -       p = proc_create("rootcell", 0, proc_afs, &afs_proc_rootcell_fops);
> > +       p = proc_create("rootcell", S_IFREG | S_IRUGO | S_IWUSR, proc_afs, &afs_proc_rootcell_fops);
> 
> So the S_IFREG isn't necessary.

True.  Is it worth creating proc_create_special() that can create a non-regular
file and then making proc_create() only permit regular files (and complain if
the S_IFMT field is not zero)?

> And quite frankly, I personally think S_IRUGO | S_IWUSR is _less_
> readable than 0644. It's damn hard to parse those random letter
> combinations, and at least I have to really think about it, in a way
> that the octal representation does *not* make me go "I have to think
> about that".

Fine by me.

David
