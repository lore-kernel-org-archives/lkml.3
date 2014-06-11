Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824AbaFKJ1d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 05:27:33 -0400
Received: from service87.mimecast.com ([91.220.42.44]:53116 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861AbaFKJ1b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 05:27:31 -0400
Message-ID: <53982106.2050504@arm.com>
Date: Wed, 11 Jun 2014 10:27:34 +0100
From: Dietmar Eggemann <dietmar.eggemann@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Yuyang Du <yuyang.du@intel.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [RFC PATCH 07/16 v3] Init Workload Consolidation flags in sched_domain
References: <1401431772-14320-1-git-send-email-yuyang.du@intel.com> <1401431772-14320-8-git-send-email-yuyang.du@intel.com> <20140603121416.GH30445@twins.programming.kicks-ass.net> <5395F541.60604@arm.com> <20140609211820.GA5361@intel.com> <5396F166.1030401@arm.com> <20140610180954.GB5487@intel.com>
In-Reply-To: <20140610180954.GB5487@intel.com>
X-OriginalArrivalTime: 11 Jun 2014 09:27:23.0185 (UTC) FILETIME=[59C64A10:01CF8557]
X-MC-Unique: 114061110272905601
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/14 19:09, Yuyang Du wrote:
> On Tue, Jun 10, 2014 at 12:52:06PM +0100, Dietmar Eggemann wrote:
> 
> Hi Dietmar,
> 
>> Not in this sense but there is no functionality in the scheduler right
>> now to check constantly if an sd flag has been set/unset via sysctl.
> 
> Sorry, I still don't understand. There are many "if (sd->flags & SD_XXX)"
> in fair.c. What does it mean to you?
> 
> Probably you mean the SD_XX should be fixed in init and never changed via sysctl
> thereafter. Ah... I don't know about this...

yes :-) I'm referring to your top_flag_domain() function which you need
to check what the highest sd level is where your flag is set. Existing
code only relies on flag setup during startup and after cpu hotplug or
on cached per-cpu sd pointers like sd_llc .

> 
> Overall, I think I should come up with a better way to implement the SD_WORKLOAD_CONSOLIDATION
> policy (enabled or disabled) in load balancing (as is also pointed out by PeterZ).
> But I just don't see the current implementation is any particular different than
> any other SD_XX's.
> 
> Have you tried it on your platform?

I'm running these patches on my ARM TC2 (2 clusters (2 CPUs, 3 CPUs)) on
top of kernel/git/torvalds/linux.git (v3.15-rc7-79-gfe45736f4134). By
default, on this platform CC is enabled on MC and CPU level. Overall
workloads show very different behaviour (CC enabled on MC and CPU level
as well as only enabled on MC level) compared to testruns wo/ CC but I
do not have the time to analyse it further. BTW, I hot-plugged out the
3rd CPU on the 2. cluster (there is this comment on top of
__nonshielded_groups() 'every sched_group has the same weight').

-- Dietmar

> 
> Thanks a lot,
> Yuyang
> 


