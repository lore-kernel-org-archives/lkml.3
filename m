Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422921Ab3BAKwZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 05:52:25 -0500
Received: from mga11.intel.com ([192.55.52.93]:44935 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422851Ab3BAKwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 05:52:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,579,1355126400"; 
   d="scan'208";a="281507162"
Date: Fri, 1 Feb 2013 18:53:13 +0800
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Huang Ying <ying.huang@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
        lkp@linux.intel.com
Subject: Re: aim7 performance regression by commit 5a50508 report from LKP
Message-ID: <20130201105313.GA22784@yliu-dev.sh.intel.com>
References: <20130129082537.GS12678@yliu-dev.sh.intel.com>
 <20130129084400.GA5350@gmail.com>
 <20130129090620.GT12678@yliu-dev.sh.intel.com>
 <20130129091245.GB5775@gmail.com>
 <20130130093415.GX12678@yliu-dev.sh.intel.com>
 <20130131112252.GB4587@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130131112252.GB4587@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2013 at 12:22:52PM +0100, Ingo Molnar wrote:
> 
> * Yuanhan Liu <yuanhan.liu@linux.intel.com> wrote:
> 
> > > or whether the lock hold times could be reduced drastically
> > 
> > I also found one, but it doesn't sound like the one will 
> > reduce lock hold times drastically:
> >
> >    vma_lock_anon_vma() seems covered too much code at
> >    expand_up/downwards.
> > 
> > Well, again, it's quite a tiny optimization for reducing the 
> > coverage.
> 
> The fundamental problem is I think that there's a single anon 
> vma lock for the whole workload, right?

Yes.
> 
> Is that really fundamentally needed, could that be spread out 
> perhaps?

I'm digging into this. 

Thanks.

	--yliu
> 
> ( But first we want to see how much of the regression we can fix 
>   in an equivalent-locking-patterns fashion - improving locking
>   is a separate matter. )
> 
> Thanks,
> 
> 	Ingo
