Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932219AbaA1U5O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 15:57:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6400 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932128AbaA1U5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 15:57:13 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20140128202754.GI10323@ZenIV.linux.org.uk>
References: <20140128202754.GI10323@ZenIV.linux.org.uk> <CA+55aFz3Zi_PyQwnCS45XHO-om+XSesBby4g0WS0JcQp5i_m+Q@mail.gmail.com> <20140126122729.32113.19659.stgit@warthog.procyon.org.uk> <10828.1390940412@warthog.procyon.org.uk>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-afs@lists.infradead.org, Pali Roh??r <pali.rohar@gmail.com>
Subject: Re: [PATCH] afs: proc cells and rootcell are writeable
Date: Tue, 28 Jan 2014 20:56:44 +0000
Message-ID: <28052.1390942604@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> wrote:

> > ... and then making proc_create() only permit regular files (and complain
> > if the S_IFMT field is not zero)?
> 
> We already do: in proc_create_data() we have
>         struct proc_dir_entry *pde;
>         if ((mode & S_IFMT) == 0)
>                 mode |= S_IFREG;
> 
>         if (!S_ISREG(mode)) {
>                 WARN_ON(1);     /* use proc_mkdir() */
>                 return NULL;
>         }
> 
> proc_mkdir{,_data,_mode} are there for purpose.  Nobody had been insane
> enough to put FIFOs or sockets in procfs and anything else would need
> additional data anyway.  proc_symlink() is there, proc_mknod() isn't and
> nobody has complained yet.  Let's keep it that way, plese...

Should we then change the proc_create_data() to do:

	struct proc_dir_entry *pde;

	if (mode & S_IFMT) {
		WARN_ON(1);     /* use proc_mkdir() */
		return NULL;
	}
	mode |= S_IFREG;

and stop passing S_IFREG into it?

David
