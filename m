Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708Ab3KDRdO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 12:33:14 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:14480 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940Ab3KDRdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 12:33:13 -0500
Message-ID: <5277DA4E.3050300@hp.com>
Date: Mon, 04 Nov 2013 12:33:02 -0500
From: Don Morris <don.morris@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: LKML <linux-kernel@vger.kernel.org>, David Rientjes <rientjes@google.com>
Subject: Re: BUG: soft lockup - CPU#8 stuck for 22s!
References: <5266B5F2.5070102@hp.com> <20131104170413.GA25764@suse.de>
In-Reply-To: <20131104170413.GA25764@suse.de>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2013 12:04 PM, Mel Gorman wrote:
> On Tue, Oct 22, 2013 at 01:29:22PM -0400, Don Morris wrote:
>> Greetings, all.
>>
>> Just wanted to drop this out there to see if it rang any bells.
>> I've been getting a soft lockup (numad thread stuck on a cpu
>> while attempting to attach a task to a cgroup) for a while now,
>> but I thought it was only happening when I applied Mel Gorman's
>> set of AutoNUMA patches.
> 
> This maybe?

Certainly would make sense. My appreciation for taking a look
at it.

I happen to be on the road today, however -- and away from the
reproduction environment. I'll give it a shot tomorrow morning
and either let you know if it fixes things or report the sysrq-t
output you requested.

Again, my thanks!
Don Morris

> 
> ---8<---
> mm: memcontrol: Release css_set_lock when aborting an OOM scan
> 
> css_task_iter_start acquires the css_set_lock and it must be released with
> a call to css_task_iter_end. Commmit 9cbb78bb (mm, memcg: introduce own
> oom handler to iterate only over its own threads) introduced a loop that
> was not guaranteed to call css_task_iter_end.
> 
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 5ef8929..941f67d 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1795,6 +1795,7 @@ static void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  				mem_cgroup_iter_break(memcg, iter);
>  				if (chosen)
>  					put_task_struct(chosen);
> +				css_task_iter_end(&it);
>  				return;
>  			case OOM_SCAN_OK:
>  				break;
> .
> 


-- 
kernel, n:
A part of an operating system that preserves the medieval traditions
of sorcery and black art.
