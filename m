Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219Ab3IYVct (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 17:32:49 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:56150 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755411Ab3IYVcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 17:32:47 -0400
Date: Wed, 25 Sep 2013 14:32:14 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sergei Trofimovich <slyfox@gentoo.org>,
        Timur Tabi <timur@freescale.com>, Greg KH <greg@kroah.com>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: linux-next: build failure after merge of the akpm tree
In-Reply-To: <20130925132612.d1685bc8fb72558eef6fb09d@linux-foundation.org>
Message-ID: <alpine.LNX.2.00.1309251426150.2479@eggly.anvils>
References: <20130925110643.db5fa154bea3838ed6affa45@canb.auug.org.au> <20130925132612.d1685bc8fb72558eef6fb09d@linux-foundation.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Sep 2013, Andrew Morton wrote:
> On Wed, 25 Sep 2013 11:06:43 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > Hi Andrew,
> > 
> > After merging the akpm tree, linux-next builds (powerpc allmodconfig)
> > fail like this:
> 
> I can't get powerpc to build at all at present:
> 
>   CHK     include/config/kernel.release
>   CHK     include/generated/uapi/linux/version.h
>   CHK     include/generated/utsrelease.h
>   CC      arch/powerpc/kernel/asm-offsets.s
> In file included from include/linux/vtime.h:6,
>                  from include/linux/hardirq.h:7,
>                  from include/linux/memcontrol.h:24,
>                  from include/linux/swap.h:8,
>                  from include/linux/suspend.h:4,
>                  from arch/powerpc/kernel/asm-offsets.c:24:
> arch/powerpc/include/generated/asm/vtime.h:1:31: error: asm-generic/vtime.h: No such file or directory

That caught me too: include/asm-generic/vtime.h is a patch-unfriendly
0-length file in the git tree; I wonder what use it's supposed to have.

(And I'm not very keen on the growing trend for symlinks in the git tree.)

Hugh
