Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab3C0BJx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 21:09:53 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:63794 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281Ab3C0BJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 21:09:53 -0400
X-AuditID: 9c930197-b7c9dae000006959-36-515246db334e
Date: Wed, 27 Mar 2013 10:09:47 +0900
From: Minchan Kim <minchan.kim@lge.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] staging: zsmalloc: Fix link error on ARM
Message-ID: <20130327010947.GA2710@blaptop>
References: <1364337232-3513-1-git-send-email-joro@8bytes.org>
 <20130327000552.GA13283@blaptop>
 <20130327004314.GH30540@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130327004314.GH30540@8bytes.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 01:43:14AM +0100, Joerg Roedel wrote:
> On Wed, Mar 27, 2013 at 09:05:52AM +0900, Minchan Kim wrote:
> > And please Cc stable.
> 
> Okay, here it is. The result is compile-tested.
> 
> Changes since v1:
> 
> * Remove the module-export for unmap_kernel_range and make zsmalloc
>   built-in instead
> 
> Here is the patch:
> 
> >From 2b70502720b36909f9f39bdf27be21321a219c31 Mon Sep 17 00:00:00 2001
> From: Joerg Roedel <joro@8bytes.org>
> Date: Tue, 26 Mar 2013 23:24:22 +0100
> Subject: [PATCH v2] staging: zsmalloc: Fix link error on ARM
> 
> Testing the arm chromebook config against the upstream
> kernel produces a linker error for the zsmalloc module from
> staging. The symbol flush_tlb_kernel_range is not available
> there. Fix this by removing the reimplementation of
> unmap_kernel_range in the zsmalloc module and using the
> function directly. The unmap_kernel_range function is not
> usable by modules, so also disallow building the driver as a
> module for now.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Joerg Roedel <joro@8bytes.org>
Acked-by: Minchan Kim <minchan@kernel.org>

-- 
Kind regards,
Minchan Kim
