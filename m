Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356AbaEFUT6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 16:19:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60666 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755240AbaEFUT4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 16:19:56 -0400
Message-ID: <536943C9.4030502@redhat.com>
Date: Tue, 06 May 2014 16:19:21 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Mike Galbraith <umgwanakikbuti@gmail.com>, linux-kernel@vger.kernel.org,
        morten.rasmussen@arm.com, mingo@kernel.org,
        george.mccollister@gmail.com, ktkhai@parallels.com
Subject: Re: [PATCH RFC/TEST] sched: make sync affine wakeups work
References: <20140502004237.79dd3de6@annuminas.surriel.com> <1399011219.5233.55.camel@marge.simpson.net> <53633B81.1080403@redhat.com> <1399016273.5233.94.camel@marge.simpson.net> <536379D0.8070306@redhat.com> <1399030032.5233.142.camel@marge.simpson.net> <5363B793.9010208@redhat.com> <20140506115448.GH11096@twins.programming.kicks-ass.net>
In-Reply-To: <20140506115448.GH11096@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2014 07:54 AM, Peter Zijlstra wrote:
> On Fri, May 02, 2014 at 11:19:47AM -0400, Rik van Riel wrote:
>> As an aside, it also looks like SD_BALANCE_WAKE is set on all domains
>> of a NUMA system by default, so even the non-affine wakeup will end
>> up looking for the lowest load NUMA node to start up on.
> 
> I can't find it being set on anything by default.

                .flags                  = 1*SD_LOAD_BALANCE
                                        | 1*SD_BALANCE_NEWIDLE
                                        | 0*SD_BALANCE_EXEC
                                        | 0*SD_BALANCE_FORK
                                        | 0*SD_BALANCE_WAKE
                                        | 0*SD_WAKE_AFFINE
                                        | 0*SD_SHARE_CPUPOWER
                                        | 0*SD_SHARE_PKG_RESOURCES
                                        | 1*SD_SERIALIZE
                                        | 0*SD_PREFER_SIBLING
                                        | 1*SD_NUMA
                                        | sd_local_flags(level)


static inline int sd_local_flags(int level)
{
        if (sched_domains_numa_distance[level] > RECLAIM_DISTANCE)
                return 0;

        return SD_BALANCE_EXEC | SD_BALANCE_FORK | SD_WAKE_AFFINE;
}

-- 
All rights reversed
