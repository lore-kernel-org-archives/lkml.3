Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916Ab3CSLFT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 07:05:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8862 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971Ab3CSLFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 07:05:17 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAJfpegt8Zi3f5VxWc0kGRFcra3x_rze8j6dKCCTb4t+ViMCVYA@mail.gmail.com>
References: <CAJfpegt8Zi3f5VxWc0kGRFcra3x_rze8j6dKCCTb4t+ViMCVYA@mail.gmail.com> <1363184193-1796-3-git-send-email-miklos@szeredi.hu> <1363184193-1796-1-git-send-email-miklos@szeredi.hu> <1944.1363525619@warthog.procyon.org.uk> <20130318153936.GB28508@quack.suse.cz> <20130318215333.GE21522@ZenIV.linux.org.uk> <20130318230103.GF21522@ZenIV.linux.org.uk> <20130319013805.GG21522@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: dhowells@redhat.com, Al Viro <viro@zeniv.linux.org.uk>,
        Jan Kara <jack@suse.cz>, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, akpm@linux-foundation.org, apw@canonical.com,
        nbd@openwrt.org, neilb@suse.de, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, sedat.dilek@googlemail.com,
        hooanon05@yahoo.co.jp, mszeredi@suse.cz
Subject: Re: [PATCH 2/9] vfs: export do_splice_direct() to modules
Date: Tue, 19 Mar 2013 11:04:10 +0000
Message-ID: <28283.1363691050@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> wrote:

> > BTW, I wonder what's the right locking for that sucker; overlayfs is
> > probably too heavy - we are talking about copying a file from one fs to
> > another, which can obviously take quite a while, so holding ->i_mutex on
> > _parent_ all along is asking for very serious contention.
> 
> Copy up is a once-in-a-lifetime event for an object.  Optimizing it is
> way down in the list of things to do.  I'd drop splice in a jiffy if
> it's in the way.

Yes, but it could block the parent directory for a long time.  I suspect it's
fine if you can RCU walk through the parent, but if you have to grab a lock on
it...

David
