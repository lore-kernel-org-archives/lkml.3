Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964832AbaEQQZ3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 12:25:29 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:39555 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932115AbaEQQZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 12:25:28 -0400
Message-ID: <53778D40.5020203@oracle.com>
Date: Sat, 17 May 2014 12:24:32 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Dave Jones <davej@redhat.com>,
        price@mit.edu
Subject: Re: BUG_ON drivers/char/random.c:986 (Was: perf: use after free in
 perf_remove_from_context)
References: <5370EBE9.6@oracle.com> <20140516153455.GV11096@twins.programming.kicks-ass.net> <53763775.3040602@linux.intel.com> <20140516162117.GY11096@twins.programming.kicks-ass.net> <1400287582.11005.118359877.7B81534B@webmail.messagingengine.com> <20140517021840.GA5513@thunk.org>
In-Reply-To: <20140517021840.GA5513@thunk.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2014 10:18 PM, Theodore Ts'o wrote:
> On Fri, May 16, 2014 at 05:46:22PM -0700, Hannes Frederic Sowa wrote:
>> > This should do the trick:
>> > dd if=/dev/urandom of=/dev/zero bs=67108707
>> > 
>> > I suspect ee1de406ba6eb1 ("random: simplify accounting logic") as the
>> > culprit.
> Yep, that it's it.  Thanks for noticing this so quickly!  I'll push
> the following patch to Linus.

Peter, could you describe the infrastructure you're running on? I don't
think Dave or myself have ever hit this issue, and I wonder what made you
stumble on it.


Thanks,
Sasha
