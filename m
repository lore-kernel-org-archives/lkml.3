Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683AbaJNVqj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 17:46:39 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:40396 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754562AbaJNVqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 17:46:37 -0400
Date: Tue, 14 Oct 2014 22:46:33 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Fleming <matt.fleming@intel.com>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
Subject: Re: [PATCH 2/2] efi: Capsule update support
Message-ID: <20141014214633.GD14343@console-pimps.org>
References: <1412692951-25478-1-git-send-email-matt@console-pimps.org>
 <1412692951-25478-2-git-send-email-matt@console-pimps.org>
 <20141010182846.GA10588@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141010182846.GA10588@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Oct, at 08:28:47PM, Borislav Petkov wrote:
> 
> You have efi_capsule_update() vs efi_update_capsule(). Maybe change the
> names a bit more for differentiation. Or prepend the workhorse doing all
> the work with "__" or so...
 
Yeah, I really didn't come up with a great naming scheme here. I'll fix
that.

> > +
> > +	for (i = 0; i < nr_block_pgs; i++) {
> > +		block_pgs[i] = alloc_page(GFP_KERNEL);
> 
> Maybe alloc_pages() once we verify that it actually gives phys. contig.
> memory and maybe also try to do it outside of the locked region. I don't
> know if it would matter to drop the locks though as capsule updating is
> not something you do pretty often. I'd hope!

Actually, I'm not bothered about getting physically contiguous memory
because we pass a scatter gather list to the firmware anyway. What I was
looking for was to avoid doing high order allocations when we don't
really need them (lots of low order allocs are fine).

Right, allocating under the lock isn't a great idea. I'll take a look at
reworking this to do the allocation up front.

-- 
Matt Fleming, Intel Open Source Technology Center
