Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571AbaIYTgC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 15:36:02 -0400
Received: from mail-oi0-f53.google.com ([209.85.218.53]:37843 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595AbaIYTgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 15:36:00 -0400
Date: Thu, 25 Sep 2014 14:35:55 -0500
From: Chuck Ebbert <cebbert.lkml@gmail.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Mel Gorman <mgorman@suse.de>, Shaohua Li <shli@kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Ingo Molnar <mingo@kernel.org>,
        Hugh Dickens <hughd@google.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Subject: Re: page allocator bug in 3.16?
Message-ID: <20140925143555.1f276007@as>
In-Reply-To: <54246506.50401@hurleysoftware.com>
References: <54246506.50401@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Sep 2014 14:55:02 -0400
Peter Hurley <peter@hurleysoftware.com> wrote:

> After several days uptime with a 3.16 kernel (generally running
> Thunderbird, emacs, kernel builds, several Chrome tabs on multiple
> desktop workspaces) I've been seeing some really extreme slowdowns.
> 
> Mostly the slowdowns are associated with gpu-related tasks, like
> opening new emacs windows, switching workspaces, laughing at internet
> gifs, etc. Because this x86_64 desktop is nouveau-based, I didn't pursue
> it right away -- 3.15 is the first time suspend has worked reliably.
> 
> This week I started looking into what the slowdown was and discovered
> it's happening during dma allocation through swiotlb (the cpus can do
> intel iommu but I don't use it because it's not the default for most users).
> 
> I'm still working on a bisection but each step takes 8+ hours to
> validate and even then I'm no longer sure I still have the 'bad'
> commit in the bisection. [edit: yup, I started over]
> 

There are six ttm patches queued for 3.16.4:

drm-ttm-choose-a-pool-to-shrink-correctly-in-ttm_dma_pool_shrink_scan.patch
drm-ttm-fix-handling-of-ttm_pl_flag_topdown-v2.patch
drm-ttm-fix-possible-division-by-0-in-ttm_dma_pool_shrink_scan.patch
drm-ttm-fix-possible-stack-overflow-by-recursive-shrinker-calls.patch
drm-ttm-pass-gfp-flags-in-order-to-avoid-deadlock.patch
drm-ttm-use-mutex_trylock-to-avoid-deadlock-inside-shrinker-functions.patch
