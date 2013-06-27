Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105Ab3F0DtO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 23:49:14 -0400
Received: from one.firstfloor.org ([193.170.194.197]:39599 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904Ab3F0DtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 23:49:13 -0400
Date: Thu, 27 Jun 2013 05:49:11 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu, acme@redhat.com,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        mlpesant@us.ibm.com
Subject: Re: [PATCH 15/15] perf, tools: Add perf stat --transaction v3
Message-ID: <20130627034911.GO6123@two.firstfloor.org>
References: <1366485563-16209-1-git-send-email-andi@firstfloor.org>
 <1366485563-16209-16-git-send-email-andi@firstfloor.org>
 <20130619085159.GA25177@concordia>
 <20130619144621.GW6123@two.firstfloor.org>
 <20130627031854.GA9793@concordia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130627031854.GA9793@concordia>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> OK. I'm still confused by that one sorry. In the patch you do:
> 
> +       else if (perf_evsel__cmp(counter, nth_evsel(T_CYCLES_IN_TX_CP)))
> +               update_stats(&runtime_cycles_in_txcp_stats[0], count[0]);
> 
> But then I don't see where you use runtime_cycles_in_txcp_stats ?

You're right that variable is not needed. I'll remove it. 
It only needs the in_tx stat.

intx-cp is still output, but directly by abs_printout,
without going through a variable.

> 
> > > But I don't think we have anything equivalent.
> > 
> > But you have cycles-t and tx-start?
> 
> We have:
>  - cycles
>  - cycles in transactional state
>  - cycles spent in successful transactions
> 
> So your cycles-t is "cycles in transactional state".
> 
> We would calculate cycles wasted in aborts with:
> 
>  "cycles in transactional" - "cycles in successful transactions"
> 
> Which I think is what you're describing above with cycles-ct.

Yes, that should be equivalent.
That should be easy to check for and handle: check for that 
event and switch the formula around.
I'll leave that to you as I don't have any way to test it.

> Does "tx-start" just count the number of transactions begun? Does it
> count nested transactions?

Just begun without nesting (TSX flattens all transactions)

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
