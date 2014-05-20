Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568AbaETPF7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 11:05:59 -0400
Received: from mail-qg0-f44.google.com ([209.85.192.44]:37522 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045AbaETPF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 11:05:58 -0400
Date: Tue, 20 May 2014 11:05:54 -0400
From: Tejun Heo <tj@kernel.org>
To: Eli Billauer <eli.billauer@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] dma-mapping: Add devm_ interface for dma_map_single()
Message-ID: <20140520150554.GF2804@htj.dyndns.org>
References: <1400228799-8832-1-git-send-email-eli.billauer@gmail.com>
 <1400228799-8832-3-git-send-email-eli.billauer@gmail.com>
 <20140516210805.GO5379@htj.dyndns.org>
 <537753C9.3060101@gmail.com>
 <20140519201712.GD27506@mtj.dyndns.org>
 <537AEE01.20602@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <537AEE01.20602@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, May 20, 2014 at 08:54:09AM +0300, Eli Billauer wrote:
> That seems OK to me, but the problem I'm concerned with is this: In
> devm_get_free_pages() it says
> 
>     devres = devres_alloc(devm_pages_release,
>                   sizeof(struct pages_devres), GFP_KERNEL);
>     if (unlikely(!devres)) {
>         free_pages(addr, order);
>         return 0;
>     }
> 
> What should I put instead of this "return 0" to conform with the current
> API?

Ah, okay.  No idea.

> And to make things even worse, on some architectures, dma_mapping_error()
> always returns success, regardless of dma_handle. So if we stick to the
> current API, the caller of devm_get_free_pages() will never know it failed
> on these architectures.
> 
> So my conclusion was that the caller must be aware that if
> devm_get_free_pages() returns zero it's an error, regardless of
> dma_mapping_error(). That breaks the API. Once it's broken, why not return
> zero on all possible errors?

What if 0 is a valid return for the architecture?  Isn't that the
whole point of dma_mapping_error() interface?  Maybe the right thing
to do is using a separate out argument for dma_handle?

	int dmam_map_single(blah blah, dma_addr_t *out_addr);

So that it can return -errno like other non-crazy functions?  We'll
probably ask somebody who knows this code better.

Thanks.

-- 
tejun
