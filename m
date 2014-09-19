Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233AbaISOmK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 10:42:10 -0400
Received: from tex.lwn.net ([70.33.254.29]:43041 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756002AbaISOmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 10:42:08 -0400
Date: Fri, 19 Sep 2014 10:42:04 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: Milosz Tanski <milosz@adfin.com>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>,
        Jeff Moyer <jmoyer@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC v2 0/5] Non-blockling buffered fs read (page cache only)
Message-ID: <20140919104204.3b0bb762@lwn.net>
In-Reply-To: <cover.1410983998.git.milosz@adfin.com>
References: <cover.1410810247.git.milosz@adfin.com>
	<cover.1410983998.git.milosz@adfin.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Sep 2014 22:20:45 +0000
Milosz Tanski <milosz@adfin.com> wrote:

> This patcheset introduces an ability to perform a non-blocking read from
> regular files in buffered IO mode. This works by only for those filesystems
> that have data in the page cache.
> 
> It does this by introducing new syscalls new syscalls readv2/writev2 and
> preadv2/pwritev2. These new syscalls behave like the network sendmsg, recvmsg
> syscalls that accept an extra flag argument (O_NONBLOCK).

So I'm trying to understand the reasoning behind this approach so I can
explain it to others.  When you decided to add these syscalls, you
ruled out some other approaches that have been out there for a while.
I assume that, before these syscalls can be merged, people will want to
understand why you did that.  So I'll ask the dumb questions:

 - Non-blocking I/O has long been supported with a well-understood set
   of operations - O_NONBLOCK and fcntl().  Why do we need a different
   mechanism here - one that's only understood in the context of
   buffered file I/O?  I assume you didn't want to implement support
   for poll() and all that, but is that a good enough reason to add a
   new Linux-specific non-blocking I/O technique?

 - Patches adding fincore() have been around since at least 2010; see,
   for example, https://lwn.net/Articles/371538/ or
   https://lwn.net/Articles/604640/.  It seems this could be used in
   favor of four new read() syscalls; is there a reason it's not
   suitable for your use case?

 - Patches adding buffered support for AIO have been around since at
   least 2003 - https://lwn.net/Articles/24422/, for example.  I guess
   I don't really have to ask why you don't want to take that
   approach! :)  

Apologies for my ignorance here; that's what I get for hanging around
with the MM folks at LSFMM, I guess.  Anyway, I suspect I'm not the
only one who would appreciate any background you could give here.

Thanks,

jon
