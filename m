Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890Ab3KAJ3s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 05:29:48 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:40777 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848Ab3KAJ3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 05:29:45 -0400
Date: Fri, 1 Nov 2013 10:29:42 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Michel Lespinasse <walken@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 1/4] mm/rmap: per anon_vma lock
Message-ID: <20131101092942.GD27063@gmail.com>
References: <1383292467-28922-1-git-send-email-yuanhan.liu@linux.intel.com>
 <1383292467-28922-2-git-send-email-yuanhan.liu@linux.intel.com>
 <20131101084329.GB19466@laptop.lan>
 <CANN689HQUv=k4AiD+v3980AmgPXbtcs1HLD7Ec1y8dsOfa_emA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANN689HQUv=k4AiD+v3980AmgPXbtcs1HLD7Ec1y8dsOfa_emA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Michel Lespinasse <walken@google.com> wrote:

> On Fri, Nov 1, 2013 at 1:43 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> > AFAICT this isn't correct at all. We used to protect the vma 
> > interval tree with the root lock, now we don't. All we've got 
> > left is the mmap_sem, but anon_vma chains can cross 
> > address-spaces and thus we're up some creek without no paddle.
> 
> Yes, that was my first thought as well (though I wanted to double 
> check at first).
> 
> I also want to point out that lately we've seen several changes 
> sent out that relax locking with no accompanying explanation of 
> why the relaxed locking would be safe. Please don't do that - 
> having a lot of performance data is worthless if you can't explain 
> why the new locking is safe. And I'm not asking to prove a 
> negative ('lack of any possible races') there, but at least in 
> this case one could dig out why the root anon vma locking was 
> introduced and if they think that this reason doesn't apply 
> anymore, explain why...

By the looks of it it seems to be an unintentional bug, not an 
intended feature.

Thanks,

	Ingo
