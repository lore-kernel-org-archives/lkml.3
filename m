Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788AbaDYIVM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 04:21:12 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:59462 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421AbaDYIUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 04:20:45 -0400
Message-Id: <20140425081030.185969086@openvz.org>
User-Agent: quilt/0.60-1
Date: Fri, 25 Apr 2014 12:10:30 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, torvalds@linux-foundation.org, mgorman@suse.de,
        hpa@zytor.com, mingo@kernel.org, steven@uplinklabs.net,
        riel@redhat.com, david.vrabel@citrix.com, akpm@linux-foundation.org,
        peterz@infradead.org, xemul@parallels.com, gorcunov@openvz.org
Subject: [patch 0/2] A few simplifications for softdirty memory tracker code
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, here are a few simplifications for softdirty memory tracker code, in
particular we dropped off x86-32 support since it seems noone needed it
here on x86 platform.

As Andrew requested I've rebased patches on top of current linux-next repo.

Also at first I wanted to rip off _PAGE_PSE bit which we use in swap ptes
to track dirty status of swapped pages and reuse _PAGE_BIT_SOFT_DIRTY
instead. It's still possible but requires additional shrinking of
maximal swap size and I don't know if it's acceptible or not. Currently
we have

#ifdef CONFIG_NUMA_BALANCING
/* Automatic NUMA balancing needs to be distinguishable from swap entries */
#define SWP_OFFSET_SHIFT (_PAGE_BIT_PROTNONE + 2)
#else
#define SWP_OFFSET_SHIFT (_PAGE_BIT_PROTNONE + 1)
#endif

If I reuse _PAGE_BIT_SOFT_DIRTY I'll have to increase this shift up
to bit 11, which, again, I think is too much, right?

Comments are highly appreciated!

	Cyrill
