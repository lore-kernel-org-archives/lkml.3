Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751539AbaEATDM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 15:03:12 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:34873 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbaEATDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 15:03:10 -0400
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 1 May 2014 12:02:49 -0700
Message-ID: <CALCETrXMAWSC6B-irn4LeXFzB2tODqagsBboky=xnGv5ZTh-sg@mail.gmail.com>
Subject: Re: random: Providing a seed value to VM guests
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Florian Weimer <fweimer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kees Cook <kees@outflux.net>, kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 1, 2014 at 11:59 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 05/01/2014 11:53 AM, Andy Lutomirski wrote:
>>
>> A CPUID leaf or an MSR advertised by a CPUID leaf has another
>> advantage: it's easy to use in the ASLR code -- I don't think there's
>> a real IDT, so there's nothing like rdmsr_safe available.  It also
>> avoids doing anything complicated with the boot process to allow the
>> same seed to be used for ASLR and random.c; it can just be invoked
>> twice on boot.
>>
>
> At that point we are talking an x86-specific interface, and so we might
> as well simply emulate RDRAND (urandom) and RDSEED (random) if the CPU
> doesn't support them.  I believe KVM already has a way to report CPUID
> features that are "emulated but supported anyway", i.e. they work but
> are slow.

Do existing kernels and userspace respect this?  If the normal bit for
RDRAND is unset, then we might be okay, but, if not, then I think this
may kill guest performance.

Is RDSEED really reasonable here?  Won't it slow down by several
orders of magnitude?

>
>> What's the right forum for this?  This thread is probably not it.
>
> Change the subject line?

:)

>
>         -hpa
>
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
