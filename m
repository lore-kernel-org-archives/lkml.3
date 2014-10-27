Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443AbaJ0Ojh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 10:39:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44681 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752920AbaJ0Ojg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 10:39:36 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20141027141935.GC3021@tucsk.piliscsaba.szeredi.hu>
References: <20141027141935.GC3021@tucsk.piliscsaba.szeredi.hu> <5394.1414418718@warthog.procyon.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: dhowells@redhat.com, Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-unionfs@vger.kernel.org
Subject: Re: Locking problem in overlayfs
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6031.1414420761.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: 8BIT
Date: Mon, 27 Oct 2014 14:39:21 +0000
Message-ID: <6032.1414420761@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> wrote:

> Uh-oh.  We changed nesting late in the cycle and I didn't retest with lockdep.
> 
> And it's actually harmless, but AFAICS needs another level of nesting between
> I_MUTEX_CHILD and I_MUTEX_NORMAL.

In an overlay directory that shadows an empty lower directory, say
/mnt/a/empty102, do:

	touch /mnt/a/empty102/x
	unlink /mnt/a/empty102/x
	rmdir /mnt/a/empty102

David
