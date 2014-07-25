Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759913AbaGYIeu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 04:34:50 -0400
Received: from mga11.intel.com ([192.55.52.93]:43114 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818AbaGYIes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 04:34:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,729,1400050800"; 
   d="scan'208";a="567074161"
Message-ID: <53D216A4.3090600@intel.com>
Date: Fri, 25 Jul 2014 16:34:44 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org
Subject: Re: [PATCH v3 6/9] perf, x86: handle multiple records in PEBS buffer
References: <1406016602-31845-1-git-send-email-zheng.z.yan@intel.com> <1406016602-31845-7-git-send-email-zheng.z.yan@intel.com> <20140725081033.GV3935@laptop>
In-Reply-To: <20140725081033.GV3935@laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2014 04:10 PM, Peter Zijlstra wrote:
> On Tue, Jul 22, 2014 at 04:09:59PM +0800, Yan, Zheng wrote:
>> One corner case needs to mention is that the PEBS hardware doesn't
>> deal well with collisions, when PEBS events happen near to each
>> other. The records for the events can be collapsed into a single
>> one. However in practice collisions are extremely rare, as long as
>> different events are used. The periods are typically very large,
>> so any collision is unlikely. When collision happens, we can either
>> drop the PEBS record or use the record to serve multiple events.
>> This patch chooses the later approach.
> 
> You can't.. the events might have different security context.
> 
> Remember, the overflow bit is set from the overflow until the PEBS
> event is generated, this is quite a long time. So if another PEBS event
> gets generated while the other is still pending it will have both bits
> set. Even though the second bit is for another (unrelated) counter.
> 
> The unrelated counter might not have privilege to observe the data of
> the generated event.
> 
> I think you can unwind and fully correct this trainwreck.

could you give more information how to do this.

Regards
Yan, Zheng

> But simply
> delivering an even with multiple bits set to all relevant events is
> wrong and might leak sensitive information.
> 

