Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758738AbaCTPTD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 11:19:03 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:33639 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756146AbaCTPTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 11:19:00 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1403201614360.18573@ionos.tec.linutronix.de>
References: <1395301511-5908-1-git-send-email-stefani@seibold.net>
 <alpine.DEB.2.02.1403201039400.18573@ionos.tec.linutronix.de>
 <1395315494.1127.3.camel@vger.seibold.net> <alpine.DEB.2.02.1403201328520.18573@ionos.tec.linutronix.de>
 <CALCETrVgC7yKsu0KM0=TfUuX9msn9ru_nG=Fv6Mz6PKDTnWGnQ@mail.gmail.com> <alpine.DEB.2.02.1403201614360.18573@ionos.tec.linutronix.de>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 20 Mar 2014 08:18:39 -0700
Message-ID: <CALCETrWQbviwiQi2cJi=_kkjTPG8NpsYT4Sf0UB8SaDWN5rr7A@mail.gmail.com>
Subject: Re: [PATCH] x86, vdso32: fix out of memory handling setup vDSO
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Stefani Seibold <stefani@seibold.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Martin Runge <Martin.Runge@rohde-schwarz.com>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2014 at 8:15 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Thu, 20 Mar 2014, Andy Lutomirski wrote:
>> On Thu, Mar 20, 2014 at 5:30 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
>> > On Thu, 20 Mar 2014, Stefani Seibold wrote:
>> >> All complains are design decisions not made by me. I will send a patch
>> >> for the GFP_ATOMIC thing. For the other one it would be the best to ask
>> >> Andy for the reason.
>> >
>> > I'm not saying it's your fault, but if we rework code, then we really
>> > should question such things. What happens if you remove the x32 call
>> > and make the x64 subsys thing valid for both cases?
>> >
>>
>> It's not just that.  The x86_64 and x32 vdso page arrays are *far*
>> cleaner than the 32-bit variant.  They manage to do the entire vdso
>> setup dance without any allocation at all.  This avoids silly
>> questions about error handling and GFP_KERNEL :)
>>
>> See vdso/vdso.S for the rather small amount of magic needed.
>
> Is there any reason why we can't use that for x86_32 ?
>

Not really.  I'll play with it a bit.

> Thanks,
>
>         tglx



-- 
Andy Lutomirski
AMA Capital Management, LLC
