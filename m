Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758955Ab3BUWTV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 17:19:21 -0500
Received: from www.linutronix.de ([62.245.132.108]:53175 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755040Ab3BUWTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 17:19:20 -0500
Date: Thu, 21 Feb 2013 23:19:18 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
cc: Jason Liu <liu.h.jason@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: too many timer retries happen when do local timer swtich with
 broadcast timer
In-Reply-To: <51263975.20906@ti.com>
Message-ID: <alpine.LFD.2.02.1302212214020.22263@ionos>
References: <CAB4PhKevqf0e4nzYraE9ZTAFbPCFfNpguAnPoVpJh-FFe2TAZA@mail.gmail.com> <alpine.LFD.2.02.1302201400400.22263@ionos> <CAB4PhKfxPcyQfpM2Ra1OxsyYhS5fnkjtPy=uYgxFHim1rOdoug@mail.gmail.com> <alpine.LFD.2.02.1302211015270.22263@ionos>
 <CAB4PhKf+Z-TK4KGDZm1kYOWibg=e2Ehnhjxt_oTbFq9eqouAjA@mail.gmail.com> <alpine.LFD.2.02.1302211436300.22263@ionos> <51263975.20906@ti.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Feb 2013, Santosh Shilimkar wrote:
> On Thursday 21 February 2013 07:18 PM, Thomas Gleixner wrote:
> > find below a completely untested patch, which should address that issue.
> > 
> After looking at the thread, I tried to see the issue on OMAP and could
> see the same issue as Jason.

That's interesting. We have the same issue on x86 since 2007 and
nobody noticed ever. It's basically the same problem there, but it
seems that on x86 getting out of those low power states is way slower
than the minimal reprogramming delta which is used to enforce the
local timer to fire after the wakeup. 

I'm still amazed that as Jason stated a 1us reprogramming delta is
sufficient to get this ping-pong going. I somehow doubt that, but
maybe ARM is really that fast :)

> Your patch fixes the retries on both CPUs on my dual core machine. So
> you use my tested by if you need one.

They are always welcome.

> Tested-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> 
> Thanks for the patch.
> And thanks to Jason for spotting the issue.

And for coping with my initial inability to parse his report!

Thanks,

	tglx
