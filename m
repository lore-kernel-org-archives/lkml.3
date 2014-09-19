Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758037AbaISUYT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 16:24:19 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:61613 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757658AbaISUYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 16:24:15 -0400
Date: Fri, 19 Sep 2014 13:24:10 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Trond Myklebust <trond.myklebust@primarydata.com>
Subject: Re: linux-next: Tree for Sep 19
Message-ID: <20140919202410.GA26329@roeck-us.net>
References: <20140919165817.225eb8b8@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140919165817.225eb8b8@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 04:58:17PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20140917:
> 
> The fsl tree still had its build failure so I used the version from
> next-20140917.
> 
> The v4l-dvb tree lost its build failure.
> 
> The security tree gained a conflict against the file-locks tree.
> 
> Non-merge commits (relative to Linus' tree): 6014
>  5488 files changed, 217522 insertions(+), 129375 deletions(-)
> 
> ----------------------------------------------------------------------------
> 
i386:allyesconfig:

fs/built-in.o: In function `bl_map_stripe':
dev.c:(.text+0x3489ab): undefined reference to `__udivdi3'
dev.c:(.text+0x3489ca): undefined reference to `__umoddi3'
dev.c:(.text+0x348a83): undefined reference to `__udivdi3'

i386:allmodconfig:
mips:allmodconfig:

ERROR: "__udivdi3" [fs/nfs/blocklayout/blocklayoutdriver.ko] undefined!
ERROR: "__umoddi3" [fs/nfs/blocklayout/blocklayoutdriver.ko] undefined!

Obviously caused by commit 5c83746a0cf ('pnfs/blocklayout: in-kernel
GETDEVICEINFO XDR parsing') which adds fs/nfs/blocklayout/dev.c.
