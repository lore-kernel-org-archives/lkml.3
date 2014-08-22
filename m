Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932065AbaHVIZI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 04:25:08 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:60214 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754296AbaHVIZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 04:25:05 -0400
Date: Fri, 22 Aug 2014 10:24:59 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Mathias Krause <minipli@googlemail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joe Perches <joe@perches.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCHv3 0/9] Mark literal strings in __init / __exit code
Message-ID: <20140822082459.GA8771@gmail.com>
References: <1408623792-7973-1-git-send-email-minipli@googlemail.com>
 <20140821125717.GA28987@gmail.com>
 <CA+rthh8XzSC-n+WaYEWiJQdF1XOSRiGSmxpJSFy9duXOOwXX_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+rthh8XzSC-n+WaYEWiJQdF1XOSRiGSmxpJSFy9duXOOwXX_w@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mathias Krause <minipli@googlemail.com> wrote:

> > It feels like a burdensome hack that kernel developers are 
> > forced to use different printing facilities, depending on 
> > the life cycle of a method. We want to simplify init 
> > annotations, we don't want to complicate them!
> 
> Does this:
> 
>     pi_info("mkiss: AX.25 Multikiss, Hans Albas PE1AYX\n");
> 
> really look more complicated compared to this?:
> 
>     static const char banner[] __initconst = KERN_INFO \
>         "mkiss: AX.25 Multikiss, Hans Albas PE1AYX\n";
>     printk(banner);
> 
> The latter can be found in drivers/net/hamradio/mkiss.c. Aged 
> code, admitted. But we have a few more of those and the 
> pi_info() looks way more appealing to me by doing the very 
> same thing ;)

My point is that both are complicated, compared to using the 
regular printk() variants.

In general printk()s should not be aware of what function 
context they are in.

> > And if tooling isn't ready for this, then wouldn't the 
> > right solution be to improve tooling - instead of 
> > complicating the kernel?
> 
> Plugin based approaches for this have been mentioned before 
> but those suffer from the same "global view" problem. So, 
> IMHO it's not that easy to solve it at the toolchain level. 

It might be solved via a regular tooling feature, or via 
tooling extension based on plugins.

Regardless of how it's implemented on the tooling side, my 
point remains: this kind of optimization is done on the tooling 
side in a natural fashion, while it's an ongoing maintenance 
concern on the kernel side.

So it should be done on the tooling side, especially as the 
benefits appear to be marginal.

Thanks,

	Ingo
