Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026AbaBBA1J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 19:27:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37015 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985AbaBBA1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 19:27:06 -0500
Message-ID: <52ED90A3.9080802@zytor.com>
Date: Sat, 01 Feb 2014 16:26:11 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>,
        Stefani Seibold <stefani@seibold.net>
CC: Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        andriy.shevchenko@linux.intel.com, Martin.Runge@rohde-schwarz.com,
        Andreas.Brief@rohde-schwarz.com
Subject: Re: [PATCH 3/4] Add 32 bit VDSO time support for 32 bit kernel
References: <1391268756-10766-1-git-send-email-stefani@seibold.net> <1391268756-10766-4-git-send-email-stefani@seibold.net> <CALCETrVp+aTm_mT4bg6kcaX3QOnqyjVdfM9vdhHZPsKG276X0A@mail.gmail.com>
In-Reply-To: <CALCETrVp+aTm_mT4bg6kcaX3QOnqyjVdfM9vdhHZPsKG276X0A@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2014 03:59 PM, Andy Lutomirski wrote:
> 
>   If it is, indeed, okay to use non-fixed maps on 32-bit, it might
> also be okay on 64-bit.  If so, it could be useful to implement that,
> which would remove a bit of a wart and allow PR_SET_TSC to work
> usefully for 64-bit userspace.  (This would remove the need for the
> VVAR macro and would allow shorter rip-relative address modes.)
> 

We can't really move the 64-bit legacy vsyscall area, though, as it is
an ABI.  It can be disabled with vsyscall=none, but Linus has vehemently
vetoed removing them.

>  (Note that those fixmaps are a security problem on native 32-bit if
> NX is not available.  We may not care.)

Not only on native 32 bit... although the amount of 64-bit hardware
without NX is quite small, the same is true for anywhere near modern
32-bit hardware.

>>
>> -#define VDSO_HIGH_BASE         0xffffe000U /* CONFIG_COMPAT_VDSO address */
>> +#define VDSO_HIGH_BASE         0xffffc000U /* CONFIG_COMPAT_VDSO address */
> 
> This is odd.  Can you explain it?
> 

He needs 3 pages instead of 1 after his changes.

	-hpa


