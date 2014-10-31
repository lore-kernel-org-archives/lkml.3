Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759292AbaJaUMb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 16:12:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60475 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759198AbaJaUMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 16:12:30 -0400
Date: Fri, 31 Oct 2014 16:11:56 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Randy Dunlap <rdunlap@infradead.org>, Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Junjie Mao <eternal.n08@gmail.com>
Subject: Re: [PATCH] x86, boot: add hex output for debugging
Message-ID: <20141031201156.GJ2851@redhat.com>
References: <20141031162037.GA26233@www.outflux.net>
 <5453C49A.2000500@infradead.org>
 <20141031174251.GM3274@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141031174251.GM3274@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 10:42:51AM -0700, Andi Kleen wrote:
> > > +void __puthex(unsigned long value)
> > > +{
> > > +	char alpha[2] = "0";
> > > +	int bits;
> > > +	unsigned char byte;
> > 
> > what is 'byte' for?  (unused)
> 
> Well the whole function is unused. We don't normally add unused functions
> to the code because they bitrot too easily.

I think this is useful. I had to write similar code for printing out
values during early boot.

May be we can print some values if CONFIG_X86_VERBOSE_BOOTUP=y.
That way it will not be an unused code and others can reuse it easily
to print additional data during debugging.

Thanks
Vivek
