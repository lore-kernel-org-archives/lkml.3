Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659AbaCXJYm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 05:24:42 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:42534 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512AbaCXJYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 05:24:41 -0400
Date: Mon, 24 Mar 2014 10:24:37 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86/apic changes for v3.14
Message-ID: <20140324092437.GA9344@gmail.com>
References: <20140120134220.GA12050@gmail.com>
 <alpine.LFD.2.10.1403222327130.21669@eddie.linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.10.1403222327130.21669@eddie.linux-mips.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Maciej W. Rozycki <macro@linux-mips.org> wrote:

> IMPLICATION: There is a possibility of clearing the Error register 
> status since the write to the register is not specifically blocked.
> 
> WORKAROUND: Writes should not occur to the Pentium processor APIC 
> Error register.
> 
> STATUS: For the steppings affected see the Summary Table of Changes 
> at the beginning of this section."
> 
> The steppings affected are actually: B1, B3 and B5.  Do we want to 
> keep supporting them?  I think yes, we already handle the erratum 
> elsewhere (lapic_setup_esr).  So how about:
> 
> 	if (lapic_get_maxlvt() > 3)	/* Due to the Pentium erratum 3AP. */
> 		apic_write(APIC_ESR, 0);
> 	v = apic_read(APIC_ESR);
> 
> instead?  I can make a patch if that would make your life easier.

Sure, a patch would be helpful.

>  There's room for optimisation here, but I think it's not worth the 
> effort as this is a slow path, APIC error interrupts are not 
> supposed to happen and are I believe extremely uncommon with FSB 
> message delivery.

Agreed.

Thanks,

	Ingo
