Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128AbaFBRd5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 13:33:57 -0400
Received: from g2t2354.austin.hp.com ([15.217.128.53]:18859 "EHLO
	g2t2354.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbaFBRdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 13:33:55 -0400
Message-ID: <538CB56E.5010709@hp.com>
Date: Mon, 02 Jun 2014 13:33:34 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Mikulas Patocka <mpatocka@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, jejb@parisc-linux.org,
        deller@gmx.de, John David Anglin <dave.anglin@bell.net>,
        linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
        paulmck@linux.vnet.ibm.com, chegu_vinod@hp.com, tglx@linutronix.de,
        riel@redhat.com, akpm@linux-foundation.org, davidlohr@hp.com,
        hpa@zytor.com, andi@firstfloor.org, aswin@hp.com, scott.norton@hp.com,
        Jason Low <jason.low2@hp.com>
Subject: Re: [PATCH v2] introduce atomic_pointer to fix a race condition in
 cancelable mcs spinlocks
References: <alpine.LRH.2.02.1406011342470.20831@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.1406021158360.20627@file01.intranet.prod.int.rdu2.redhat.com> <20140602162525.GH16155@laptop.programming.kicks-ass.net> <20140602163032.GI16155@laptop.programming.kicks-ass.net>
In-Reply-To: <20140602163032.GI16155@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2014 12:30 PM, Peter Zijlstra wrote:
> On Mon, Jun 02, 2014 at 06:25:25PM +0200, Peter Zijlstra wrote:
>> I'm almost inclined to just exclude parisc from using opt spinning.
>>
>> That said, this patch still doesn't address the far more interesting
>> problem of actually finding these issues for these few weird archs.
> So why do these archs provide xchg() and cmpxchg() at all? Wouldn't it
> be much simpler if archs that cannot sanely do this, not provide these
> primitives at all?

I believe xchg() and cmpxchg() are used in quite a number of places 
within the generic kernel code. So kernel compilation will fail if those 
APIs aren't provided by an architecture.

-Longman
