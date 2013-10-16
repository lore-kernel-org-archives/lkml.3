Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005Ab3JPGLX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 02:11:23 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:51602 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604Ab3JPGLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 02:11:21 -0400
Date: Wed, 16 Oct 2013 08:11:18 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "Wang, Xiaoming" <xiaoming.wang@intel.com>,
        "Li, Zhuangzhi" <zhuangzhi.li@intel.com>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>
Subject: Re: [PATCH] x86: Remove WARN_ON(in_nmi()) from vmalloc_fault
Message-ID: <20131016061118.GA21109@gmail.com>
References: <20131015163906.342d8ffa@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131015163906.342d8ffa@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Since the NMI iretq nesting has been fixed, there's no reason that
> an NMI handler can not take a page fault for vmalloc'd code. No locks
> are taken in that code path, and the software now handles nested NMIs
> when the fault re-enables NMIs on iretq.
> 
> Not only that, if the vmalloc_fault() WARN_ON_ONCE() is hit, and that
> warn on triggers a vmalloc fault for some reason, then we can go into
> an infinite loop (the WARN_ON_ONCE() does the WARN() before updating
> the variable to make it happen "once").
> 
> Reported-by: "Liu, Chuansheng" <chuansheng.liu@intel.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Would be nice to see the warning quoted that triggered this.

Thanks,

	Ingo
