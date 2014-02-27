Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555AbaB0XNW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 18:13:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33694 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751255AbaB0XNV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 18:13:21 -0500
Message-ID: <530FC651.8090102@zytor.com>
Date: Thu, 27 Feb 2014 15:12:17 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Andi Kleen <ak@linux.intel.com>, Stefani Seibold <stefani@seibold.net>,
        X86 ML <x86@kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        andriy.shevchenko@linux.intel.com, Martin.Runge@rohde-schwarz.com,
        Andreas.Brief@rohde-schwarz.com
Subject: Re: [PATCH 1/2] x86: Mark __vdso entries as asmlinkage
References: <cover.1393462777.git.luto@amacapital.net> <ecbd286ccd2ac038740a07cc04f5d98e96af669f.1393462777.git.luto@amacapital.net> <20140227033920.GI12219@tassilo.jf.intel.com> <530EC7D1.3000706@zytor.com> <CALCETrWbS3B_63Q76E5RL0Y6B=1=1ObmECR3HTMk1HQ-4OwN8A@mail.gmail.com> <530ECBB1.40806@zytor.com> <CALCETrWXO8zxvjbT9usjghkM_MEzGOa9_18x7xXPcOOPYeXijA@mail.gmail.com>
In-Reply-To: <CALCETrWXO8zxvjbT9usjghkM_MEzGOa9_18x7xXPcOOPYeXijA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2014 12:11 PM, Andy Lutomirski wrote:
> 
> Hmm.  This sort of goes against existing x86_32 practice where,
> AFAICT, things that need a particular calling convention specify
> asmlinkage and everything else uses regparm(3) if config/kbuild thinks
> it's appropriate.
> 

That is not really true for things that aren't part of the kernel image
proper (e.g. the real mode code and so on.)  This is a very special case.

> But I'm happy to resubmit the patch if you prefer the CFLAGS approach
> for the 32-bit vdso.  I don't think anything will break, since I don't
> think that the 32-bit vdso has any other exported C code.

I think it is the better way to go.

>> It isn't any faster if the C library has to provide a wrapper just to
>> marshal parameters.
> 
> Probably true, given that the glibc wrapper could, in principle, use
> an optimized tail call.  Also, I see no reason why vdso functions,
> alone of all userspace code, should be special.

Yes, let's stick to the standard ABI.  The syscall entry point was very
special.

	-hpa


