Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438AbaB0FbO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 00:31:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49882 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781AbaB0FbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 00:31:13 -0500
Message-ID: <530ECBB1.40806@zytor.com>
Date: Wed, 26 Feb 2014 21:22:57 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
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
References: <cover.1393462777.git.luto@amacapital.net> <ecbd286ccd2ac038740a07cc04f5d98e96af669f.1393462777.git.luto@amacapital.net> <20140227033920.GI12219@tassilo.jf.intel.com> <530EC7D1.3000706@zytor.com> <CALCETrWbS3B_63Q76E5RL0Y6B=1=1ObmECR3HTMk1HQ-4OwN8A@mail.gmail.com>
In-Reply-To: <CALCETrWbS3B_63Q76E5RL0Y6B=1=1ObmECR3HTMk1HQ-4OwN8A@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/2014 09:19 PM, Andy Lutomirski wrote:
>>
>> The normal ABI almost certainly makes more sense; as such -mregparm=3 is
>> probably not what we want, and I suspect it makes more sense to just
>> drop that from the CFLAGS line?
> 
> Hmm.  What happens on a native 32-bit build?  IIRC the whole kernel is
> build with regparm(3).
> 

Well, the vdso is still built separately, so we can use different CFLAGS
if we want to.

> If we want to save a cycle or two, then regparm(3) is probably faster.
>  But I think that these functions should either be asmlinkage or (on
> 32 bit builds) explicitly regparm(3) to avoid confusion.

I suggest using the standard ABI, but I suggest doing it via CFLAGS.

It isn't any faster if the C library has to provide a wrapper just to
marshal parameters.

	-hpa


