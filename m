Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667AbaHMNYm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 09:24:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42907 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751637AbaHMNYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 09:24:41 -0400
Message-ID: <53EB66F6.2050304@redhat.com>
Date: Wed, 13 Aug 2014 09:24:06 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <umgwanakikbuti@gmail.com>
CC: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Frank Mayhar <fmayhar@google.com>,
        Frederic Weisbecker <fweisbec@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sanjay Rao <srao@redhat.com>, Larry Woodman <lwoodman@redhat.com>
Subject: Re: [PATCH RFC] time: drop do_sys_times spinlock
References: <20140812142539.01851e52@annuminas.surriel.com> <20140812191218.GA15210@redhat.com> <1407913190.5542.50.camel@marge.simpson.net> <20140813111112.GJ9918@twins.programming.kicks-ass.net>
In-Reply-To: <20140813111112.GJ9918@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 08/13/2014 07:11 AM, Peter Zijlstra wrote:
> On Wed, Aug 13, 2014 at 08:59:50AM +0200, Mike Galbraith wrote:
> 
>> I was told that clock_gettime(CLOCK_PROCESS_CPUTIME_ID) has
>> scalability issues on BIG boxen
> 
>> I'm sure the real clock_gettime() using proggy that gummed up a
>> ~1200 core box for "a while" wasn't the testcase below, which
>> will gum it up for a long while, but looks to me like using
>> CLOCK_PROCESS_CPUTIME_ID from LOTS of threads is a "Don't do
>> that, it'll hurt a LOT".
> 
> Yes, don't do that. Its unavoidably slow and bad.

I don't see why that needs the tasklist_lock, when do_sys_times
grabs a different lock.

If the same bottleneck exists from multiple places, maybe it does
make sense to have a seqlock for the statistics at the sighand
level?

I can code up a patch that does that, and throw it over the wall
to people with big systems who hit that bottleneck on a regular
basis...

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJT62b2AAoJEM553pKExN6DBJ4H/AyVsN4N73Gp/wrm7waaNjpS
kU5R2pIGzJqxJ4BZi+aeiuT09ZoSHCl3nvSsMNBm712NX1jyFVC4I91ON18tsB3o
P/tipcCP9Q6QSW8+lPRNz459OsaXX+wyRxcdnUtZN7SVb+NTWlxZ4o8UiVljZYSV
2mRr2ipd/0vKn7J9twaIP0UMddTpIrnMTCMKookoWXoHeJIXsYAs3XTRsoPJAddz
0ba5H7OGjphOSCyMkDDo3GG+K8oHJIpD8PHT38pXfX+suNEGxMO7PGvvEyUcrJKx
5355fnU6/1mksPlRD5DIwMowMjbY5zy71P8Lv4Eg+LY+C/kGjyrz9Maa0SyRMh8=
=VQ/m
-----END PGP SIGNATURE-----
