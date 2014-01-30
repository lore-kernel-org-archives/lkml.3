Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922AbaA3WHd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 17:07:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56935 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753743AbaA3WHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 17:07:31 -0500
Date: Thu, 30 Jan 2014 17:07:08 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Richard Weinberger <richard.weinberger@gmail.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Cong Ding <dinggnu@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Ingo Molnar <mingo@kernel.org>, Kees Cook <keescook@chromium.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mathias Krause <minipli@googlemail.com>,
        Michael Davidson <md@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: Re: [GIT PULL] x86/kaslr for v3.14
Message-ID: <20140130220708.GP9951@redhat.com>
References: <201401201647.s0KGlZdh004167@tazenda.hos.anvin.org>
 <CAFLxGvxO1MPDDjEh3FU5Gv2-eb6zBJxYtTnKdABDTTpbMxxYAw@mail.gmail.com>
 <52E5EFAF.3060609@linux.intel.com>
 <CAFLxGvxJ0A6hZ52RWffkg_zXXScyPn10P4HcKvdAXfE43h32Eg@mail.gmail.com>
 <52E601DA.7010605@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52E601DA.7010605@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 26, 2014 at 10:51:06PM -0800, H. Peter Anvin wrote:
> On 01/26/2014 10:49 PM, Richard Weinberger wrote:
> >>
> >> No, because that information is available to user space unless we panic.
> > 
> > Didn't you mean non-root?
> > I thought one has to set dmesg_restrict anyways if kASLR is used.
> > 
> > And isn't the offset available to perf too?
> > Of course only for root, but still user space.
> > 
> 
> For certain system security levels one want to protect even from a rogue
> root.  In those cases, leaking that information via dmesg and perf isn't
> going to work, either.
> 
> With lower security settings, by all means...

I am wondering if kdump functionality is impacted with this change.

Kexec tools prepares ELF headers for kernel memory ranges and for the
range where kernel text is mapped. So it needs to know virtual address
of the region where kernel is mapped (obtained by /proc/kcore) and
it gets the physical address where kernel is loaded from /proc/iomem.

So with this change are we planning to hide kernel text virtual address and
physical address information information from root in /proc/kcore and
/proc/iomem in anyway?

Thanks
Vivek
