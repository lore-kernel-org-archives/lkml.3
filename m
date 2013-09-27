Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab3I0JPs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 05:15:48 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:60404 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab3I0JPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 05:15:45 -0400
Message-ID: <1380273341.30872.1.camel@edumazet-glaptop.roam.corp.google.com>
Subject: Re: [PATCH 1/4] [RFC] net: Explicitly initialize u64_stats_sync
 structures for lockdep
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Roger Luethi <rl@hellgate.ch>, Patrick McHardy <kaber@trash.net>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>, Julian Anastasov <ja@ssi.bg>,
        Jesse Gross <jesse@nicira.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Date: Fri, 27 Sep 2013 02:15:41 -0700
In-Reply-To: <20130927054455.GA6597@gmail.com>
References: <1380220464-28840-1-git-send-email-john.stultz@linaro.org>
	 <1380220464-28840-2-git-send-email-john.stultz@linaro.org>
	 <1380223585.3165.205.camel@edumazet-glaptop>
	 <20130927054455.GA6597@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-09-27 at 07:44 +0200, Ingo Molnar wrote:

> C cannot pass along symbolic names, unfortunately, so we are stuck with 
> 1970's tech and the C preprocessor.
> 

Yes, I realized that a bit too late.

> There's a way to make such macros look a tiny bit more structured and thus 
> be more palatable:
> 
> #if BITS_PER_LONG == 32 && defined(CONFIG_SMP)
> # define u64_stats_init(syncp) seqcount_init(syncp.seq)
> #else
> # define u64_stats_init(syncp)
> #endif
> 
> Note, the 'else' branch should probably be:
> 
> # define u64_stats_init(syncp) do { } while (0)

Yes, this is better ;)

Thanks !


