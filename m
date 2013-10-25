Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086Ab3JYKUm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 06:20:42 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:33349 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511Ab3JYKUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 06:20:40 -0400
Date: Fri, 25 Oct 2013 19:20:32 +0900
From: Minchan Kim <minchan@kernel.org>
To: Weijie Yang <weijie.yang@samsung.com>
Cc: akpm@linux-foundation.org, sjennings@variantweb.net, bob.liu@oracle.com,
        weijie.yang.kh@gmail.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH RESEND 2/2] mm/zswap: refoctor the get/put routines
Message-ID: <20131025102032.GE6612@gmail.com>
References: <000101ced09e$fed90a10$fc8b1e30$%yang@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000101ced09e$fed90a10$fc8b1e30$%yang@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 24, 2013 at 05:53:32PM +0800, Weijie Yang wrote:
> The refcount routine was not fit the kernel get/put semantic exactly,
> There were too many judgement statements on refcount and it could be minus.
> 
> This patch does the following:
> 
> - move refcount judgement to zswap_entry_put() to hide resource free function.
> 
> - add a new function zswap_entry_find_get(), so that callers can use easily
> in the following pattern:
> 
>    zswap_entry_find_get
>    .../* do something */
>    zswap_entry_put
> 
> - to eliminate compile error, move some functions declaration
> 
> This patch is based on Minchan Kim <minchan@kernel.org> 's idea and suggestion.
> 
> Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
> Cc: Seth Jennings <sjennings@variantweb.net>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Bob Liu <bob.liu@oracle.com>


I remember Bob had a idea to remove a look up and I think it's doable.
Anyway, I don't mind you send it with fix or not.

Thanks for handling this, Weijie!

Acked-by: Minchan Kim <minchan@kernel.org>

-- 
Kind regards,
Minchan Kim
