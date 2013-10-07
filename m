Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499Ab3JGWDl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 18:03:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34216 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab3JGWDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 18:03:40 -0400
Date: Mon, 7 Oct 2013 15:03:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: linux-mm@kvack.org, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, Shaohua Li <shli@fusionio.com>,
        Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH] frontswap: enable call to invalidate area on swapoff
Message-Id: <20131007150338.1fdee18b536bb1d9fe41a07b@linux-foundation.org>
In-Reply-To: <1381159541-13981-1-git-send-email-k.kozlowski@samsung.com>
References: <1381159541-13981-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 07 Oct 2013 17:25:41 +0200 Krzysztof Kozlowski <k.kozlowski@samsung.com> wrote:

> During swapoff the frontswap_map was NULL-ified before calling
> frontswap_invalidate_area(). However the frontswap_invalidate_area()
> exits early if frontswap_map is NULL. Invalidate was never called during
> swapoff.
> 
> This patch moves frontswap_map_set() in swapoff just after calling
> frontswap_invalidate_area() so outside of locks
> (swap_lock and swap_info_struct->lock). This shouldn't be a problem as
> during swapon the frontswap_map_set() is called also outside of any
> locks.
> 

Ahem.  So there's a bunch of code in __frontswap_invalidate_area()
which hasn't ever been executed and nobody noticed it.  So perhaps that
code isn't actually needed?

More seriously, this patch looks like it enables code which hasn't been
used or tested before.  How well tested was this?

Are there any runtime-visible effects from this change?
