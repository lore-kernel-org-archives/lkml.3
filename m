Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934973Ab3BTILY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 03:11:24 -0500
Received: from mga11.intel.com ([192.55.52.93]:14590 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934186Ab3BTILX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 03:11:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,699,1355126400"; 
   d="scan'208";a="289441708"
Message-ID: <51248541.3030004@intel.com>
Date: Wed, 20 Feb 2013 16:11:45 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>, peterz@infradead.org
CC: Joonsoo Kim <iamjoonsoo.kim@lge.com>, torvalds@linux-foundation.org,
        mingo@redhat.com, tglx@linutronix.de, akpm@linux-foundation.org,
        arjan@linux.intel.com, bp@alien8.de, pjt@google.com,
        namhyung@kernel.org, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org,
        morten.rasmussen@arm.com
Subject: Re: [patch v5 10/15] sched: packing transitory tasks in wake/exec
 power balancing
References: <1361164062-20111-1-git-send-email-alex.shi@intel.com>  <1361164062-20111-11-git-send-email-alex.shi@intel.com>  <20130218084439.GB10009@lge.com> <5121ECD9.3020300@intel.com>  <5124654E.8040001@intel.com> <1361346030.5919.63.camel@marge.simpson.net>
In-Reply-To: <1361346030.5919.63.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2013 03:40 PM, Mike Galbraith wrote:
> On Wed, 2013-02-20 at 13:55 +0800, Alex Shi wrote:
> 
>> Joonsoo Kim suggests not packing exec task, since the old task utils is
>> possibly unuseable.
> 
> (I'm stumbling around in rtmutex PI land, all dazed and confused, so
> forgive me if my peripheral following of this thread is off target;)
> 
> Hm, possibly.  Future behavior is always undefined, trying to predict
> always a gamble... so it looks to me like not packing on exec places a
> bet against the user, who chose to wager that powersaving will happen
> and it won't cost him too much, if you don't always try to pack despite
> any risks.  The user placed a bet on powersaving, not burst performance.
> 
> Same for the fork, if you spread to accommodate a potential burst, you
> bin the power wager, so maybe it's not in his best interest.. fork/exec
> is common, if it's happening frequently, you'll bin the potential power
> win frequently, reducing effectiveness, and silently trading power for
> performance when the user asked to trade performance for a lower
> electric bill.
> 
> Dunno, just a thought, but I'd say for powersaving policy, you have to
> go just for broke and hope it works out.  You can't know it won't, but
> you'll toss potential winnings every time you don't roll the dice.


Sounds reasonable too.

I have no idea of the of the decision now.
And guess many guys dislike to use a knob to let user do the choice.

What's your opinions, Peter?
> 
> -Mike
> 


-- 
Thanks Alex
