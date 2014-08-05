Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635AbaHEVno (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 17:43:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36390 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752020AbaHEVnn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 17:43:43 -0400
Message-ID: <53E14FF1.50904@redhat.com>
Date: Tue, 05 Aug 2014 17:43:13 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Aaron Lu <aaron.lu@intel.com>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org, jhladky@redhat.com
Subject: Re: [LKP] [sched/numa] a43455a1d57: +94.1% proc-vmstat.numa_hint_faults_local
References: <53d70ee6.JsUEmW5dWsv8dev+%fengguang.wu@intel.com> <53D72FF5.90908@intel.com> <20140729023940.37b6aebc@annuminas.surriel.com> <20140729081712.GS20603@laptop.programming.kicks-ass.net> <20140729160437.4561742f@annuminas.surriel.com> <20140730021425.GA25023@aaronlu.sh.intel.com> <53D9003F.3050900@redhat.com> <20140731050454.GA9386@aaronlu.sh.intel.com>
In-Reply-To: <20140731050454.GA9386@aaronlu.sh.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 07/31/2014 01:04 AM, Aaron Lu wrote:

>>>> +++ b/kernel/sched/fair.c @@ -924,10 +924,12 @@ static inline
>>>> unsigned long group_faults_cpu(struct numa_group *group, int
>>>> nid)
>>>> 
>>>> /* * These return the fraction of accesses done by a
>>>> particular task, or - * task group, on a particular numa
>>>> node.  The group weight is given a - * larger multiplier, in
>>>> order to group tasks together that are almost - * evenly
>>>> spread out between numa nodes. + * task group, on a
>>>> particular numa node.  The NUMA move threshold + * prevents
>>>> task moves with marginal improvement, and is set to 5%. */ 
>>>> +#define NUMA_SCALE 1024 +#define NUMA_MOVE_THRESH (5 *
>>>> NUMA_SCALE / 100)
>> 
>> It would be good to see if changing NUMA_MOVE_THRESH to 
>> (NUMA_SCALE / 8) does the trick.
> 
> With your 2nd patch and the above change, the result is:

Peter,

the threshold does not seem to make a difference for the
performance tests on my system, I guess you can drop this
patch :)

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJT4U/xAAoJEM553pKExN6DY4oH/ihJDmcCSZ0sKqGbyzJqLrFY
KWCEXhfiN6hQJBrmeOvrbzlHsMH0LzYfgTVnc1nteAcnUXiBeqkgxwf+S1dmvoFr
DZSxC+9tQ68ho0YcLd7rpEMfsnwOQAB9BgX8GxxwMb8q5zZ9Bz3r9NKVF0P2D3cj
eeJ8Z3EGaKOteVhwAPVPeuTf7xwhqoqp4ujLgTL7BcaifqvGhi3+uo9/KcavE15d
eale3MuhbCIsAQeyB4SwgGwilE/oZTPTos4BNdUrIyxO4nDajbeLb1qsLSHYcirH
CA7++bTE9V6TvO1tBLVpeYdSAGcDKKUBHM6N+0UDwkR/Tp4oRyQ115Peo2H34ak=
=kFxZ
-----END PGP SIGNATURE-----
