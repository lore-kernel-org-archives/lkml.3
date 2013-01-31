Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205Ab3AaLW7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 06:22:59 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:64960 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab3AaLW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 06:22:57 -0500
Date: Thu, 31 Jan 2013 12:22:52 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: Huang Ying <ying.huang@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
        lkp@linux.intel.com
Subject: Re: aim7 performance regression by commit 5a50508 report from LKP
Message-ID: <20130131112252.GB4587@gmail.com>
References: <20130129082537.GS12678@yliu-dev.sh.intel.com>
 <20130129084400.GA5350@gmail.com>
 <20130129090620.GT12678@yliu-dev.sh.intel.com>
 <20130129091245.GB5775@gmail.com>
 <20130130093415.GX12678@yliu-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130130093415.GX12678@yliu-dev.sh.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yuanhan Liu <yuanhan.liu@linux.intel.com> wrote:

> > or whether the lock hold times could be reduced drastically
> 
> I also found one, but it doesn't sound like the one will 
> reduce lock hold times drastically:
>
>    vma_lock_anon_vma() seems covered too much code at
>    expand_up/downwards.
> 
> Well, again, it's quite a tiny optimization for reducing the 
> coverage.

The fundamental problem is I think that there's a single anon 
vma lock for the whole workload, right?

Is that really fundamentally needed, could that be spread out 
perhaps?

( But first we want to see how much of the regression we can fix 
  in an equivalent-locking-patterns fashion - improving locking
  is a separate matter. )

Thanks,

	Ingo
