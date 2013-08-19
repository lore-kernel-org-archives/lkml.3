Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751146Ab3HSRAJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 13:00:09 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:54899 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122Ab3HSRAC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 13:00:02 -0400
Date: Mon, 19 Aug 2013 11:59:48 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Bob Liu <lliubbo@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, eternaleye@gmail.com,
        minchan@kernel.org, mgorman@suse.de, gregkh@linuxfoundation.org,
        akpm@linux-foundation.org, axboe@kernel.dk, ngupta@vflare.org,
        semenzato@google.com, penberg@iki.fi, sonnyrao@google.com,
        smbarber@google.com, konrad.wilk@oracle.com, riel@redhat.com,
        kmpark@infradead.org, Bob Liu <bob.liu@oracle.com>
Subject: Re: [PATCH 3/4] mm: zswap: add supporting for zsmalloc
Message-ID: <20130819165948.GA5703@variantweb.net>
References: <1376815249-6611-1-git-send-email-bob.liu@oracle.com>
 <1376815249-6611-4-git-send-email-bob.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376815249-6611-4-git-send-email-bob.liu@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081916-5806-0000-0000-000022794B05
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 18, 2013 at 04:40:48PM +0800, Bob Liu wrote:
> Make zswap can use zsmalloc as its allocater.
> But note that zsmalloc don't reclaim any zswap pool pages mandatory, if zswap
> pool gets full, frontswap_store will be refused unless frontswap_get happened
> and freed some space.
> 
> The reason of don't implement reclaiming zsmalloc pages from zswap pool is there
> is no requiremnet currently.
> If we want to do mandatory reclaim, we have to write those pages to real backend
> swap devices. But most of current users of zsmalloc are from embeded world,
> there is even no real backend swap device.
> This action is also the same as privous zram!
> 
> For several area, zsmalloc has unpredictable performance characteristics when
> reclaiming a single page, then CONFIG_ZBUD are suggested.

Looking at this patch on its own, it does show how simple it could be
for zswap to support zsmalloc.  So thanks!

However, I don't like all the ifdefs scattered everywhere.  I'd like to
have a ops structure (e.g. struct zswap_alloc_ops) instead and just
switch ops based on the CONFIG flag.  Or better yet, have it boot-time
selectable instead of build-time.

Seth

