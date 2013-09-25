Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829Ab3IYVnb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 17:43:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49794 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814Ab3IYVn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 17:43:29 -0400
Date: Wed, 25 Sep 2013 14:43:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hughd@google.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sergei Trofimovich <slyfox@gentoo.org>,
        Timur Tabi <timur@freescale.com>, Greg KH <greg@kroah.com>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: linux-next: build failure after merge of the akpm tree
Message-Id: <20130925144328.c679dc74178e78e188386b5a@linux-foundation.org>
In-Reply-To: <alpine.LNX.2.00.1309251426150.2479@eggly.anvils>
References: <20130925110643.db5fa154bea3838ed6affa45@canb.auug.org.au>
	<20130925132612.d1685bc8fb72558eef6fb09d@linux-foundation.org>
	<alpine.LNX.2.00.1309251426150.2479@eggly.anvils>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Sep 2013 14:32:14 -0700 (PDT) Hugh Dickins <hughd@google.com> wrote:

> On Wed, 25 Sep 2013, Andrew Morton wrote:
> > On Wed, 25 Sep 2013 11:06:43 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > > Hi Andrew,
> > > 
> > > After merging the akpm tree, linux-next builds (powerpc allmodconfig)
> > > fail like this:
> > 
> > I can't get powerpc to build at all at present:
> > 
> >   CHK     include/config/kernel.release
> >   CHK     include/generated/uapi/linux/version.h
> >   CHK     include/generated/utsrelease.h
> >   CC      arch/powerpc/kernel/asm-offsets.s
> > In file included from include/linux/vtime.h:6,
> >                  from include/linux/hardirq.h:7,
> >                  from include/linux/memcontrol.h:24,
> >                  from include/linux/swap.h:8,
> >                  from include/linux/suspend.h:4,
> >                  from arch/powerpc/kernel/asm-offsets.c:24:
> > arch/powerpc/include/generated/asm/vtime.h:1:31: error: asm-generic/vtime.h: No such file or directory
> 
> That caught me too: include/asm-generic/vtime.h is a patch-unfriendly
> 0-length file in the git tree;

hm, this?


From: Andrew Morton <akpm@linux-foundation.org>
Subject: include/asm-generic/vtime.h: avoid zero-length file

patch(1) can't handle zero-length files - it appears to simply not create
the file, so my powerpc build fails.

Put something in here to make life easier.

Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/vtime.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN /dev/null include/asm-generic/vtime.h
--- /dev/null
+++ a/include/asm-generic/vtime.h
@@ -0,0 +1 @@
+/* no content, but patch(1) dislikes empty files */
_



> I wonder what use it's supposed to have.

Frederic, can you please confirm that include/asm-generic/vtime.h is
supposed to be empty?

> (And I'm not very keen on the growing trend for symlinks in the git tree.)

ooh, that explains why I lost my arch/microblaze/boot/dts/system.dts.
