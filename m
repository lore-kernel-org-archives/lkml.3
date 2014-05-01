Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517AbaEAWcZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 18:32:25 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:38304 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447AbaEAWcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 18:32:23 -0400
MIME-Version: 1.0
In-Reply-To: <20140501222832.GD25829@thunk.org>
References: <CALCETrXMAWSC6B-irn4LeXFzB2tODqagsBboky=xnGv5ZTh-sg@mail.gmail.com>
 <20140501192618.GA25829@thunk.org> <CALCETrX=0uA6CCg4UeeV8KgGAq6fxUSiGOw5Gzte4OSHrDWMqA@mail.gmail.com>
 <900441a0-24e8-4976-ad35-3971805b9f34@email.android.com> <CALCETrV1HUA-JRAj9UicD3woqec7mSJLoT9CkQq=dOCpdPg4hw@mail.gmail.com>
 <20140501203910.GB25829@thunk.org> <CALCETrUr7NXkkN27v2Uf-puEtSXbgp=E+99aC_SdTc6puR8+CA@mail.gmail.com>
 <5362B618.50602@zytor.com> <CALCETrXu_bFjemS3TZNDDes=cBgkUXtDH-6cA84JcNjD0AdZ7A@mail.gmail.com>
 <20140501222832.GD25829@thunk.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 1 May 2014 15:32:02 -0700
Message-ID: <CALCETrUe_pFgn27HP4JQ7XpUVJJJoj1PXU5PnznRCEY7mCaaWg@mail.gmail.com>
Subject: Re: random: Providing a seed value to VM guests
To: "Theodore Ts'o" <tytso@mit.edu>, Andy Lutomirski <luto@amacapital.net>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, Florian Weimer <fweimer@redhat.com>,
        Kees Cook <kees@outflux.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 1, 2014 at 3:28 PM,  <tytso@mit.edu> wrote:
> On Thu, May 01, 2014 at 02:06:13PM -0700, Andy Lutomirski wrote:
>>
>> I still don't see the point.  What does this do better than virtio-rng?
>
> I believe you had been complaining about how complicated it was to set
> up virtio?  And this complexity is also an issue if we want to use it
> to initialize the RNG used for the kernel text ASLR --- which has to
> be done very early in the boot process, and where making something as
> simple as possible is a Good Thing.

It's complicated, so it won't be up until much later in the boot
process.  This is completely fine for /dev/random, but it's a problem
for /dev/urandom, ASLR, and such.

>
> And since we would want to use RDRAND/RDSEED if it is available
> *anyway*, perhaps in combination with other things, why not use the
> RDRAND/RDSEED interface?

Because it's awkward.  I don't think it simplifies anything.

--Andy
