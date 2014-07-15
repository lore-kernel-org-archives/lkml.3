Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933306AbaGOTUE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 15:20:04 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:42966 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932760AbaGOTUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 15:20:03 -0400
Message-ID: <53C57EDF.2090107@hp.com>
Date: Tue, 15 Jul 2014 15:19:59 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        Scott J Norton <scott.norton@hp.com>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH v5 0/2] lockdep: add support for queued rwlock
References: <1403804351-405-1-git-send-email-Waiman.Long@hp.com> <20140707125012.GP6758@twins.programming.kicks-ass.net>
In-Reply-To: <20140707125012.GP6758@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/2014 08:50 AM, Peter Zijlstra wrote:
> On Thu, Jun 26, 2014 at 01:39:09PM -0400, Waiman Long wrote:
>> v4->v5:
>>   - Add patch 2 to update the locking selftest code to handle recursive
>>     read_lock correctly. Patch 1 has no change.
> I removed all CONFIG_QUEUE_RWLOCK dependencies and made lockdep
> unconditionally assume the stronger constraints.
>
> Since we want all code 'clean' for the strongest possible
> implementation, everybody should run with those semantics, it doesn't
> make sense to have that configurable.
>
> Eg. someone on (say ARM, which doesn't -- yet -- have QUEUE_RWLOCK)
> could unwittingly introduce faulty code.

I think this is a better way to go. I didn't take this way in my patch 
for fear that I may be pushing too much.

-Longman
