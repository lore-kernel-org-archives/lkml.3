Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022Ab3EHNam (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 09:30:42 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:49183 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755776Ab3EHNaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 09:30:39 -0400
Message-ID: <518A5349.4030303@oracle.com>
Date: Wed, 08 May 2013 09:29:45 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130429 Thunderbird/17.0.5
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: torvalds@linux-foundation.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/9] liblockdep: Support using LD_PRELOAD
References: <1367348080-4680-1-git-send-email-sasha.levin@oracle.com> <1367348080-4680-8-git-send-email-sasha.levin@oracle.com> <20130508102220.GB6131@dyad.programming.kicks-ass.net>
In-Reply-To: <20130508102220.GB6131@dyad.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

Thanks for your comments! I'll address them and re-send the patch series.

On 05/08/2013 06:22 AM, Peter Zijlstra wrote:
>> +	/*
>> > +	 * Some programs attempt to initialize and use locks in their
>> > +	 * allocation path. This means that a call to malloc() would
>> > +	 * result in locks being initialized and locked.
>> > +	 *
>> > +	 * Why is it an issue for us? dlsym() below will try allocating to
>> > +	 * give us the original function. Since this allocation will result
>> > +	 * in a locking operations, we have to let pthread deal with it,
>> > +	 * but we can't! we don't have the pointer to the original API
>> > +	 * since we're inside dlsym() trying to get it :(
>> > +	 *
>> > +	 * We can work around it by telling the program that locking was
>> > +	 * really okay, and just initialize those locks when we're fully
>> > +	 * up and running (this is ok because this all happens during
>> > +	 * initialization phase, when we have just one thread). But
>> > +	 * this is a big TODO at this point.
>> > +	 */
> Fun.. got any example programs that trigger this?

firefox.

The problem there is that it uses jemalloc, which tries to do what I've
described in the blurb above.


Thanks,
Sasha
