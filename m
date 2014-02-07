Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532AbaBGQEa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 11:04:30 -0500
Received: from mga14.intel.com ([143.182.124.37]:43076 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831AbaBGQE3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 11:04:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,801,1384329600"; 
   d="scan'208";a="471469949"
Message-ID: <52F503FD.8080607@linux.intel.com>
Date: Fri, 07 Feb 2014 08:04:13 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>, Kees Cook <keescook@chromium.org>
CC: "H. Peter Anvin" <hpa@zytor.com>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Cong Ding <dinggnu@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mathias Krause <minipli@googlemail.com>,
        Michael Davidson <md@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Dave Young <dyoung@redhat.com>
Subject: Re: [GIT PULL] x86/kaslr for v3.14
References: <201401201647.s0KGlZdh004167@tazenda.hos.anvin.org> <CAFLxGvxO1MPDDjEh3FU5Gv2-eb6zBJxYtTnKdABDTTpbMxxYAw@mail.gmail.com> <52E5EFAF.3060609@linux.intel.com> <CAFLxGvxJ0A6hZ52RWffkg_zXXScyPn10P4HcKvdAXfE43h32Eg@mail.gmail.com> <52E601DA.7010605@zytor.com> <20140130220708.GP9951@redhat.com> <CAGXu5jKp0j71ucE7uOWRa+gQM1Wzp=_KdByJK4XnACTwiCW4ow@mail.gmail.com> <20140207144914.GA5949@redhat.com>
In-Reply-To: <20140207144914.GA5949@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2014 06:49 AM, Vivek Goyal wrote:
> 
> Hi Kees,
> 
> Dave Young is testing kdump with kaslr enabled. He is facing some issues.
> 
> One issue he mentioned is that when second kernel boots, it might be
> placed in an area which is outside the reserved area for second kernel.
> 
> We reserve a certain memory for second kernel. And modify memory map of
> second kernel using memmap=exactmap parameter. Looks like kernel placement
> is happening before memmap=exactmap takes effect. And that seems to be
> the reason that second kernel can be placed outside the reserved memory.
> 
> IOW, memmap=exactmap and kaslr don't work together. Is it possible to
> first let memmap=exactmap take affect and then kaslr does its job. Or it
> is too late by the time memmap=exactmap is parsed.
> 
> As a workaround, Dave is currently using "nokaslr" command line parameter
> for second kernel. He is still facing issues where makedumpfile segment
> faults. He is looking into it further.
> 
> I thought I will atleast bring up with issue of memmap=exactmap and kaslr
> being incompatible.
> 

Yes, because memmap=exactmap gets parsed too late; kaslr assumes that
the e820 information passed to it is actually correct.

Yet another cause of breakage caused by the decision on the part of
kdump to rely on command-line options.

	-hpa


