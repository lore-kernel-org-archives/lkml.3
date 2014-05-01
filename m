Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006AbaEAM6W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 08:58:22 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:60059 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250AbaEAM6V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 08:58:21 -0400
Date: Thu, 1 May 2014 08:58:19 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] mm/memcontrol.c: remove NULL assignment on static
Message-ID: <20140501125819.GB23420@cmpxchg.org>
References: <20140426105031.84856dc6360dc23bc8039d0f@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140426105031.84856dc6360dc23bc8039d0f@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2014 at 10:50:31AM +0200, Fabian Frederick wrote:
> static values are automatically initialized to NULL
> 
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  mm/memcontrol.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 29501f0..6e38542 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -80,7 +80,7 @@ int do_swap_account __read_mostly;
>  #ifdef CONFIG_MEMCG_SWAP_ENABLED
>  static int really_do_swap_account __initdata = 1;
>  #else
> -static int really_do_swap_account __initdata = 0;
> +static int really_do_swap_account __initdata;
>  #endif
>  
>  #else

I actually like how this makes the 1 vs. 0 more obvious in this case,
even though it's not technically necessary.
