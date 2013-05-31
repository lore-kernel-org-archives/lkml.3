Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756945Ab3EaTFv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 15:05:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39803 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725Ab3EaTFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 15:05:43 -0400
Date: Fri, 31 May 2013 12:05:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, chanho.min@lge.com,
        Kamil Debski <k.debski@samsung.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Arun Kumar K <arun.kk@samsung.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: Regression introduced by commit
 "lib/bitmap.c: speed up bitmap_find_free_region"
Message-Id: <20130531120542.87e2056dc7c129e72b83f2af@linux-foundation.org>
In-Reply-To: <CAK9yfHyZH3DSg2ZLbPN2bjQppWZSMR+2hQE+OU76eqSJoWAWGA@mail.gmail.com>
References: <CAK9yfHyZH3DSg2ZLbPN2bjQppWZSMR+2hQE+OU76eqSJoWAWGA@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 May 2013 12:15:10 +0530 Sachin Kamat <sachin.kamat@linaro.org> wrote:

> Hi,
> 
> While testing MFC decoder on Exynos machines, I encountered some
> memory allocation errors due to failure of dma_alloc_coherent().
> File: drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c Line: 38.
> 
> Git bisect pointed me to the following commit as the first bad commit
> (linux-next tree of 20130531):
> 
> commit 3d5272d9b289cd0930b2ea9984406d757a72f4dd
> Author: Chanho Min <chanho.min@lge.com>
> Date:   Thu May 23 10:37:28 2013 +1000
>     lib/bitmap.c: speed up bitmap_find_free_region
> 
> Reverting this (and the commit 197e1cf7
> ("ib-bitmapc-speed-up-bitmap_find_free_region-fix") ) fixes this
> issue.
> 
> Looks like some regression has been introduced by the above patch?

Thanks.  I dropped the patches for now, to minimise linux-next
breakage.  Hopefully we'll be able to identify and fix this at a later
time.

