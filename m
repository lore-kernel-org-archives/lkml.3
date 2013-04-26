Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108Ab3DZWwi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 18:52:38 -0400
Received: from one.firstfloor.org ([193.170.194.197]:44367 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002Ab3DZWwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 18:52:37 -0400
Date: Sat, 27 Apr 2013 00:52:35 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Basic perf PMU support for Haswell v11
Message-ID: <20130426225235.GI16732@two.firstfloor.org>
References: <1366484783-15613-1-git-send-email-andi@firstfloor.org>
 <20130426065503.GA31197@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130426065503.GA31197@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> How well was this 
> patch-set tested on non-Haswell hardware, which makes up 99.99% of our 
> installed base?

I tested on a couple systems now and then: usually Haswell, IvyBridge,
sometimes also Westmere and Atom. I don't retest every iteration,
as you know most of the changes you're requesting don't affect
the binary.

My test bed is likely to be smaller than yours though and as usual
as you well know some part of the kernel QA is after release.

> 
> In particular, after applying your patches, 'perf top' stopped working on 
> an Intel testbox of mine:
> 
>   processor       : 15
>   vendor_id       : GenuineIntel
>   cpu family      : 6
>   model           : 26
>   model name      : Intel(R) Xeon(R) CPU           X55600 @ 2.80GHz

I assume the second 0 is a typo?

>   stepping        : 5

> 'perf top' just does not produce any profiling output - it says 0 events.

Thanks for testing.

I found a similar system (not same stepping, but same model) and tested
perf top works fine here. Also on a couple of other systems.

Since I cannot reproduce I would need your help debugging it.

I assume it worked before my patches.  If you don't know
please double check. Also I assume there's no general
problem between the user land perf you used and the kernel.

The only patch I could think of which may affect other systems
is the moving of the APIC ack.

So does it work if you revert 

 perf, x86: Move NMI clearing to end of PMI handler after ...

If that is it we could white list it for Haswell.

If that's not it I may need a bisect, assuming the problem is stable.

-Andi
