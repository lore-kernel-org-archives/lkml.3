Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710Ab3JaEe0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 00:34:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51619 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743Ab3JaEeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 00:34:25 -0400
Date: Wed, 30 Oct 2013 21:35:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kosaki.motohiro@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH] mm: __rmqueue_fallback() should respect pageblock type
Message-Id: <20131030213537.f346d751.akpm@linux-foundation.org>
In-Reply-To: <1383193489-27331-1-git-send-email-kosaki.motohiro@gmail.com>
References: <1383193489-27331-1-git-send-email-kosaki.motohiro@gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Oct 2013 00:24:49 -0400 kosaki.motohiro@gmail.com wrote:

> When __rmqueue_fallback() don't find out a free block with the same size
> of required, it splits a larger page and puts back rest peiece of the page
> to free list.
> 
> But it has one serious mistake. When putting back, __rmqueue_fallback()
> always use start_migratetype if type is not CMA. However, __rmqueue_fallback()
> is only called when all of start_migratetype queue are empty. That said,
> __rmqueue_fallback always put back memory to wrong queue except
> try_to_steal_freepages() changed pageblock type (i.e. requested size is
> smaller than half of page block). Finally, antifragmentation framework
> increase fragmenation instead of decrease.
> 
> Mel's original anti fragmentation do the right thing. But commit 47118af076
> (mm: mmzone: MIGRATE_CMA migration type added) broke it.
> 
> This patch restores sane and old behavior.

What are the user-visible runtime effects of this change?
