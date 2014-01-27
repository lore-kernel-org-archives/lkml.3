Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447AbaA0Hnl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 02:43:41 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:53264 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbaA0Hnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 02:43:39 -0500
Date: Mon, 27 Jan 2014 08:43:35 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Richard Weinberger <richard.weinberger@gmail.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Cong Ding <dinggnu@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Kees Cook <keescook@chromium.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mathias Krause <minipli@googlemail.com>,
        Michael Davidson <md@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: Re: [GIT PULL] x86/kaslr for v3.14
Message-ID: <20140127074335.GA20258@gmail.com>
References: <201401201647.s0KGlZdh004167@tazenda.hos.anvin.org>
 <CAFLxGvxO1MPDDjEh3FU5Gv2-eb6zBJxYtTnKdABDTTpbMxxYAw@mail.gmail.com>
 <52E5EFAF.3060609@linux.intel.com>
 <CAFLxGvxJ0A6hZ52RWffkg_zXXScyPn10P4HcKvdAXfE43h32Eg@mail.gmail.com>
 <52E601DA.7010605@zytor.com>
 <20140127073836.GB19617@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140127073836.GB19617@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> 
> * H. Peter Anvin <hpa@zytor.com> wrote:
> 
> > On 01/26/2014 10:49 PM, Richard Weinberger wrote:
> > >>
> > >> No, because that information is available to user space unless we panic.
> > > 
> > > Didn't you mean non-root?
> > > I thought one has to set dmesg_restrict anyways if kASLR is used.
> > > 
> > > And isn't the offset available to perf too?
> > > Of course only for root, but still user space.
> > > 
> > 
> > For certain system security levels one want to protect even from a 
> > rogue root.  In those cases, leaking that information via dmesg and 
> > perf isn't going to work, either.
> > 
> > With lower security settings, by all means...
> 
> The 'no' was categorical and unconditional though, so is the right 
> answer perhaps something more along the lines of:
> 
>   'Yes, the random offset can be reported in an oops, as long as
>    high security setups can turn off the reporting of the offset,
>    in their idealistic attempt to protect the system against root.'
> 
> ?

'reporting of the offset' should probably be 'reporting kernel data' - 
there's many possible ways an oops (and its associated raw stack dump) 
can leak the offset, I'm not sure this can ever be made 'safe' against 
a rougue root.

Not giving kernel originated debug information at all would. (At the 
cost of reducing the utility of having that root user around, of 
course.)

Thanks,

	Ingo
