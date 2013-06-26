Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740Ab3FZQPO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 12:15:14 -0400
Received: from relay3.sgi.com ([192.48.152.1]:47146 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752654Ab3FZQPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 12:15:11 -0400
Message-ID: <51CB138B.5010500@sgi.com>
Date: Wed, 26 Jun 2013 09:15:07 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Nathan Zimmer <nzimmer@sgi.com>,
        holt@sgi.com, rob@landley.net, tglx@linutronix.de, mingo@redhat.com,
        yinghai@kernel.org, gregkh@linuxfoundation.org, x86@kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC] Transparent on-demand memory setup initialization embedded
 in the (GFP) buddy allocator
References: <1371831934-156971-1-git-send-email-nzimmer@sgi.com> <1371831934-156971-3-git-send-email-nzimmer@sgi.com> <20130623092840.GB13445@gmail.com> <20130624203657.GA107621@asylum.americas.sgi.com> <20130625073819.GC11420@gmail.com> <51C9D1D6.20405@sgi.com> <51C9E4B7.2000007@zytor.com> <51C9E6CD.5080508@sgi.com> <20130626092248.GB27025@gmail.com> <20130626062850.a7ce5806.akpm@linux-foundation.org> <20130626133715.GA6424@gmail.com>
In-Reply-To: <20130626133715.GA6424@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 6/26/2013 6:37 AM, Ingo Molnar wrote:
> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
>> On Wed, 26 Jun 2013 11:22:48 +0200 Ingo Molnar <mingo@kernel.org> wrote:
>>
>>> except that on 32 TB 
>>> systems we don't spend ~2 hours initializing 8,589,934,592 page heads.
>>
>> That's about a million a second which is crazy slow - even my 
>> prehistoric desktop is 100x faster than that.
>>
>> Where's all this time actually being spent?
> 
> See the earlier part of the thread - apparently it's spent initializing 
> the page heads - remote NUMA node misses from a single boot CPU, going 
> across a zillion cross-connects? I guess there's some other low hanging 
> fruits as well - so making this easier to profile would be nice. The 
> profile posted was not really usable.

This is one advantage of delayed memory init.  I can do it under
the profiler.  I will put everything together to accomplish this
and then send a perf report.

> 
> Btw., NUMA locality would be another advantage of on-demand 
> initialization: actual users of RAM tend to allocate node-local 
> (especially on large clusters), so any overhead will be naturally lower.
> 
> Thanks,
> 
> 	Ingo
> 
