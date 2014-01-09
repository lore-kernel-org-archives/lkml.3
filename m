Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295AbaAIUC2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 15:02:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55369 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756062AbaAIUCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 15:02:25 -0500
Message-ID: <52CEFFF3.9010709@redhat.com>
Date: Thu, 09 Jan 2014 15:00:51 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>, Alex Shi <alex.shi@linaro.org>,
        Ingo Molnar <mingo@kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>, H Peter Anvin <hpa@zytor.com>,
        Linux-X86 <x86@kernel.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] mm: x86: Revisit tlb_flushall_shift tuning for page
 flushes except on IvyBridge
References: <1389278098-27154-1-git-send-email-mgorman@suse.de> <1389278098-27154-6-git-send-email-mgorman@suse.de>
In-Reply-To: <1389278098-27154-6-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2014 09:34 AM, Mel Gorman wrote:
> There was a large ebizzy performance regression that was bisected to commit
> 611ae8e3 (x86/tlb: enable tlb flush range support for x86). The problem
> was related to the tlb_flushall_shift tuning for IvyBridge which was
> altered. The problem is that it is not clear if the tuning values for each
> CPU family is correct as the methodology used to tune the values is unclear.
>
> This patch uses a conservative tlb_flushall_shift value for all CPU families
> except IvyBridge so the decision can be revisited if any regression is found
> as a result of this change. IvyBridge is an exception as testing with one
> methodology determined that the value of 2 is acceptable. Details are in the
> changelog for the patch "x86: mm: Change tlb_flushall_shift for IvyBridge".
>
> One important aspect of this to watch out for is Xen. The original commit
> log mentioned large performance gains on Xen. It's possible Xen is more
> sensitive to this value if it flushes small ranges of pages more frequently
> than workloads on bare metal typically do.
>
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Reviewed-by: Rik van Riel <riel@redhat.com>

