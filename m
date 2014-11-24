Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751174AbaKXWzW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 17:55:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56591 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbaKXWzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 17:55:21 -0500
Date: Mon, 24 Nov 2014 14:55:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan@kernel.org>, Dave Hansen <dave@sr71.net>,
        Michal Nazarewicz <mina86@mina86.com>,
        Jungsoo Son <jungsoo.son@lge.com>, Ingo Molnar <mingo@redhat.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/8] mm/debug-pagealloc: make debug-pagealloc
 boottime configurable
Message-Id: <20141124145542.08b97076.akpm@linux-foundation.org>
In-Reply-To: <1416816926-7756-4-git-send-email-iamjoonsoo.kim@lge.com>
References: <1416816926-7756-1-git-send-email-iamjoonsoo.kim@lge.com>
	<1416816926-7756-4-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Nov 2014 17:15:21 +0900 Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:

> Now, we have prepared to avoid using debug-pagealloc in boottime. So
> introduce new kernel-parameter to disable debug-pagealloc in boottime,
> and makes related functions to be disabled in this case.
> 
> Only non-intuitive part is change of guard page functions. Because
> guard page is effective only if debug-pagealloc is enabled, turning off
> according to debug-pagealloc is reasonable thing to do.
> 
> ...
>
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -858,6 +858,14 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  			causing system reset or hang due to sending
>  			INIT from AP to BSP.
>  
> +	disable_debug_pagealloc
> +			[KNL] When CONFIG_DEBUG_PAGEALLOC is set, this
> +			parameter allows user to disable it at boot time.
> +			With this parameter, we can avoid allocating huge
> +			chunk of memory for debug pagealloc and then
> +			the system will work mostly same with the kernel
> +			built without CONFIG_DEBUG_PAGEALLOC.
> +

Weren't we going to make this default to "off", require a boot option
to turn debug_pagealloc on?

