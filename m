Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124Ab3LSQwF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 11:52:05 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:28525 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777Ab3LSQwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 11:52:03 -0500
Message-ID: <52B32410.9050802@oracle.com>
Date: Thu, 19 Dec 2013 11:51:28 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: lockdep: BUG: MAX_LOCKDEP_ENTRIES too low!
References: <52B289F4.7060205@oracle.com> <20131219103401.GE30183@twins.programming.kicks-ass.net> <52B2FC66.9010309@oracle.com> <20131219152002.GK16438@laptop.programming.kicks-ass.net> <52B3134D.2010203@oracle.com> <20131219155121.GL16438@laptop.programming.kicks-ass.net> <20131219155917.GB25771@redhat.com>
In-Reply-To: <20131219155917.GB25771@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2013 10:59 AM, Dave Jones wrote:
> On Thu, Dec 19, 2013 at 04:51:21PM +0100, Peter Zijlstra wrote:
>   > On Thu, Dec 19, 2013 at 10:39:57AM -0500, Sasha Levin wrote:
>   > > That discusses lockdep classes, which is actually fine in my case. I ran out of
>   > > MAX_LOCKDEP_ENTRIES, which isn't mentioned anywhere in Documentation/ .
>   >
>   > Yeah, it suffers from the same problem though. Lockdep has static
>   > resource allocation and never frees them.
>   >
>   > The lock classes are the smallest pool and usually run out first, but
>   > the same could happen for the entries, after all, the more classes we
>   > have the more class connections can happen.
>   >
>   > Anyway, barring a leak and silly class mistakes like mentioned in the
>   > document there's nothing we can do except raise the number.
>
> I tried this. When you bump it to 32k, it fares better but then you
> start seeing "BUG: MAX_LOCKDEP_CHAINS too low!" instead.
> I've not tried bumping that yet, as I've stopped seeing these lately
> due to hitting more serious bugs first.

Yeah, I see what you're saying. After upping that to 32k I've hit MAX_STACK_TRACE_ENTRIES.

Going to try upping that and see how that goes.


Thanks,
Sasha
