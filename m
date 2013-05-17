Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442Ab3EQKUL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 06:20:11 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59778 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425Ab3EQKUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 06:20:09 -0400
Date: Fri, 17 May 2013 12:18:24 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] locking: Fix copy/paste errors
 "ARCH_INLINE_*_UNLOCK_BH"
Message-ID: <20130517101824.GA5162@dyad.programming.kicks-ass.net>
References: <1365428154.1830.99.camel@x61.thuisdomein>
 <20130408151609.GA13640@gmail.com>
 <1365435015.1830.113.camel@x61.thuisdomein>
 <20130408153614.GB17500@gmail.com>
 <1368780693.1350.228.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368780693.1350.228.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 17, 2013 at 10:51:33AM +0200, Paul Bolle wrote:
> The Kconfig symbols ARCH_INLINE_READ_UNLOCK_IRQ,
> ARCH_INLINE_SPIN_UNLOCK_IRQ, and ARCH_INLINE_WRITE_UNLOCK_IRQ were added
> in v2.6.33, but have never actually been used. Ingo Molnar spotted that
> this is caused by three identical copy/paste erros. Eg, the Kconfig
> entry for
>          INLINE_READ_UNLOCK_IRQ
> 
> has an (optional) dependency on
>     ARCH_INLINE_READ_UNLOCK_BH
> 
> were it apparently should depend on
>     ARCH_INLINE_READ_UNLOCK_IRQ
> 
> instead. Likewise for the Kconfig entries for INLINE_SPIN_UNLOCK_IRQ and
> INLINE_WRITE_UNLOCK_IRQ. Fix these three errors.
> 
> Reported-by: Ingo Molnar <mingo@kernel.org>
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Thanks!
