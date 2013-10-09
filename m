Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627Ab3JIDjt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 23:39:49 -0400
Received: from one.firstfloor.org ([193.170.194.197]:42410 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754255Ab3JIDjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 23:39:48 -0400
Date: Wed, 9 Oct 2013 05:39:46 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        Andi Kleen <ak@linux.intel.com>, fweisbec@gmail.com
Subject: Re: [PATCH 6/6] x86: Allow disabling HW_BREAKPOINTS and PERF_EVENTS
Message-ID: <20131009033946.GS6882@two.firstfloor.org>
References: <1380922788-23112-1-git-send-email-andi@firstfloor.org>
 <1380922788-23112-7-git-send-email-andi@firstfloor.org>
 <20131006164934.GA15167@gmail.com>
 <20131008065938.GA4333@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131008065938.GA4333@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some more comments.

>   - your patches might break apps/ABI

Can you please explain that a bit more. We have a lot of CONFIG options
that disable syscalls, /sys, lots of stuff. Whoever uses them needs
to know what they are doing. I thought it was pretty
much consensus that Linux is supposed to be a very configurable OS,
which people can taylor from small embedded to large kitchen sink
included using CONFIG_*. 

Are you saying that Linux should not be configurable small to big? (I would
find that hard to believe). If that's really your standpoint I would
like to see some confirmation on this, as it would seem a big 
departure from traditional practice.

Or is the concern that you want it default y or EXPERT, so what
the defaults are? That sounds reasonable.

Or should it be more modular like Peter pointed out (that
would seem like a good solution for generic distros, but not so
good for deeply embedded like running on Quark)

BTW afaik pretty much every other architecture still allows to disable
it, just x86 has this dependency loop problem.

> 
>   - your patch-set unnecessarily complicates things, making the kernel
>     less maintainable

I actually simplified some things, like unnecessary
dependencies between perf and profile.

These should be applied in any case as they are independent.
I can repost them.

Given some of the ifdefs/configs were not nice, perhaps there's a better
solution for this from Frederic.

-Andi
