Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770AbbAVPpJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 10:45:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50745 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396AbbAVPpG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 10:45:06 -0500
Message-ID: <54C11AFF.5040505@suse.cz>
Date: Thu, 22 Jan 2015 16:45:03 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: WANG Chao <chaowang@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
CC: Davidlohr Bueso <dave@stgolabs.net>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm, vmacache: Add kconfig VMACACHE_SHIFT
References: <1421908189-18938-1-git-send-email-chaowang@redhat.com>
In-Reply-To: <1421908189-18938-1-git-send-email-chaowang@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2015 07:29 AM, WANG Chao wrote:
> Add a new kconfig option VMACACHE_SHIFT (as a power of 2) to specify the
> number of slots vma cache has for each thread. Range is chosen 0-4 (1-16
> slots) to consider both overhead and performance penalty. Default is 2

One could say that overhead and performance penalty is the same thing. 
Please elaborate?

Also, got any performance numbers to share for workloads benefiting from 
more/less than the default?

> (4 slots) as it originally is, which provides good enough balance.
>
> Signed-off-by: WANG Chao <chaowang@redhat.com>
> ---
>   include/linux/sched.h | 2 +-
>   mm/Kconfig            | 7 +++++++
>   2 files changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 8db31ef..56fd96d 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -134,7 +134,7 @@ struct perf_event_context;
>   struct blk_plug;
>   struct filename;
>
> -#define VMACACHE_BITS 2
> +#define VMACACHE_BITS CONFIG_VMACACHE_SHIFT
>   #define VMACACHE_SIZE (1U << VMACACHE_BITS)
>   #define VMACACHE_MASK (VMACACHE_SIZE - 1)
>
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 1d1ae6b..7b82a52 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -618,3 +618,10 @@ config MAX_STACK_SIZE_MB
>   	  changed to a smaller value in which case that is used.
>
>   	  A sane initial value is 80 MB.
> +
> +config VMACACHE_SHIFT
> +	int "Number of slots in per-thread VMA cache (as a power of 2)"
> +	range 0 4
> +	default 2
> +	help
> +	  This is the number of slots VMA cache has for each thread.

As a user, I wouldn't find this informative enough to make the decision.


