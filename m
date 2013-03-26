Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629Ab3CZU7x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 16:59:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60124 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752573Ab3CZU7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 16:59:50 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20130326131828.209aff73e38d3273d078bb2e@linux-foundation.org>
References: <20130326131828.209aff73e38d3273d078bb2e@linux-foundation.org> <20130326174853.10144.36253.stgit@warthog.procyon.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, torvalds@linux-foundation.org, arnd@arndb.de,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UAPI: Remove empty Kbuild files
Date: Tue, 26 Mar 2013 20:59:43 +0000
Message-ID: <29647.1364331583@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> > Remove empty Kbuild files as they cause problems with the patch program
> > which removes files that become empty.
> > 
> > Should I also remove include/Kbuild as that now does nothing?  Or should
> > it be left as an anchor just in case we want it in future?
> 
> I think that if the build system created it, a `make clean' or `make
> mproper' should rub it out again.  Ideally a `make mrproper' will give
> you a tree which is identical to a freshly-untarred kernel.org tarball
> (yes?).

Ummm...  What's that got to do with it?  include/Kbuild is part of the
sources: make clean/mrproper/distclean should not be removing it.

> Which reminds me of my email which you're still hiding from ;)
> Shouldn't a `make mrproper' undo the effects of `make headers_install'
> by wiping ./usr/include/?

Ummm...

	warthog>cp .../.config .
	warthog>make -j12 >&/dev/null
	warthog>find usr/include/ | wc -l
	873
	warthog>make distclean >&/dev/null
	warthog>find usr/include/ | wc -l
	find: `usr/include/': No such file or directory
	0

and:

	warthog>cp .../.config .
	warthog>make -j12 >&/dev/null
	warthog>find usr/include/ | wc -l
	873
	warthog>make mrproper >&/dev/null
	warthog>find usr/include/ | wc -l
	find: `usr/include/': No such file or directory
	0

so I don't see the problem.

David
