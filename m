Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377AbaGHUyw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 16:54:52 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:63379 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912AbaGHUyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 16:54:51 -0400
Date: Wed, 9 Jul 2014 00:54:48 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [PATCH] mm: Don't forget to set softdirty on file mapped fault
Message-ID: <20140708205448.GH17860@moon.sw.swsoft.com>
References: <20140708192151.GD17860@moon.sw.swsoft.com>
 <20140708131920.2a857d573e8cc89780c9fa1c@linux-foundation.org>
 <20140708204017.GG17860@moon.sw.swsoft.com>
 <20140708134511.4a32b7400a952541a31e9078@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140708134511.4a32b7400a952541a31e9078@linux-foundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 01:45:11PM -0700, Andrew Morton wrote:
> 
> The user doesn't know or care about pte bits.
> 
> What actually *happens*?  Does criu migration hang?  Does it lose data?
> Does it take longer?

Ah, I see. Yes, the softdirty bit might be lost that usespace program
won't see that a page was modified. So data lose is possible.

> IOW, what would an end-user's bug report look like?
> 
> It's important to think this way because a year from now some person
> we've never heard of may be looking at a user's bug report and
> wondering whether backporting this patch will fix it.  Amongst other
> reasons.

Here is updated changelog, sounds better?
---

In case if page fault happend on dirty filemapping the newly created pte
may loose softdirty bit thus if a userspace program is tracking memory
changes with help of a memory tracker (CONFIG_MEM_SOFT_DIRTY) it might
miss modification of a memory page (which in worts case may lead to
data inconsistency).
