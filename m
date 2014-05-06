Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390AbaEFUVe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 16:21:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47364 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754028AbaEFUVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 16:21:31 -0400
Message-ID: <5369442B.9010505@redhat.com>
Date: Tue, 06 May 2014 16:20:59 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Preeti Murthy <preeti.lkml@gmail.com>, umgwanakikbuti@gmail.com,
        LKML <linux-kernel@vger.kernel.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Ingo Molnar <mingo@kernel.org>, george.mccollister@gmail.com,
        ktkhai@parallels.com, Preeti U Murthy <preeti@linux.vnet.ibm.com>
Subject: Re: [PATCH RFC/TEST] sched: make sync affine wakeups work
References: <20140502004237.79dd3de6@annuminas.surriel.com> <1399011219.5233.55.camel@marge.simpson.net> <53633B81.1080403@redhat.com> <CAM4v1pPwe4B0K8MPpf183LqabRoRKRPi_R7n8-Y02aR43M8iQQ@mail.gmail.com> <53663565.9080306@redhat.com> <20140506132516.GJ11096@twins.programming.kicks-ass.net>
In-Reply-To: <20140506132516.GJ11096@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2014 09:25 AM, Peter Zijlstra wrote:
> On Sun, May 04, 2014 at 08:41:09AM -0400, Rik van Riel wrote:
>> Even on 8-node DL980 systems, the NUMA distance in the
>> SLIT table is less than RECLAIM_DISTANCE, and we will
>> do wake_affine across the entire system.
> 
> Yeah, so the problem is that (AFAIK) ACPI doesn't actually specify a
> metric for the SLIT distance. This (in as far as BIOS people would care
> to stick to specs anyhow) has lead to the 'fun' situation where BIOS
> engineers tweak SLIT table values to make OSes behave as they thing it
> should.
> 
> So if the BIOS engineer finds that this system should have <
> RECLAIM_DISTANCE it will simply make the table such that the max SLIT
> value is below that.
> 
> And yes, I've seen this :-(

It appears to be the case on the vast majority of the NUMA
systems that are actually in use.

To me, this suggests that we should probably deal with it.

-- 
All rights reversed
