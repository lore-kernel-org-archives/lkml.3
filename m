Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab3BFL2R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 06:28:17 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:56368 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab3BFL2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 06:28:16 -0500
Date: Wed, 6 Feb 2013 12:28:11 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Alex Shi <alex.shi@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, paul.gortmaker@windriver.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rwsem: steal writing sem for better performance
Message-ID: <20130206112811.GD8696@gmail.com>
References: <1360069915-31619-1-git-send-email-alex.shi@intel.com>
 <20130205145854.GA30949@gmail.com>
 <51119ED0.3030207@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51119ED0.3030207@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alex Shi <alex.shi@intel.com> wrote:

> On 02/05/2013 10:58 PM, Ingo Molnar wrote:
> > 
> > * Alex Shi <alex.shi@intel.com> wrote:
> > 
> >> Commit 5a50508 change to rwsem from mutex, that cause aim7 
> >> fork_test dropped 50%. Yuanhan liu does a good analysis, 
> >> find it caused by strict sequential writing. Ingo suggest 
> >> stealing sem writing from front task in waiting queue. 
> >> https://lkml.org/lkml/2013/1/29/84 So has this patch.
> >>
> >> In this patch, I just allow writing steal happen when the 
> >> first waiter is also writer. Then the performance fully 
> >> recovered.
> > 
> > All the aim7 fork_test performance regression is recovered?
> 
> Sure. 100% recovered on my NHM EP, NHM EX, SNB EP 2S and 4S 
> machines.

That's totally awesome!

Linus, Andrew, what is your thinking about the patch and about 
the timing of the patch?

It looks correct and straightforward to me, but rwsem races 
tended to be tricky to find and fix in the past...

We are in -rc7 territory which is a bit late for fundamental 
locking changes.

OTOH this is a regression fix, and not a small one.

I'll queue it up optimistically in an urgent branch for the time 
being, to see what happens with a few days of testing ... If 
there's any problems with it then it's clearly ineligible.

Thanks,

	Ingo
