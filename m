Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626AbaFFRUE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 13:20:04 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:36752 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585AbaFFRUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 13:20:00 -0400
X-CheckPoint: {5391F83F-13-2100090A-C0000000}
Message-ID: <5391F83F.60005@tilera.com>
Date: Fri, 6 Jun 2014 13:19:59 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Davidlohr Bueso <davidlohr@hp.com>, <mingo@kernel.org>,
        <mpatocka@redhat.com>, <torvalds@linux-foundation.org>,
        <jason.low2@hp.com>, <waiman.long@hp.com>, <jejb@parisc-linux.org>,
        <paulmck@linux.vnet.ibm.com>, <dave.anglin@bell.net>, <aswin@hp.com>,
        <linux-kernel@vger.kernel.org>, <linux-parisc@vger.kernel.org>,
        <davem@davemloft.net>, <james.hogan@imgtec.com>, <vgupta@synopsys.com>
Subject: Re: [PATCH 2/2] locking/rwsem: Disable optimistic spinning for PA-RISC
References: <1402070140-15090-1-git-send-email-davidlohr@hp.com> <1402070140-15090-3-git-send-email-davidlohr@hp.com> <1402070987.2207.75.camel@dabdike.int.hansenpartnership.com> <20140606171145.GU13930@laptop.programming.kicks-ass.net>
In-Reply-To: <20140606171145.GU13930@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.9.0.23]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/6/2014 1:11 PM, Peter Zijlstra wrote:
> The thing is, all these archs are broken beyond this particular problem,
> Mikulas Patocka found a number of other spots.
>
> In any case, sure I can exclude more. Although ideally someone goes do
> that __atomic sparse thing to flush out all this.
>
> ---
> Subject: locking, mutex: Disable optimistic spinning on !RMW archs
>
> For some archs a regular store does not play nice with cmpxchg(), the
> optimistic spinning code (and various other places not caught by this)
> break this assumption and make things go boom.
>
> Until something better is found, disable optimistic spinning for these
> archs.
>
> [..]
>   
> +config ARCH_NO_ATOMIC_RMW
> +	def_bool y
> +	depends on PARISC || SPARC32 || METAG_ATOMICITY_LOCK1 || (TILE && !TILEGX) || (ARC && !ARC_HAS_LLSC)

For tile:

Acked-by: Chris Metcalf <cmetcalf@tilera.com>

But you should use "TILEPRO" (added in kernel 3.5) instead of "(TILE && !TILEGX)".

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

