Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217AbaAZUTe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 15:19:34 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:34731 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbaAZUTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 15:19:32 -0500
Date: Sun, 26 Jan 2014 21:19:28 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-afs@lists.infradead.org,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Subject: Re: [PATCH] afs: proc cells and rootcell are writeable
Message-ID: <20140126201928.GA8224@gmail.com>
References: <20140126122729.32113.19659.stgit@warthog.procyon.org.uk>
 <CA+55aFz3Zi_PyQwnCS45XHO-om+XSesBby4g0WS0JcQp5i_m+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFz3Zi_PyQwnCS45XHO-om+XSesBby4g0WS0JcQp5i_m+Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Sun, Jan 26, 2014 at 4:27 AM, David Howells <dhowells@redhat.com> wrote:
> >
> > -       p = proc_create("cells", 0, proc_afs, &afs_proc_cells_fops);
> > +       p = proc_create("cells", S_IFREG | S_IRUGO | S_IWUSR, proc_afs, &afs_proc_cells_fops);
> > -       p = proc_create("rootcell", 0, proc_afs, &afs_proc_rootcell_fops);
> > +       p = proc_create("rootcell", S_IFREG | S_IRUGO | S_IWUSR, proc_afs, &afs_proc_rootcell_fops);
> 
> So the S_IFREG isn't necessary.
> 
> And quite frankly, I personally think S_IRUGO | S_IWUSR is _less_ 
> readable than 0644. It's damn hard to parse those random letter 
> combinations, and at least I have to really think about it, in a way 
> that the octal representation does *not* make me go "I have to think 
> about that".
> 
> So my personal preference would be to just see that simple 0644 in 
> proc_create. Hmm?

Perhaps we could also generate the most common variants as:

 #define PERM__rw_r__r__		0644
 #define PERM__r________		0400
 #define PERM__r__r__r__		0444
 #define PERM__r_xr_xr_x		0555

etc.

or something similar, more or less matching the output of 'ls -l'?

That would also make security bugs in this area apparent at first 
sight. The number of people who can recognize during review that 
PERM_rw__w__w is probably unwise is probably two orders of magnitude 
than those who can interpret octal 0622 at a glance.

Thanks,

	Ingo
