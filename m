Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400AbaEAXAx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 19:00:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41658 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014AbaEAXAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 19:00:51 -0400
Message-ID: <5362D20F.6010401@zytor.com>
Date: Thu, 01 May 2014 16:00:31 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: "Theodore Ts'o" <tytso@mit.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, Florian Weimer <fweimer@redhat.com>,
        Kees Cook <kees@outflux.net>
Subject: Re: random: Providing a seed value to VM guests
References: <CALCETrXMAWSC6B-irn4LeXFzB2tODqagsBboky=xnGv5ZTh-sg@mail.gmail.com> <20140501192618.GA25829@thunk.org> <CALCETrX=0uA6CCg4UeeV8KgGAq6fxUSiGOw5Gzte4OSHrDWMqA@mail.gmail.com> <900441a0-24e8-4976-ad35-3971805b9f34@email.android.com> <CALCETrV1HUA-JRAj9UicD3woqec7mSJLoT9CkQq=dOCpdPg4hw@mail.gmail.com> <20140501203910.GB25829@thunk.org> <CALCETrUr7NXkkN27v2Uf-puEtSXbgp=E+99aC_SdTc6puR8+CA@mail.gmail.com> <5362B618.50602@zytor.com> <CALCETrXu_bFjemS3TZNDDes=cBgkUXtDH-6cA84JcNjD0AdZ7A@mail.gmail.com> <20140501222832.GD25829@thunk.org> <CALCETrUe_pFgn27HP4JQ7XpUVJJJoj1PXU5PnznRCEY7mCaaWg@mail.gmail.com> <5362CEBC.9090705@zytor.com> <CALCETrUqOb6EnyWq15Q-1CXec53rDorR2Ka+nF--iugMUzWCOA@mail.gmail.com>
In-Reply-To: <CALCETrUqOb6EnyWq15Q-1CXec53rDorR2Ka+nF--iugMUzWCOA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2014 03:56 PM, Andy Lutomirski wrote:
> 
> I think we're comparing:
> 
> a) cpuid to detect rdrand *or* emulated rdrand followed by rdrand
> 
> to
> 
> b) cpuid to detect rdrand or the paravirt seed msr/cpuid call,
> followed by rdrand or the msr or cpuid read
> 
> this seems like it barely makes a difference, especially since (a)
> probably requires detecting KVM anyway.

Well, it lets one do something like:

	if (boot_cpu_has(X86_FEATURE_RDRAND) ||
            boot_cpu_has(X86_FEATURE_RDRAND_SIMULATED))
		rdrand_long(...);

We need the ifs anyway for early code; the arch_*() interfaces are only
available after alternatives run.

	-hpa

