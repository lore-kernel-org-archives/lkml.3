Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756959Ab3BKOHK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 09:07:10 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:44081 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756466Ab3BKOHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 09:07:07 -0500
Date: Mon, 11 Feb 2013 14:07:05 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jonas Bonn <jonas.bonn@gmail.com>
Cc: Vineet Gupta <Vineet.Gupta1@synopsys.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: pt_regs leak into userspace (was Re: [PATCH v3 20/71] ARC:
 Signal handling)
Message-ID: <20130211140704.GI4503@ZenIV.linux.org.uk>
References: <1359024639-21915-1-git-send-email-vgupta@synopsys.com>
 <1359024639-21915-9-git-send-email-vgupta@synopsys.com>
 <51189D2F.4030000@synopsys.com>
 <CACM3HyGNZxfOXpw01POBVT-YcVKQsnPkO6Kgg+epfZS-x-BRCg@mail.gmail.com>
 <5118C458.2070205@synopsys.com>
 <CACM3HyF2GHz5PKuurYG2Hg+UEKeto+zme5gcv2fxQDC=tpZYRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACM3HyF2GHz5PKuurYG2Hg+UEKeto+zme5gcv2fxQDC=tpZYRw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2013 at 11:30:50AM +0100, Jonas Bonn wrote:

> >> Is this really true?  Don't setcontext and friends require that _all_
> >> the registers be part of sigcontext?
> >
> > But for an ABI - callee saved regs will anyhow be saved/restored even in
> > setcontext case ! So collecting it for that purpose seems useless, or am I missing
> > something here.
> 
> Yes, I agree with you on the ABI bit... but set/get/swapcontext are
> special in that they use rt_sigreturn to "trick" the kernel into
> swapping out _all_ registers; it's a light-weight (userspace) context
> switch.
> 
> (I really don't know this area very well, though, so I'm hoping
> somebody more knowledgable jumps in here... Al?)

I'd suggest asking itanic folks; they do *not* put callee-saved stuff into
sigcontext.  AFAICS, they don't have setcontext() implemented as a syscall
at all - it's done as sigprocmask() + doing to callee-saved registers what
longjmp() does.
