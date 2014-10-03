Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760087AbaJCXZl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:25:41 -0400
Received: from one.firstfloor.org ([193.170.194.197]:46733 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755609AbaJCXZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 19:25:37 -0400
Date: Sat, 4 Oct 2014 01:25:36 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Andi Kleen <ak@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, dave@sr71.net,
        linux-kernel@vger.kernel.org, eranian@google.com, x86@kernel.org,
        torvalds@linux-foundation.org,
        Vitaly Mayatskikh <v.mayatskih@gmail.com>
Subject: Re: [PATCH 2/2] x86: Only do a single page fault for
 copy_from_user_nmi
Message-ID: <20141003232536.GG12538@two.firstfloor.org>
References: <1411774277-4198-1-git-send-email-andi@firstfloor.org>
 <1411774277-4198-3-git-send-email-andi@firstfloor.org>
 <20140929115620.GH5430@worktop>
 <20140929152646.GC1629@tassilo.jf.intel.com>
 <20141003045359.GA24281@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141003045359.GA24281@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> There are cleaner ways to solve this problem - PeterZ offered 
> one, but there are other options as well, such as:
> 
>  - removing exact-bytes semantics explicitly from almost all 
>    cases and offering a separate (and more expensive, in the 
>    faulting case) memcpy variant for write() and other code that 
>    absolutely must know the number of copied bytes.

That would be a full tree audit of thousands of calls.
And any mistake would be a security hole.

>  - or adding a special no-bytes-copied memcpy variant that the 
>    NMI code could use.

That's the duplicated copy path I mentioned. If people really want that
I can implement it, although I personally think it's ugly and bloated
over engineering for this case.

> It might be more work for you, but it gives us a cleaner and more 
> maintainable kernel. The problem is that you should know this 
> general principle already, instead you are wasting maintainer 
> bandwidth via arguing in favor of ugly hacks again and again...

The duplicated path is unlikely to be more maintainable 
than the simple and obvious check.

-Andi
