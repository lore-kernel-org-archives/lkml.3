Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab3LTEFj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 23:05:39 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:63656 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab3LTEFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 23:05:37 -0500
Message-ID: <1387512333.4860.11.camel@marge.simpson.net>
Subject: Re: lockdep: BUG: MAX_LOCKDEP_ENTRIES too low!
From: Mike Galbraith <bitbucket@online.de>
To: Dave Jones <davej@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sasha.levin@oracle.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 20 Dec 2013 05:05:33 +0100
In-Reply-To: <20131219155917.GB25771@redhat.com>
References: <52B289F4.7060205@oracle.com>
	 <20131219103401.GE30183@twins.programming.kicks-ass.net>
	 <52B2FC66.9010309@oracle.com>
	 <20131219152002.GK16438@laptop.programming.kicks-ass.net>
	 <52B3134D.2010203@oracle.com>
	 <20131219155121.GL16438@laptop.programming.kicks-ass.net>
	 <20131219155917.GB25771@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:5jzCqMsZO4OAdI23idgLU5b8v7lAsstzPhUV+LtnSvu
 64TDkmkDO476cLPR7iqvyptRGVNTBiypQ9TUrHx/f0swv1nzE/
 HeRroB1EG+oxURzWwizmogCeMlJx+0RUjRrxtuLIScqnCxvRgZ
 kHlPtc+9IxEo7IR7lYGn0FhSjuuG3XF3W2k+++iGMzRQBBgtds
 mvS8OnqxkO/ugzk7Z/WjOvIF5SBv0yTHqMsxP6fE0Zy1cL8PpA
 dukR6WFLpscgV5PcbXQ+Fbst0gjPVDB9+8Km9PkuehMTUk9f3+
 y+LFL0uhOQ6GSwaPmFV7FMaRJ8WpslMQIORwBK0YU2kODPWW+C
 68cVs/LUGrXvKFCA0a41NLVQc3/X+Ivv34q0phAtxFYPbSdjWs
 Hv0u6vicheyWQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-12-19 at 10:59 -0500, Dave Jones wrote: 
> On Thu, Dec 19, 2013 at 04:51:21PM +0100, Peter Zijlstra wrote:
>  > On Thu, Dec 19, 2013 at 10:39:57AM -0500, Sasha Levin wrote:
>  > > That discusses lockdep classes, which is actually fine in my case. I ran out of
>  > > MAX_LOCKDEP_ENTRIES, which isn't mentioned anywhere in Documentation/ .
>  > 
>  > Yeah, it suffers from the same problem though. Lockdep has static
>  > resource allocation and never frees them.
>  > 
>  > The lock classes are the smallest pool and usually run out first, but
>  > the same could happen for the entries, after all, the more classes we
>  > have the more class connections can happen.
>  > 
>  > Anyway, barring a leak and silly class mistakes like mentioned in the
>  > document there's nothing we can do except raise the number.
> 
> I tried this. When you bump it to 32k, it fares better but then you
> start seeing "BUG: MAX_LOCKDEP_CHAINS too low!" instead.
> I've not tried bumping that yet, as I've stopped seeing these lately
> due to hitting more serious bugs first.

I had the same problem while testdriving a 3.6-rt kernel with lots of
debug enabled.. had to double both ENTRIES/CHAINS to keep lockdep from
running away in a snit.

-Mike

