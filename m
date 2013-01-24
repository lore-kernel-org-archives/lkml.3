Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004Ab3AXIPH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 03:15:07 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:40230 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777Ab3AXIPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 03:15:02 -0500
Message-ID: <5100ED7A.303@linux.vnet.ibm.com>
Date: Thu, 24 Jan 2013 16:14:50 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Mike Galbraith <bitbucket@online.de>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, peterz@infradead.org,
        mingo@kernel.org, a.p.zijlstra@chello.nl
Subject: Re: [RFC PATCH 0/2] sched: simplify the select_task_rq_fair()
References: <1356588535-23251-1-git-send-email-wangyun@linux.vnet.ibm.com> <50FD08E1.8000302@linux.vnet.ibm.com> <1358761496.4994.118.camel@marge.simpson.net> <50FE0ADC.6060701@linux.vnet.ibm.com> <1358841795.5782.255.camel@marge.simpson.net> <50FE5433.1070801@linux.vnet.ibm.com> <1358865692.5782.420.camel@marge.simpson.net> <50FF4EA0.1070000@linux.vnet.ibm.com> <1358915494.5752.46.camel@marge.simpson.net> <50FF7086.4020509@linux.vnet.ibm.com> <1358922520.5752.91.camel@marge.simpson.net> <50FF8CD8.4060105@linux.vnet.ibm.com>	 <1358929257.5752.109.camel@marge.simp! son.net>	 <50FF9F92.60202@linux.vnet.ibm.com> <1358930968.5752.123.camel@marge.simpson.net> <50FFA695.6010407@linux.vnet.ibm.com> <1358932694.5752.126.camel@marge.simpson.net> <1358933555.5752.132.camel@marge.simpson.net> <5100CE1F.7080704@linux.vnet.ibm.com> <1359010272.5833.39.camel@marge.simpson.net> <5100DF95.3020909@linux.vnet.ibm.com> <1359013623.5833.52.camel@marge.simpson.net>
In-Reply-To: <1359013623.5833.52.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012408-5140-0000-0000-000002AB6AA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2013 03:47 PM, Mike Galbraith wrote:
> On Thu, 2013-01-24 at 15:15 +0800, Michael Wang wrote: 
>> On 01/24/2013 02:51 PM, Mike Galbraith wrote:
>>> On Thu, 2013-01-24 at 14:01 +0800, Michael Wang wrote:
>>>
>>>> I've enabled WAKE flag on my box like you did, but still can't see
>>>> regression, and I've just tested on a power server with 64 cpu, also
>>>> failed to reproduce the issue (not compared with virgin yet, but can't
>>>> see collapse).
>>>
>>> I'm not surprised.  I'm seeing enough inconsistent crap to come to the
>>> conclusion that stock scheduler knobs flat can't be used on a largish
>>> box, they're just too preempt-happy, leading to weird crap.
>>>
>>> My 2 missing nodes came back, and the very same kernel that highly
>>> repeatably collapsed with 2 nodes does not with 4 nodes, and 2 nodes
>>> does not collapse with only preemption knob tweaking, and that's
>>> bullshit.  Virgin shows instability in the mid-range, make a tiny tweak
>>> that should have little if any effect there, and that instability
>>> vanishes entirely.  Test runs are not consistent enough boot to boot etc
>>> etc.  Either stock knobs suck on NUMA boxen, or this box is possessed.
>>
>> Mike, I wonder the reason why change back to the old way make collapse
>> away may not because there are logical error in new balance path, it's
>> just changed the cost of select_task_rq(), whatever it's more or less,
>> it's accidentally achieve the same effect as you tweak the knob, so
>> that's the reason why it looks like old is better than new.
> 
> That's what I'm saying, it's a useless crap side-effect of a preempt
> happy kernel.  Results with these knobs are just not stable.  Results go
> wildly unstable with 2 nodes vs 4 in this box, but can be stabilized in
> all with preemption knob adjustment.. or phase of moon might make them
> appear stable.. or not.

Yeah, it's time to stop blame the patch now, it's not the real killer on
your box.

Well, at least it's worth to be tortured on it, we found several points
I missed, we are more familiar with the balance path, and we found some
places we could do better, all these are because your kindly help, it's
nice to work with you ;-)

Now it's time to work on v3 I think, let's see what we could get this time.

Regards,
Michael Wang

> 
> -Mike
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

