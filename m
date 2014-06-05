Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102AbaFEWRF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 18:17:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38051 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752745AbaFEWRC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 18:17:02 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAJfpegvSkr4NJJOfPH4MOhYvaLe=yWv_pR9kK4uiRpScyiapig@mail.gmail.com>
References: <CAJfpegvSkr4NJJOfPH4MOhYvaLe=yWv_pR9kK4uiRpScyiapig@mail.gmail.com> <CAJfpegtobxoMs+RRrPYLFRPOVSfr_uqZs+HJFLRif3svHGyQwA@mail.gmail.com> <1400838223-30844-1-git-send-email-miklos@szeredi.hu> <28592.1401382081@warthog.procyon.org.uk> <11446.1401420931@jrobl> <7184.1401439773@warthog.procyon.org.uk> <CA+icZUV5P=fVwe_MJJHixwBOBoj7HoKSFuySLdS6AU5L++S=4g@mail.gmail.com> <15839.1401786056@warthog.procyon.org.uk> <CA+icZUUiirxYnoL7pg5TvFEy6pQ+5Q3CuJ0jonJMXTOwhT-LDw@mail.gmail.com> <CA+icZUU8BqGUoQdtuqt403NdCBnJnH1-k64bxTM0b_GSfQr1hQ@mail.gmail.com> <10013.1401791634@warthog.procyon.org.uk> <20140603132153.GA26512@tucsk.piliscsaba.szeredi.hu> <19281.1401809418@warthog.procyon.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: dhowells@redhat.com, Sedat Dilek <sedat.dilek@gmail.com>,
        "J. R. Okajima" <hooanon05g@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Robo Bot <apw@canonical.com>, Felix Fietkau <nbd@openwrt.org>,
        Neil Brown <neilb@suse.de>, Jordi Pujol <jordipujolp@gmail.com>,
        ezk@fsl.cs.sunysb.edu, "mszeredi@suse.cz" <mszeredi@suse.cz>
Subject: Re: Unionmount and overlayfs testsuite
Date: Thu, 05 Jun 2014 23:16:00 +0100
Message-ID: <10878.1402006560@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> wrote:

> Shell script is the one I'm most familiar with, and that maybe true
> for other kernel developers too.
> 
> Also, it's what xfstests are using and it would make sense to move
> towards that.  Although I'm not sure how well it supports
> multiple-device filesystems.

It was already shell script, but I can do all the layer checking and
automatically fixing up the error prediction for when pathnames have slashes
appended much more easily in something like python where I can build and
maintain a map of the state of the filesystem.

See:

	http://git.infradead.org/users/dhowells/unionmount-testsuite.git/shortlog/refs/heads/switch-to-python

I've also added tests to exercise mkdir and rmdir and have enabled the unlink
tests.  So far so good with overlayfs.

David
