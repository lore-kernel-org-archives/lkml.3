Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936233Ab3DKOrP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 10:47:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20514 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934526Ab3DKOrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 10:47:14 -0400
Date: Thu, 11 Apr 2013 10:47:06 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Mitsuhiro Tanino <mitsuhiro.tanino.gm@hitachi.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Message-ID: <1365691626-w2h428s2-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <20130411140012.GI16732@two.firstfloor.org>
References: <1365665524-nj0fhwkj-mutt-n-horiguchi@ah.jp.nec.com>
 <20130411140012.GI16732@two.firstfloor.org>
Subject: Re: [RFC Patch 2/2] mm: Add parameters to limit a rate of outputting
 memory error messages
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-References: <20130411140012.GI16732@two.firstfloor.org>
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 04:00:12PM +0200, Andi Kleen wrote:
> > I don't think it's enough to do ratelimit only for me_pagecache_dirty().
> > When tons of memory errors flood, all of printk()s in memory error handler
> > can print out tons of messages.
> 
> Note that when you really have a flood of uncorrected errors you'll
> likely die soon anyways as something unrecoverable is very likely to
> happen. Error memory recovery cannot fix large scale memory corruptions,
> just the rare events that slip through all the other memory error correction
> schemes.
> 
> So I wouldn't worry too much about that.

I agree.
My previous comment is valid only when we assume the flooding can happen
(and I personally don't believe that can happen except for in testing.)

And for paranoid users, we can suggest that they set up mcelog script
triggering to turn off vm.memory_failure_recovery when memory errors flood.
Such users don't expect that memory error handling works fine in flooding,
so just suppressing kernel messages is pointless.

Thanks,
Naoya
