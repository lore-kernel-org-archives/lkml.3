Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757236AbaJaX4e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 19:56:34 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:50560 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545AbaJaX4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 19:56:33 -0400
X-Originating-IP: 50.43.41.112
Date: Fri, 31 Oct 2014 16:56:22 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>, Vivek Goyal <vgoyal@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, Junjie Mao <eternal.n08@gmail.com>
Subject: Re: [PATCH] x86, boot: add hex output for debugging
Message-ID: <20141031235622.GD12082@thin>
References: <20141031162037.GA26233@www.outflux.net>
 <20141031203304.GA32697@cloud>
 <CAGXu5jKu2uCTJ+cB1pjZs0MevS8mJcv2qH8wtw0B110hrqwqqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jKu2uCTJ+cB1pjZs0MevS8mJcv2qH8wtw0B110hrqwqqg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 01:55:33PM -0700, Kees Cook wrote:
> On Fri, Oct 31, 2014 at 1:33 PM,  <josh@joshtriplett.org> wrote:
> > On Fri, Oct 31, 2014 at 09:20:37AM -0700, Kees Cook wrote:
> >> This is useful for reporting various addresses or other values while
> >> debugging early boot.
> >>
> >> Signed-off-by: Kees Cook <keescook@chromium.org>
> >
> > You haven't provided any user of this function.  I don't think this
> > should get merged without a caller (nor should an artificial caller be
> > added).  What's your use case for adding this?
> 
> I'll fix that.

Thanks.

> > Also, while I realize __putstr already has this problem, ideally all the
> > printing functions in this file should go in some separate source file
> > that gets omitted when !CONFIG_PRINTK (or possibly
> > !CONFIG_EARLY_PRINTK).
> 
> Hm, I don't agree: we need error_putstr, not just debug_putstr, and
> early_printk is just for serial console, where as __putstr works
> against the boot block's defined video area too, IIUC.

OK, that seems like a good argument that it shouldn't go under
EARLY_PRINTK.  However, for size-constrained systems that have nowhere
for the output to go at all, it still makes sense to compile all of the
printing infrastructure out of the decompression stub, especially since
that code itself does not get compressed and thus has a higher impact
than code in vmlinux.

- Josh Triplett
