Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965109Ab3DJNKR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 09:10:17 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:50973 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760269Ab3DJNKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 09:10:15 -0400
Date: Wed, 10 Apr 2013 15:10:10 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Li Zefan <lizefan@huawei.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/7] sched: Split cpuacct
Message-ID: <20130410131010.GA15728@gmail.com>
References: <5155365F.1010203@huawei.com>
 <1364553251.5053.83.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364553251.5053.83.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Fri, 2013-03-29 at 14:36 +0800, Li Zefan wrote:
> 
> > - This patchset splits cpuacct out of core scheduler code.
> > - Plus two small optimizations.
> > 
> 
> > ---
> >  kernel/sched/Makefile  |   1 +
> >  kernel/sched/core.c    | 228 +----------------------------------------------
> >  kernel/sched/cpuacct.c | 303 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  kernel/sched/cpuacct.h |  22 +++++
> >  kernel/sched/cputime.c |  18 +---
> >  kernel/sched/sched.h   |  48 +---------
> >  6 files changed, 330 insertions(+), 290 deletions(-)
> 
> Looks good from a quick glance, thanks for doing this.
> 
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Looks good to me too, so I added it to tip:sched/core.

The only breakage it cased was on UML:

home/mingo/tip/kernel/sched/cpuacct.c:94:2: error: implicit declaration of 
function 'ERR_PTR' [-Werror=implicit-function-declaration]

I suspect it's a previously hidden header file dependency assumption and the patch 
below will fix it.

Thanks,

	Ingo
