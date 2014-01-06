Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbaAFOBW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 09:01:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3315 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751099AbaAFOBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 09:01:03 -0500
Message-ID: <52CAB701.2020505@redhat.com>
Date: Mon, 06 Jan 2014 09:00:33 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>
CC: Thomas Hellstrom <thellstrom@vmware.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: Calculate effective load even if local weight
 is 0
References: <20140106113912.GC6178@suse.de> <20140106123519.GK31570@twins.programming.kicks-ass.net>
In-Reply-To: <20140106123519.GK31570@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2014 07:35 AM, Peter Zijlstra wrote:
> On Mon, Jan 06, 2014 at 11:39:12AM +0000, Mel Gorman wrote:
>> wake_affine uses a weight of 0 for sync wakeups on the grounds that it
>> is assuming the waking task will sleep and not contribute to load in the
>> near future. In this case, we still want to calculate the effective load
>> of the sched entity hierarchy. As effective_load is no longer used by
>> task_numa_compare since commit fb13c7ee (sched/numa: Use a system-wide
>> search to find swap/migration candidates), this patch simply restores the
>> historical behaviour.
> 
> Urgh.. yeah. We should merge this. Rik you ok with me adding a from and
> sob from you?

Yes, please do :)

Signed-off-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
