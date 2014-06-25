Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499AbaFYB6F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 21:58:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50943 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826AbaFYB6D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 21:58:03 -0400
Message-ID: <53AA2C88.1020409@redhat.com>
Date: Tue, 24 Jun 2014 21:57:28 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, chegu_vinod@hp.com, mgorman@suse.de,
        mingo@kernel.org
Subject: Re: [PATCH 8/7] sched,numa: do not let a move increase the imbalance
References: <1403538095-31256-1-git-send-email-riel@redhat.com> <20140623183011.28555a7c@annuminas.surriel.com> <20140624143820.GA28774@twins.programming.kicks-ass.net>
In-Reply-To: <20140624143820.GA28774@twins.programming.kicks-ass.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 06/24/2014 10:38 AM, Peter Zijlstra wrote:

>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c index
>> 4723234..e98d290 100644 --- a/kernel/sched/fair.c +++
>> b/kernel/sched/fair.c @@ -1314,6 +1314,12 @@ static void
>> task_numa_compare(struct task_numa_env *env,
>> 
>> if (moveimp > imp && moveimp > env->best_imp) { /* +		 * A task
>> swap is possible, do not let a task move +		 * increase the
>> imbalance. +		 */ +		int imbalance_pct = env->imbalance_pct; +
>> env->imbalance_pct = 100; +		/*
> 
> I would feel so much better if we could say _why_ this is so.

OK, I think patch 9 supercedes this one.  The imbalance tests
were buggy, that is what caused the problem.

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJTqiyIAAoJEM553pKExN6DCs0IALtGfif7FzFsB+Sf8SkVCjjj
smkFIiSE4JWulnSR+zCtB8nsCyR1vAGBlY5D6Z4TKbfNnXCrsczOfSPK2p4P8nqy
lQ8LyiOn0MkjOy4BAmL4nQsuiBwlNGAG5I2AeesumSjAMCLpFYP+6UuU9UrdPtyF
hKHiafoud2z+zzOoDdKlvb5MIhSwHn8hpBJ51Jlg0AMRMKroEutsYzyzwOErLFTz
4jJ9xOnjmuVaST4qT14JHbwJZYlmolWcvrVeT1AbVvR7pHUuBMwHH4p/PuDa5umO
7srbnDk9Dn856T4JFKQa92dBoXGHjpmRVl37cpqw4PzhlvhMMRKUFvObJZNG8ys=
=NeKl
-----END PGP SIGNATURE-----
