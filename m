Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727Ab3JJIpl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 04:45:41 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:61857 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755340Ab3JJIpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 04:45:38 -0400
Date: Thu, 10 Oct 2013 10:45:35 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jakub Jelinek <jakub@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Richard Henderson <rth@twiddle.net>
Subject: Re: [PATCH] gcc4: Add 'asm goto' miscompilation quirk
Message-ID: <20131010084535.GA10620@gmail.com>
References: <20131009143359.GU26785@twins.programming.kicks-ass.net>
 <20131009144656.GV26785@twins.programming.kicks-ass.net>
 <20131009181613.GW30970@tucnak.zalov.cz>
 <20131009190231.GI13848@laptop.programming.kicks-ass.net>
 <20131009190851.GX30970@tucnak.zalov.cz>
 <20131010062238.GB9853@gmail.com>
 <20131010065104.GY30970@tucnak.zalov.cz>
 <20131010080457.GC21875@tucnak.zalov.cz>
 <20131010082430.GA20577@gmail.com>
 <20131010083107.GZ30970@tucnak.zalov.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131010083107.GZ30970@tucnak.zalov.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jakub Jelinek <jakub@redhat.com> wrote:

> On Thu, Oct 10, 2013 at 10:24:30AM +0200, Ingo Molnar wrote:
> > Something like the patch below? (Totally untested and all that.)
> > 
> > Notes:
> > 
> > - If the bug is fixed in 4.8.3 then the version check can be sharpened
> >   from 99999 to 40803.
> 
> The bug is likely going to be fixed already for 4.8.2 (to be released
> next week or so).
> 
> > - I'd really prefer this quirk versus having to add the extra barrier to 
> >   the label, as it makes the actual usage sites a lot less painful.
> 
> Please check how much it bloats the generated code.

on Linus's latest tree plain 'asm goto' is only rarely used, so the size 
impact of the patch, on x86-64 defconfig, is zero:

 vmlinux:
     text           data     bss      dec            hex filename
 11166823        1448024 1187840 13802687         d29cbf vmlinux.before
 11166823        1448024 1187840 13802687         d29cbf vmlinux.after
 1f7c3c1fd71b4b1327965bcfbc7a77fb  vmlinux.before
 3b246add801bc170e47096b712942395  vmlinux.after

Using GCC 4.8.1.

> Also, for the bitops patch, you probably want an asm_volatile_goto variant.

Also, for mutex_64.h - good point, will fix that.

Thanks,

	Ingo
