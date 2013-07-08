Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213Ab3GHIvP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 04:51:15 -0400
Received: from mga14.intel.com ([143.182.124.37]:49878 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717Ab3GHIvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 04:51:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1019,1363158000"; 
   d="scan'208";a="265321596"
Message-ID: <51DA7D77.3000806@intel.com>
Date: Mon, 08 Jul 2013 16:51:03 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, mingo@kernel.org, eranian@google.com,
        andi@firstfloor.org
Subject: Re: [PATCH v2 3/7] perf, x86: Introduce x86 special perf event context
References: <1372663387-11754-1-git-send-email-zheng.z.yan@intel.com> <1372663387-11754-4-git-send-email-zheng.z.yan@intel.com> <20130704124148.GI23916@twins.programming.kicks-ass.net> <51D63B43.9050604@intel.com> <20130705124500.GS23916@twins.programming.kicks-ass.net>
In-Reply-To: <20130705124500.GS23916@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2013 08:45 PM, Peter Zijlstra wrote:
> On Fri, Jul 05, 2013 at 11:19:31AM +0800, Yan, Zheng wrote:
>> On 07/04/2013 08:41 PM, Peter Zijlstra wrote:
>>> It should be *optional*, also wtf is that parent_ctx thing for?
>>
>> parent_ctx is for the fork() case, used for checking if the callstack feature
>> is enabled for the parent task. If yes, clone  parent task's LBR stack.
>> For the simple program below:
> 
> So there's a problem with all this; contexts aren't strict per task, we
> play games with them in perf_event_context_sched_out(). We'd have to
> disable that context switch optimization for LBR stack to work and
> that's massively expensive.
> 

Sorry, I didn't realize the optimization. I will describe my change in more details
in the further.

Yan, Zheng

> If you actually did that, you again fail for not having mentioned this
> in your changelog.
> 
> I'm starting to not want to read patches from you; going through them is
> just too much effort, I might as well write the stuff myself :/
> 

