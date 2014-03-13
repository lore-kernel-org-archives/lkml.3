Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755AbaCMR2g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 13:28:36 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:37587 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754126AbaCMR2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 13:28:31 -0400
MIME-Version: 1.0
In-Reply-To: <5321D45C.7040504@zytor.com>
References: <1394664680-17799-1-git-send-email-stefani@seibold.net>
 <1394664680-17799-4-git-send-email-stefani@seibold.net> <5320E689.7060607@zytor.com>
 <CALCETrXQJvkk-5ncSgTyoy9sCN0AT+h9-1F6wAnxqRm242PjrQ@mail.gmail.com> <5321D45C.7040504@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 13 Mar 2014 10:28:10 -0700
Message-ID: <CALCETrVy3oW=qvJWbGtKTZ=0dZLjHtmBphPDnP1N8nLmXc=+9A@mail.gmail.com>
Subject: Re: [PATCH 3/3] x86, vdso32: handle 32 bit vDSO larger one page
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Stefani Seibold <stefani@seibold.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        andriy.shevchenko@linux.intel.com,
        Martin Runge <Martin.Runge@rohde-schwarz.com>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2014 at 8:53 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 03/12/2014 03:59 PM, Andy Lutomirski wrote:
>>
>> Note that this code is completely unnecessary if either of my patch
>> sets is accepted.  Since you're the maintainer, can you give an
>> opinion? :)
>>
>
> I'm trying to unwind all the patches going around, Linus' feedback and
> so on, and figure out what this means in concrete terms especially in
> the light of the 3.15 merge window coming up.
>
> I tried to apply your patchset "[PATCH v2 0/2] x86: Relocate the compat
> vdso per process" on top of tip:x86/vdso, but it conflicts pretty hard
> -- I guess you are using a different baseline, but that makes it
> complicated to deal with.

It applies to -linus.  I think that we should resolve the compat
issues first and then add timing code on top, since a decent chunk of
Stefani's changes will be unnecessary once the compat vdso is either
gone or unified with the non-compat vdso.

Does this mean you prefer the relocation approach to the compat vdso
removal approach?  It seems like Linus is okay with either one.

--Andy

>
> Otherwise, it seems the logical way forward.  Could you and/or Stefani
> work out the conflicts between the patchsets?
>
> In the meantime I'm going to apply Stefani's first patch.
>
>         -hpa
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
