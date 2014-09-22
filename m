Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796AbaIVUHV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 16:07:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:56201 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000AbaIVUHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 16:07:20 -0400
Date: Mon, 22 Sep 2014 22:07:16 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "maintainer:X86 ARCHITECTURE..." <x86@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "open list:X86 ARCHITECTURE..." <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] x86: Use ACCESS_ONCE() for atomic_read()
Message-ID: <20140922200716.GB3128@worktop.programming.kicks-ass.net>
References: <1411415590-12193-1-git-send-email-bobby.prani@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411415590-12193-1-git-send-email-bobby.prani@gmail.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 03:53:09PM -0400, Pranith Kumar wrote:
> Use the much easier to read ACCESS_ONCE() which is basically the same thing as
> the cast to volatile.
> 
> Please note the change in volatile cast: ACCESS_ONCE(v)->counter to
> ACCESS_ONCE(v->counter).
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> ---
>  arch/x86/include/asm/atomic.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

If you want to do something like so, then be consistent and do them all.
