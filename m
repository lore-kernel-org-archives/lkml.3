Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709Ab3JGTHJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 15:07:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13176 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387Ab3JGTHE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 15:07:04 -0400
Message-ID: <5253064B.3010405@redhat.com>
Date: Mon, 07 Oct 2013 15:06:51 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 38/63] sched: Introduce migrate_swap()
References: <1381141781-10992-1-git-send-email-mgorman@suse.de> <1381141781-10992-39-git-send-email-mgorman@suse.de>
In-Reply-To: <1381141781-10992-39-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2013 06:29 AM, Mel Gorman wrote:
> From: Peter Zijlstra <peterz@infradead.org>
> 
> Use the new stop_two_cpus() to implement migrate_swap(), a function that
> flips two tasks between their respective cpus.
> 
> I'm fairly sure there's a less crude way than employing the stop_two_cpus()
> method, but everything I tried either got horribly fragile and/or complex. So
> keep it simple for now.
> 
> The notable detail is how we 'migrate' tasks that aren't runnable
> anymore. We'll make it appear like we migrated them before they went to
> sleep. The sole difference is the previous cpu in the wakeup path, so we
> override this.
> 
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
