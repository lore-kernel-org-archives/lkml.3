Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756388AbaDQAmx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 20:42:53 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46218 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755083AbaDQAmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 20:42:50 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <534F2374.8090304@jp.fujitsu.com>
Date: Thu, 17 Apr 2014 09:42:28 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Denys Vlasenko <vda.linux@googlemail.com>, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] nohz: use delayed iowait accounting to avoid race
 on idle time stats
References: <53465F54.708@jp.fujitsu.com> <534660D2.1080505@jp.fujitsu.com> <20140415101910.GN11096@twins.programming.kicks-ass.net> <534E2422.1040706@jp.fujitsu.com> <20140416093637.GR11182@twins.programming.kicks-ass.net>
In-Reply-To: <20140416093637.GR11182@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/04/16 18:36), Peter Zijlstra wrote:
> On Wed, Apr 16, 2014 at 03:33:06PM +0900, Hidetoshi Seto wrote:
>> So we need 2 operations:
>>   a) remove regression
> 
> What regression; there's never been talk about a regression, just a bug
> found. AFAICT this 'regression' is ever since we introduced NOHZ or
> somesuch, which is very long ago indeed.
> 
> And since its basically been broken forever, there's no rush what so
> ever.

Well, from a customer's view, when he upgrade his foobar enterprise
linux from version 5 to 6 (for example), he will say "it's a regression"
if something worked well in previous version have broken in new version
without any documents and/or technical notes etc.

That's why I used the word "regression" for this bug.

>>   b) implement new iowait accounting mechanism
>>
>> What Frederic mentioned is that we don't need a) once if we invent
>> the solution for b). But I doubt it because a) is still required
>> for stable environment including some distributor's kernel.
>> It is clear that patches for b) will not be backportable.
>>
>> Still the b) is disease that has no known cure. There is no reason
>> to wait works on b) before starting works for a).
> 
> As stated, there is no a). Its been forever broken. There is no urgency.

I just wrote my patches for my customer like above and for my salary ;-)

Thank you for your comments!
I'll post my v4 patch set soon.


Thanks,
H.Seto



