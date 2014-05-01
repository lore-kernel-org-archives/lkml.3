Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180AbaEAUav (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 16:30:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40365 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751481AbaEAUat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 16:30:49 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <CALCETrX=0uA6CCg4UeeV8KgGAq6fxUSiGOw5Gzte4OSHrDWMqA@mail.gmail.com>
References: <CALCETrXMAWSC6B-irn4LeXFzB2tODqagsBboky=xnGv5ZTh-sg@mail.gmail.com> <20140501192618.GA25829@thunk.org> <CALCETrX=0uA6CCg4UeeV8KgGAq6fxUSiGOw5Gzte4OSHrDWMqA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: random: Providing a seed value to VM guests
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 01 May 2014 13:30:25 -0700
To: Andy Lutomirski <luto@amacapital.net>, "Ted Ts'o" <tytso@mit.edu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, Florian Weimer <fweimer@redhat.com>,
        Kees Cook <kees@outflux.net>
Message-ID: <900441a0-24e8-4976-ad35-3971805b9f34@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RDSEED is not synchronous.  It is, however, nonblocking.

On May 1, 2014 1:16:40 PM PDT, Andy Lutomirski <luto@amacapital.net> wrote:
>On May 1, 2014 12:26 PM, <tytso@mit.edu> wrote:
>>
>> On Thu, May 01, 2014 at 12:02:49PM -0700, Andy Lutomirski wrote:
>> >
>> > Is RDSEED really reasonable here?  Won't it slow down by several
>> > orders of magnitude?
>>
>> That is I think the biggest problem; RDRAND and RDSEED are fast if
>> they are native, but they will involve a VM exit if they need to be
>> emulated.  So when an OS might want to use RDRAND and RDSEED might be
>> quite different if we know they are being emulated.
>>
>> Using the RDRAND and RDSEED "api" certainly makes sense, at least for
>> x86, but I suspect we might want to use a different way of signalling
>> that a VM guest can use RDRAND and RDSEED if they are running on a
>CPU
>> which doesn't provide that kind of access.  Maybe a CPUID extended
>> function parameter, if one could be allocated for use by a Linux
>> hypervisor?
>>
>
>I'm still not convinced.  This will affect userspace as well as the
>guest kernel, and I don't see why guest user code should be able to
>access this API.  RDRAND for CPL0 only would work, but that seems odd.
>
>And I think that RDSEED emulation is asking for trouble.  RDSEED is
>synchronous, but /dev/random is asynchronous.  And making bootup wait
>for even a single byte from /dev/random seems bad.  In any event,
>virtio-rng should be a better interface for this.
>
>>                                                 - Ted
>>

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
