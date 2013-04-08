Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936414Ab3DHPaU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 11:30:20 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:64623 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936341Ab3DHPaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 11:30:18 -0400
Message-ID: <1365435015.1830.113.camel@x61.thuisdomein>
Subject: Re: [PATCH] locking: remove three unused Kconfig symbols
From: Paul Bolle <pebolle@tiscali.nl>
To: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux390@de.ibm.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 08 Apr 2013 17:30:15 +0200
In-Reply-To: <20130408151609.GA13640@gmail.com>
References: <1365428154.1830.99.camel@x61.thuisdomein>
	 <20130408151609.GA13640@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Apr 2013 15:30:15.0613 (UTC) FILETIME=[F7F066D0:01CE346D]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-08 at 17:16 +0200, Ingo Molnar wrote:
> * Paul Bolle <pebolle@tiscali.nl> wrote:
> > The Kconfig symbols ARCH_INLINE_READ_UNLOCK_IRQ,
> > ARCH_INLINE_SPIN_UNLOCK_IRQ, and ARCH_INLINE_WRITE_UNLOCK_IRQ were added
> > in v2.6.33, but have never actually been used. It is safe to remove
> > these.
> > 
> Erm, if you look at the code in question you'll see that they are unused I think 
> due to a bug:
> 
>  config INLINE_READ_UNLOCK_IRQ
>         def_bool y
>         depends on !PREEMPT || ARCH_INLINE_READ_UNLOCK_BH
> 
> Shouldn't that depend on ARCH_INLINE_READ_UNLOCK_IRQ?
> 
> Similarly for the others.

Yes, that seems correct. I must admit that I didn't spot that
possibility, but then again this Kconfig file is near unreadable (too
much repetition for human readers).

Would you have any idea why this problem wasn't noticed in 16 (!)
releases? Fedora 17, which I did this patch on, has Kconfig symbolk
PREEMPT not set. Is it perhaps commit to not enable that option?


Paul Bolle

