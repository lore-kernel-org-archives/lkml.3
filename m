Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489AbaKDIzG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 03:55:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39891 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141AbaKDIzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 03:55:03 -0500
Message-ID: <54589465.3080708@suse.cz>
Date: Tue, 04 Nov 2014 09:55:01 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "P. Christeas" <xrg@linux.gr>, linux-mm@kvack.org
CC: Joonsoo Kim <iamjoonsoo.kim@lge.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: Early test: hangs in mm/compact.c w. Linus's 12d7aacab56e9ef185c
References: <12996532.NCRhVKzS9J@xorhgos3.pefnos>
In-Reply-To: <12996532.NCRhVKzS9J@xorhgos3.pefnos>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2014 08:26 AM, P. Christeas wrote:
> TL;DR: I'm testing Linus's 3.18-rcX in my desktop (x86_64, full load),
> experiencing mm races about every day. Current -rc starves the canary of
> stablity
>
> Will keep testing (should I try some -mm tree, please? ) , provide you
> feedback about the issue.

Hello,

Please do keep testing (and see below what we need), and don't try 
another tree - it's 3.18 we need to fix!

> Not an active kernel-developer.
>
> Long:
>
> Since 26 Oct. upgraded my everything-on-it laptop to new distro (systemd -
> based, all new glibc etc.) and switched from 3.17 to 3.18-pre . First time in
> years, kernel got unstable.
>
> This machine is occasionaly under heavy load, doing I/O and serving random
> desktop applications. (machine is Intel x86_64, dual core, mechanical SATA
> disk).
> Now, I have a race about once a day, have narrowed them down (guess) to:
>
>          [<ffffffff813b1025>] preempt_schedule_irq+0x3c/0x59
>          [<ffffffff813b4810>] retint_kernel+0x20/0x30
>          [<ffffffff810d7481>] ? __zone_watermark_ok+0x77/0x85
>          [<ffffffff810d8256>] zone_watermark_ok+0x1a/0x1c
>          [<ffffffff810eee56>] compact_zone+0x215/0x4b2
>          [<ffffffff810ef13f>] compact_zone_order+0x4c/0x5f
>          [<ffffffff810ef2fe>] try_to_compact_pages+0xc4/0x1e8
>          [<ffffffff813ad7f8>] __alloc_pages_direct_compact+0x61/0x1bf
>          [<ffffffff810da299>] __alloc_pages_nodemask+0x409/0x799
>          [<ffffffff8110d3fd>] new_slab+0x5f/0x21c
>         ...

I'm not sure what you mean by "race" here and your snippet is 
unfortunately just a small portion of the output which could be a BUG, 
OOPS, lockdep, soft-lockup, hardlock and possibly many other things. But 
the backtrace itself is not enough, please send the whole error output 
(it should stard and end with something like:
-----[ cut here ]------
Thanks in advance.

> Sometimes is a less critical process, that I can safely kill, otherwise I have
> to drop everything and reboot.

OK so the process is not dead due to the problem? That probably rules 
out some kinds of errors but we still need the full output. Thanks in 
advance.

> Unless you are already aware of this case, please accept this feedback.
> I'm pulling from Linus, should I also try some of your trees for an early
> solution?

I'm not aware of this, CCing lkml for wider coverage.

