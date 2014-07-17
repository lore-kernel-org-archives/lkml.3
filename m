Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757592AbaGQRMv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 13:12:51 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:51151 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757463AbaGQRMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 13:12:48 -0400
MIME-Version: 1.0
In-Reply-To: <53C7FC32.7030704@zytor.com>
References: <cover.1405546879.git.luto@amacapital.net> <5778e65d5ca52bebbaa023e177d863e44f098e96.1405546879.git.luto@amacapital.net>
 <53C6F5A9.80400@zytor.com> <CALCETrVwT1g-S1hLyyB_uAVwffYCnFacTfUhJeD8Bb5j3X0mkg@mail.gmail.com>
 <CALCETrVCrJEwYokasRoqQTKJWKtzq9XUMNqHoT4-ZjgyZ-mBow@mail.gmail.com>
 <53C703ED.2010605@zytor.com> <CALCETrVSG_Lp=OSw-U+QK+_VsEhKBS=rBQ3ojTrnO9kAKR+Qag@mail.gmail.com>
 <53C75733.8060507@zytor.com> <20140717103324.GJ1491@thunk.org> <53C7FC32.7030704@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 17 Jul 2014 10:12:27 -0700
Message-ID: <CALCETrVgCw2_8x1+NrP_xO4ZtnFm_dTTUBtZd-tgfdWgfeu2FQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/5] random,x86: Add arch_get_slow_rng_u64
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>, X86 ML <x86@kernel.org>,
        Bandan Das <bsd@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Daniel Borkmann <dborkman@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 9:39 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 07/17/2014 03:33 AM, Theodore Ts'o wrote:
>> On Wed, Jul 16, 2014 at 09:55:15PM -0700, H. Peter Anvin wrote:
>>> On 07/16/2014 05:03 PM, Andy Lutomirski wrote:
>>>>>
>>>> I meant that prandom isn't using rdrand for early seeding.
>>>>
>>>
>>> We should probably fix that.
>>
>> It wouldn't hurt to explicitly use arch_get_random_long() in prandom,
>> but it does use get_random_bytes() in early seed, and for CPU's with
>> RDRAND present, we do use it in init_std_data() in
>> drivers/char/random.c, so prandom is already getting initialized via
>> an RNG (which is effectively a DRBG even if it doesn't pass all of
>> NIST's rules) which is derived from RDRAND.
>>
>
> I assumed he was referring to before alternatives.  Not sure if we use
> prandom before that point, though.

Unless I'm reading the code wrong, the prandom_reseed_late call can
happen after userspace is running.

Anyway, I'm working on a near-complete rewrite of the guest part of all of this.

--Andy

>
>         -hpa
>
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
