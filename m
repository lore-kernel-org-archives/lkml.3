Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335AbaB0D0I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 22:26:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48914 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752868AbaB0D0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 22:26:06 -0500
Message-ID: <530EB010.6090204@zytor.com>
Date: Wed, 26 Feb 2014 19:25:04 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>,
        Stefani Seibold <stefani@seibold.net>, X86 ML <x86@kernel.org>
CC: Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        andriy.shevchenko@linux.intel.com, Martin.Runge@rohde-schwarz.com,
        Andreas.Brief@rohde-schwarz.com
Subject: Re: [PATCH 1/2] x86: Mark __vdso entries as asmlinkage
References: <CALCETrW_PHbDzn2S3NyGTSk4yqYjnpJbStCuLc_yBGdfspfFCA@mail.gmail.com> <cover.1393462777.git.luto@amacapital.net> <ecbd286ccd2ac038740a07cc04f5d98e96af669f.1393462777.git.luto@amacapital.net>
In-Reply-To: <ecbd286ccd2ac038740a07cc04f5d98e96af669f.1393462777.git.luto@amacapital.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/2014 05:02 PM, Andy Lutomirski wrote:
> This makes no difference for 64-bit, bit it's critical for 32-bit code:
> these functions are called from outside the kernel, so they need to comply
> with the ABI.

Or at least with *an* ABI (the i386 syscall vdso uses the syscall
convention, not the i386 ABI convention, for example.)  However, it
probably does makes most sense to just stick with the standard i386 ABI.

	-hpa


