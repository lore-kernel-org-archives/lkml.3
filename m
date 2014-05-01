Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854AbaEATqM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 15:46:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39948 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbaEATqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 15:46:10 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <CALCETrXMAWSC6B-irn4LeXFzB2tODqagsBboky=xnGv5ZTh-sg@mail.gmail.com>
References: <CALCETrXMAWSC6B-irn4LeXFzB2tODqagsBboky=xnGv5ZTh-sg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: random: Providing a seed value to VM guests
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 01 May 2014 12:41:48 -0700
To: Andy Lutomirski <luto@amacapital.net>
CC: "Theodore Ts'o" <tytso@mit.edu>, Florian Weimer <fweimer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kees Cook <kees@outflux.net>, kvm list <kvm@vger.kernel.org>
Message-ID: <04a358c7-f692-45f7-a9aa-29c587771c10@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The normal CPUID bit is unset I believe.

On May 1, 2014 12:02:49 PM PDT, Andy Lutomirski <luto@amacapital.net> wrote:
>On Thu, May 1, 2014 at 11:59 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 05/01/2014 11:53 AM, Andy Lutomirski wrote:
>>>
>>> A CPUID leaf or an MSR advertised by a CPUID leaf has another
>>> advantage: it's easy to use in the ASLR code -- I don't think
>there's
>>> a real IDT, so there's nothing like rdmsr_safe available.  It also
>>> avoids doing anything complicated with the boot process to allow the
>>> same seed to be used for ASLR and random.c; it can just be invoked
>>> twice on boot.
>>>
>>
>> At that point we are talking an x86-specific interface, and so we
>might
>> as well simply emulate RDRAND (urandom) and RDSEED (random) if the
>CPU
>> doesn't support them.  I believe KVM already has a way to report
>CPUID
>> features that are "emulated but supported anyway", i.e. they work but
>> are slow.
>
>Do existing kernels and userspace respect this?  If the normal bit for
>RDRAND is unset, then we might be okay, but, if not, then I think this
>may kill guest performance.
>
>Is RDSEED really reasonable here?  Won't it slow down by several
>orders of magnitude?
>
>>
>>> What's the right forum for this?  This thread is probably not it.
>>
>> Change the subject line?
>
>:)
>
>>
>>         -hpa
>>
>>

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
