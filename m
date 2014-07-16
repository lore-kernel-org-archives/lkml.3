Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484AbaGPXAc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 19:00:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46782 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752657AbaGPXAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 19:00:30 -0400
Message-ID: <53C703ED.2010605@zytor.com>
Date: Wed, 16 Jul 2014 15:59:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: kvm list <kvm@vger.kernel.org>, "Theodore Ts'o" <tytso@mit.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>, X86 ML <x86@kernel.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Bandan Das <bsd@redhat.com>
Subject: Re: [PATCH v3 2/5] random,x86: Add arch_get_slow_rng_u64
References: <cover.1405546879.git.luto@amacapital.net> <5778e65d5ca52bebbaa023e177d863e44f098e96.1405546879.git.luto@amacapital.net> <53C6F5A9.80400@zytor.com> <CALCETrVwT1g-S1hLyyB_uAVwffYCnFacTfUhJeD8Bb5j3X0mkg@mail.gmail.com> <CALCETrVCrJEwYokasRoqQTKJWKtzq9XUMNqHoT4-ZjgyZ-mBow@mail.gmail.com>
In-Reply-To: <CALCETrVCrJEwYokasRoqQTKJWKtzq9XUMNqHoT4-ZjgyZ-mBow@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2014 03:40 PM, Andy Lutomirski wrote:
> On Wed, Jul 16, 2014 at 3:13 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>> My personal preference is to defer this until some user shows up.  I
>> think that even this would be too complicated for KASLR, which is the
>> only extremely early-boot user that I found.
>>
>> Hmm.  Does the prandom stuff want to use this?
> 
> prandom isn't even using rdrand.  I'd suggest fixing this separately,
> or even just waiting until someone goes and deletes prandom.
> 

prandom is exactly the opposite; it is designed for when we need
possibly low quality random numbers very quickly.  RDRAND is actually
too slow.

	-hpa


