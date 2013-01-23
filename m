Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540Ab3AWAFI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 19:05:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47219 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756432Ab3AWAEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 19:04:37 -0500
Date: Tue, 22 Jan 2013 16:04:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: paul.szabo@sydney.edu.au
Cc: linux-mm@kvack.org, 695182@bugs.debian.org, linux-kernel@vger.kernel.org,
        Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH] MAX_PAUSE to be at least 4
Message-Id: <20130122160436.f0fa8352.akpm@linux-foundation.org>
In-Reply-To: <201301210307.r0L37YuG018834@como.maths.usyd.edu.au>
References: <201301210307.r0L37YuG018834@como.maths.usyd.edu.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jan 2013 14:07:34 +1100
paul.szabo@sydney.edu.au wrote:

> Ensure MAX_PAUSE is 4 or larger, so limits in
> 	return clamp_val(t, 4, MAX_PAUSE);
> (the only use of it) are not back-to-front.

MAX_PAUSE is not used in this fashion in current kernels.

> (This patch does not solve the PAE OOM issue.)
> 
> Paul Szabo   psz@maths.usyd.edu.au   http://www.maths.usyd.edu.au/u/psz/
> School of Mathematics and Statistics   University of Sydney    Australia
> 
> Reported-by: Paul Szabo <psz@maths.usyd.edu.au>
> Reference: http://bugs.debian.org/695182
> Signed-off-by: Paul Szabo <psz@maths.usyd.edu.au>
> 
> --- mm/page-writeback.c.old	2012-12-06 22:20:40.000000000 +1100
> +++ mm/page-writeback.c	2013-01-21 13:57:05.000000000 +1100
> @@ -39,7 +39,7 @@
>  /*
>   * Sleep at most 200ms at a time in balance_dirty_pages().
>   */
> -#define MAX_PAUSE		max(HZ/5, 1)
> +#define MAX_PAUSE		max(HZ/5, 4)
>  
>  /*
>   * Estimate write bandwidth at 200ms intervals.

