Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781AbaEAWqp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 18:46:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41526 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752512AbaEAWqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 18:46:43 -0400
Message-ID: <5362CEBC.9090705@zytor.com>
Date: Thu, 01 May 2014 15:46:20 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>, "Theodore Ts'o" <tytso@mit.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, Florian Weimer <fweimer@redhat.com>,
        Kees Cook <kees@outflux.net>
Subject: Re: random: Providing a seed value to VM guests
References: <CALCETrXMAWSC6B-irn4LeXFzB2tODqagsBboky=xnGv5ZTh-sg@mail.gmail.com> <20140501192618.GA25829@thunk.org> <CALCETrX=0uA6CCg4UeeV8KgGAq6fxUSiGOw5Gzte4OSHrDWMqA@mail.gmail.com> <900441a0-24e8-4976-ad35-3971805b9f34@email.android.com> <CALCETrV1HUA-JRAj9UicD3woqec7mSJLoT9CkQq=dOCpdPg4hw@mail.gmail.com> <20140501203910.GB25829@thunk.org> <CALCETrUr7NXkkN27v2Uf-puEtSXbgp=E+99aC_SdTc6puR8+CA@mail.gmail.com> <5362B618.50602@zytor.com> <CALCETrXu_bFjemS3TZNDDes=cBgkUXtDH-6cA84JcNjD0AdZ7A@mail.gmail.com> <20140501222832.GD25829@thunk.org> <CALCETrUe_pFgn27HP4JQ7XpUVJJJoj1PXU5PnznRCEY7mCaaWg@mail.gmail.com>
In-Reply-To: <CALCETrUe_pFgn27HP4JQ7XpUVJJJoj1PXU5PnznRCEY7mCaaWg@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2014 03:32 PM, Andy Lutomirski wrote:
> On Thu, May 1, 2014 at 3:28 PM,  <tytso@mit.edu> wrote:
>> On Thu, May 01, 2014 at 02:06:13PM -0700, Andy Lutomirski wrote:
>>>
>>> I still don't see the point.  What does this do better than virtio-rng?
>>
>> I believe you had been complaining about how complicated it was to set
>> up virtio?  And this complexity is also an issue if we want to use it
>> to initialize the RNG used for the kernel text ASLR --- which has to
>> be done very early in the boot process, and where making something as
>> simple as possible is a Good Thing.
> 
> It's complicated, so it won't be up until much later in the boot
> process.  This is completely fine for /dev/random, but it's a problem
> for /dev/urandom, ASLR, and such.
> 
>>
>> And since we would want to use RDRAND/RDSEED if it is available
>> *anyway*, perhaps in combination with other things, why not use the
>> RDRAND/RDSEED interface?
> 
> Because it's awkward.  I don't think it simplifies anything.
> 

It greatly simplifies discovery, which is a Big Deal[TM] in early code.

	-hpa


