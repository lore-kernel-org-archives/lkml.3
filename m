Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287AbaLIIvO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 03:51:14 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:46931 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752844AbaLIIu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 03:50:56 -0500
Date: Tue, 9 Dec 2014 08:50:32 +0000
From: Russell King <rmk@arm.linux.org.uk>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Drake <drake@endlessm.com>, Minchan Kim <minchan@kernel.org>
Subject: Re: [regression] Boot crash with: f7426b983a6a ("mm: cma: adjust
 address limit to avoid hitting low/high memory boundary")
Message-ID: <20141209085032.GA18348@flint.arm.linux.org.uk>
References: <20141117163903.GA17801@gmail.com>
 <20141127130556.GA4074@gmail.com>
 <20141128070220.GA11802@js1304-P5Q-DELUXE>
 <20141208105640.GA29431@gmail.com>
 <20141209075541.GA7714@js1304-P5Q-DELUXE>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141209075541.GA7714@js1304-P5Q-DELUXE>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 09, 2014 at 04:55:42PM +0900, Joonsoo Kim wrote:
> Could you manage this fix for above boot regression in x86?
> Patch itself is so dirty, because __pa_nodebug() is implemented only
> in x86. If someone knows better idea, please let me know.

> +#ifdef CONFIG_X86
> +	/*
> +	 * high_memory isn't direct mapped memory so retrieving it's
> +	 * physical address isn't appropriate. But, it would be useful
> +	 * to check physical address of highmem boundary so it's
> +	 * justfiable to get physical address from it. In x86, there is
> +	 * a validation check for this case, so following workaround is
> +	 * needed to avoid it.
> +	 */
> +	highmem_start = __pa_nodebug(high_memory);
> +#else
> +	highmem_start = __pa(high_memory);
> +#endif

What about:

	highmem_start = __pa(high_memory - 1) + 1;

As "high_memory - 1" should be a valid lowmem address.

-- 
Russell King
ARM architecture Linux Kernel maintainer
