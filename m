Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937Ab3JJC0m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 22:26:42 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:38371 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455Ab3JJC0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 22:26:40 -0400
Date: Wed, 9 Oct 2013 21:26:27 -0500
From: Seth Jennings <sjennings@variantweb.net>
To: Bob Liu <bob.liu@oracle.com>
Cc: Seth Jennings <spartacus06@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>, linux-mm@kvack.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, Shaohua Li <shli@fusionio.com>,
        Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH] frontswap: enable call to invalidate area on swapoff
Message-ID: <20131010022627.GA8535@variantweb.net>
References: <1381159541-13981-1-git-send-email-k.kozlowski@samsung.com>
 <20131007150338.1fdee18b536bb1d9fe41a07b@linux-foundation.org>
 <1381220000.16135.10.camel@AMDC1943>
 <20131008130853.96139b79a0a4d3aaacc79ed2@linux-foundation.org>
 <20131009144045.GA5406@variantweb.net>
 <525602E3.3080501@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <525602E3.3080501@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 09:29:07AM +0800, Bob Liu wrote:
> On 10/09/2013 10:40 PM, Seth Jennings wrote:
> > 
> > The reason we never noticed this for zswap is that zswap has no
> > dynamically allocated per-type resources.  In the expected case,
> > where all of the pages have been drained from zswap,
> > zswap_frontswap_invalidate_area() is a no-op.
> > 
> 
> Not exactly, see the bug fix "mm/zswap: bugfix: memory leak when
> re-swapon" from Weijie.
> Zswap needs invalidate_area() also.

I remembered this patch as soon as I sent out this note.  What I said
about zswap_frontswap_invalidate_area() being a no-op in the expected
case is true as of v3.12-rc4, but it shouldn't be :)

I sent a note to Andrew reminding him to pull in that patch.

Thanks,
Seth
