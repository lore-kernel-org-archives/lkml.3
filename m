Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769AbaD1U7c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 16:59:32 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:34132 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756525AbaD1U73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 16:59:29 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18OhbwwJolK3d56+5WZ8/yACVvN6mOTBIM=
X-DKIM: OpenDKIM Filter v2.0.1 titan D3C9556671F
Date: Mon, 28 Apr 2014 16:59:11 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 3/3] irqchip: orion: reverse irq handling
 priority
Message-ID: <20140428205911.GC28159@titan.lakedaemon.net>
References: <1398540855-27367-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1398540855-27367-4-git-send-email-sebastian.hesselbarth@gmail.com>
 <alpine.DEB.2.02.1404282137240.6261@ionos.tec.linutronix.de>
 <535EB4C1.9090603@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <535EB4C1.9090603@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 10:06:25PM +0200, Sebastian Hesselbarth wrote:
> On 04/28/2014 09:39 PM, Thomas Gleixner wrote:
> > On Sat, 26 Apr 2014, Sebastian Hesselbarth wrote:
> > 
> >> Non-DT irq handlers were working through irq causes from most-significant
> >> to least-significant bit, while DT irqchip driver does it the other way
> >> round. This revealed some more HW issues on Kirkwood peripheral IP, where
> >> spurious sdio irqs can happen although IP's irq enable registers are all
> >> zero. Although, not directly related with the described issue, reverse
> >> irq bit handling back to original order by replacing ffs() with fls().
> > 
> > So why are we reverting to the original order?
> > 
> > The explanation above is just confusing.
> 
> Actually, I first wanted to reply "The original order worked for
> years, so get back to it." But then I thought about finding a better
> answer and remembered some comment of Russell a while ago.
> 


> I disassembled the generated binary and the original order saves two
> instructions for each bit count using clz.
> 
> With this patch:
>   60:   e3a07001        mov     r7, #1
>   64:   e16f3f14        clz     r3, r4
>   68:   e263301f        rsb     r3, r3, #31
>   6c:   e1c44317        bic     r4, r4, r7, lsl r3
>   70:   e5951004        ldr     r1, [r5, #4]
> 
> Without this patch:
>   60:   e3a06001        mov     r6, #1
>   64:   e2643000        rsb     r3, r4, #0
>   68:   e0033004        and     r3, r3, r4
>   6c:   e16f3f13        clz     r3, r3
>   70:   e263301f        rsb     r3, r3, #31
>   74:   e1c44316        bic     r4, r4, r6, lsl r3
>   78:   e5971004        ldr     r1, [r7, #4]


> You want me to reword the commit message accordingly?

Please do.  I would even quote the above.

thx,

Jason.
