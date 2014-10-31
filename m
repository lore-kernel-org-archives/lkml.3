Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759941AbaJaXpn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 19:45:43 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:37292 "EHLO
	relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431AbaJaXpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 19:45:42 -0400
X-Originating-IP: 50.43.41.112
Date: Fri, 31 Oct 2014 16:45:31 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Kees Cook <keescook@chromium.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>, Junjie Mao <eternal.n08@gmail.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH v2] x86, boot: add hex output for debugging
Message-ID: <20141031234531.GA12082@thin>
References: <20141031205819.GA13262@www.outflux.net>
 <CAE9FiQVYBwTifYXACeJRBOEtrN6o5kBpA6v0xLqUYS379pH-Mw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQVYBwTifYXACeJRBOEtrN6o5kBpA6v0xLqUYS379pH-Mw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 04:31:32PM -0700, Yinghai Lu wrote:
> On Fri, Oct 31, 2014 at 1:58 PM, Kees Cook <keescook@chromium.org> wrote:
> > This is useful for reporting various addresses or other values while
> > debugging early boot. For example, when CONFIG_X86_VERBOSE_BOOTUP is set,
> > this is now visible at boot time:
> >
> >         early console in setup code
> >         early console in decompress_kernel
> >         input_data: 0x0000000001e1526e
> >         input_len: 0x0000000000732236
> >         output: 0x0000000001000000
> >         output_len: 0x0000000001535640
> >         run_size: 0x00000000021fb000
> >         KASLR using RDTSC...
> >
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> > ---
> > Since this displays run_size, this patch depends on Junjie Mao's patch
> > "x86, kaslr: Prevent .bss from overlaping initrd"
> >
> > ---
> >  arch/x86/boot/compressed/misc.c | 24 ++++++++++++++++++++++++
> >  arch/x86/boot/compressed/misc.h | 11 +++++++++++
> >  2 files changed, 35 insertions(+)
> ...
> 
> We can reuse printf.c in arch/x86/boot.
> 
> I had attached one in local tree for a while. or even sent it before
> several years ago.

I don't think we need the full generality of printf in the decompression
stub.  I prefer Kees' patch, though I'd still like to see __puthex made
conditional.

- Josh Triplett
