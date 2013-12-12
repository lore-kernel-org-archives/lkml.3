Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076Ab3LLSqI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 13:46:08 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:51467 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab3LLSqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 13:46:03 -0500
Date: Thu, 12 Dec 2013 10:46:02 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Will Deacon <will.deacon@arm.com>
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org
Subject: Re: [PATCH 1/2] dcache: allow word-at-a-time name hashing with
 big-endian CPUs
Message-ID: <20131212184602.GA32476@infradead.org>
References: <1386702658-21430-1-git-send-email-will.deacon@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386702658-21430-1-git-send-email-will.deacon@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +#ifdef __BIG_ENDIAN
> +	mask = ~(~0ul >> tcount*8);
> +#else
>  	mask = ~(~0ul << tcount*8);
> +#endif
>  	return unlikely(!!((a ^ b) & mask));

> +#ifdef __BIG_ENDIAN
> +	mask = ~(~0ul >> len*8);
> +#else
>  	mask = ~(~0ul << len*8);
> +#endif

This should really be a common helper.
