Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567Ab3IQKxu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 06:53:50 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:62782 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207Ab3IQKxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 06:53:48 -0400
Date: Tue, 17 Sep 2013 12:53:44 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>, Peter Anvin <hpa@zytor.com>,
        Mike Galbraith <bitbucket@online.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH 00/11] preempt_count rework -v3
Message-ID: <20130917105344.GA23024@gmail.com>
References: <20130917082838.218329307@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130917082838.218329307@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> These patches optimize preempt_enable by firstly folding the preempt and
> need_resched tests into one -- this should work for all architectures. And
> secondly by providing per-arch preempt_count implementations; with x86 using
> per-cpu preempt_count for fastest access.
> 
> These patches have been boot tested on CONFIG_PREEMPT=y x86_64 and survive
> building a x86_64-defconfig kernel.
> 
>    text    data     bss     filename
> 11387014  1454776 1187840 defconfig-build/vmlinux.before
> 11352294  1454776 1187840 defconfig-build/vmlinux.after

That's a 0.3% size improvement (and most of the improvement is in 
hotpaths), despite GCC is being somewhat stupid about not allowing us to 
mark asm goto targets as cold paths and thus causes some unnecessary 
register shuffling in some cases, right?

Not bad IMO.

Thanks,

	Ingo
