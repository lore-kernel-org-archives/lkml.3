Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104Ab3C0AYB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 20:24:01 -0400
Received: from 8bytes.org ([85.214.48.195]:46760 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932Ab3C0AYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 20:24:00 -0400
Date: Wed, 27 Mar 2013 01:23:57 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Minchan Kim <minchan.kim@lge.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] staging: zsmalloc: Fix link error on ARM
Message-ID: <20130327002357.GG30540@8bytes.org>
References: <1364337232-3513-1-git-send-email-joro@8bytes.org>
 <20130327000552.GA13283@blaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130327000552.GA13283@blaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Mar 27 01:23:58 2013
X-DSPAM-Confidence: 0.9991
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 51523c1e23678558918148
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 09:05:52AM +0900, Minchan Kim wrote:
> Oops, it was my fault. When I tested [1] on CONFIG_SMP machine on ARM,
> it worked well. It means it's not always problem on every CONFIG_SMP
> on ARM machine but some SMP machine define flush_tlb_kernel_range,
> others don't.
> 
> At that time, Russell King already suggested same thing with your patch
> and I meant to clean it up because the patch was already merged but I didn't.
> Because we didn't catch up that it breaks build on some configuration
> so I thought it's just clean up patch and Greg didn't want to accept
> NOT-BUG patch of any z* family.
> 
> Now, it's BUG patch.
> 
> Remained problem is that Greg doesn't want to export core function for
> staging driver and it's reasonable for me.

Okay, I see. So that is probably also the reason for the
reimplementation of unmap_kernel_range in the zsmalloc module :)

> So my opinion is remove zsmalloc module build and could recover it with
> making unmap_kernel_range exported function after we merged it into
> mainline.

Sounds reasonable, I update the patch to only allow zsmalloc to be
built-in. The benefit is that this still allows to use
unmap_kernel_range() in the driver.

Thanks,

	Joerg


