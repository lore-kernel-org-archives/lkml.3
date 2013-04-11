Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935737Ab3DKOAR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 10:00:17 -0400
Received: from one.firstfloor.org ([193.170.194.197]:44240 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935410Ab3DKOAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 10:00:14 -0400
Date: Thu, 11 Apr 2013 16:00:12 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Mitsuhiro Tanino <mitsuhiro.tanino.gm@hitachi.com>,
        Andi Kleen <andi@firstfloor.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Subject: Re: [RFC Patch 2/2] mm: Add parameters to limit a rate of
 outputting memory error messages
Message-ID: <20130411140012.GI16732@two.firstfloor.org>
References: <1365665524-nj0fhwkj-mutt-n-horiguchi@ah.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365665524-nj0fhwkj-mutt-n-horiguchi@ah.jp.nec.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I don't think it's enough to do ratelimit only for me_pagecache_dirty().
> When tons of memory errors flood, all of printk()s in memory error handler
> can print out tons of messages.

Note that when you really have a flood of uncorrected errors you'll
likely die soon anyways as something unrecoverable is very likely to
happen. Error memory recovery cannot fix large scale memory corruptions,
just the rare events that slip through all the other memory error correction
schemes.

So I wouldn't worry too much about that.

The flooding problem is typically more with corrected error reporting.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
