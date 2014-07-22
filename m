Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932210AbaGVVLE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 17:11:04 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:50986 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932128AbaGVVLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 17:11:02 -0400
MIME-Version: 1.0
In-Reply-To: <53CED2B2.1040401@zytor.com>
References: <cover.1405620944.git.luto@amacapital.net> <9c2a0549519b4eb5eee2d5d480f8e83a574273df.1405620944.git.luto@amacapital.net>
 <20140722135915.GB25291@thunk.org> <CALCETrVY9KNLsbxhtLRatdb34ZP3XvMyys358dpB3oCKezdBwA@mail.gmail.com>
 <53CED031.9090907@zytor.com> <CALCETrV3FHinFXSWJsQjnsXM2H5OyuAbR3_1A401raLes6fNAg@mail.gmail.com>
 <53CED2B2.1040401@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 22 Jul 2014 14:10:40 -0700
Message-ID: <CALCETrWiaHCjexw9T8CL=ey06fFKLGArVqmPJ=81WSD6Y25ePg@mail.gmail.com>
Subject: Re: [PATCH v4 2/5] random: Add and use arch_get_rng_seed
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, kvm list <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>, X86 ML <x86@kernel.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Bandan Das <bsd@redhat.com>, Andrew Honig <ahonig@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 2:08 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 07/22/2014 02:04 PM, Andy Lutomirski wrote:
>>
>> Just to check: do you mean the RDRAND is very likely to work (i.e.
>> arch_get_random_long will return true) or that RDRAND will actually
>> reseed several times during initialization?
>>
>
> I mean that RDRAND will actually reseed several times during
> initialization.  The documented architectural limit is actually
> extremely conservative.
>
> Either way, it isn't really different from seeding from a VM hosts
> /dev/urandom...
>

Sure it is.  The VM host's /dev/urandom makes no guarantee (or AFAIK
even any particular effort) to reseed such that the output has some
minimum entropy per bit, so there would be no point to reading extra
data from it.

Anyway, I'd be willing to drop the conservative RDRAND logic, but I
*still* think that arch_get_rng_seed is a much better interface than
arch_get_slow_rng_u64.

--Andy
