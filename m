Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473AbaKWUat (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 15:30:49 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:59553 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbaKWUar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 15:30:47 -0500
Date: Sun, 23 Nov 2014 21:30:40 +0100
From: Pieter Smith <pieter@boesman.nl>
To: Josh Triplett <josh@joshtriplett.org>
Cc: David Miller <davem@davemloft.net>, alexander.h.duyck@intel.com,
        viro@zeniv.linux.org.uk, ast@plumgrid.com, akpm@linux-foundation.org,
        beber@meleeweb.net, catalina.mocanu@gmail.com, dborkman@redhat.com,
        edumazet@google.com, ebiederm@xmission.com, fabf@skynet.be,
        fuse-devel@lists.sourceforge.net, geert@linux-m68k.org,
        hughd@google.com, iulia.manda21@gmail.com, JBeulich@suse.com,
        bfields@fieldses.org, jlayton@poochiereds.net,
        linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, mcgrof@suse.com, mattst88@gmail.com,
        mgorman@suse.de, mst@redhat.com, miklos@szeredi.hu,
        netdev@vger.kernel.org, oleg@redhat.com, Paul.Durrant@citrix.com,
        paulmck@linux.vnet.ibm.com, pefoley2@pefoley.com, tgraf@suug.ch,
        therbert@google.com, willemb@google.com,
        xiaoguangrong@linux.vnet.ibm.com, zhenglong.cai@cs2c.com.cn
Subject: Re: [PATCH 0/6] kernel tinification: optionally compile out splice
 family of syscalls (splice, vmsplice, tee and sendfile)
Message-ID: <20141123203040.GB26749@smipidev>
References: <1416752468-1626-1-git-send-email-pieter@boesman.nl>
 <20141123.134623.2061031332250984539.davem@davemloft.net>
 <20141123194326.GB8517@thin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141123194326.GB8517@thin>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 23, 2014 at 11:43:26AM -0800, Josh Triplett wrote:
> On Sun, Nov 23, 2014 at 01:46:23PM -0500, David Miller wrote:
> > Truly removing sendfile/sendpage means that you can't even compile NFS
> > into the tree.
> 
> If you mean the in-kernel nfsd (CONFIG_NFSD), that already has a large
> stack of "select" and "depends on", both directly and indirectly; adding
> a "select SPLICE_SYSCALL" to it seems fine.  (That select does need
> adding, though.  Pieter, you need to test-compile more than just
> tinyconfig and defconfig.  Try an allyesconfig with *just* splice turned
> off, and make sure that compiles.)

Did exacly that. Took forever on my hardware, but no problems.

> Given the requirements of running a file server in the kernel, I'd
> expect CONFIG_NFSD to end up with several more selects of optional
> functionality in the future.  It seems rather likely that the average
> embedded system will be compiling out NFS. :)
> 
> Also, this patch series compiles out splice and sendfile, including
> several *users* of sendpage; it doesn't compile out the sendpage
> support/infrastructure itself.
> 
> - Josh Triplett
