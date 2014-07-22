Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757038AbaGVVIX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 17:08:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60186 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756861AbaGVVIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 17:08:22 -0400
Message-ID: <53CED2B2.1040401@zytor.com>
Date: Tue, 22 Jul 2014 14:08:02 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: "Theodore Ts'o" <tytso@mit.edu>, kvm list <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>, X86 ML <x86@kernel.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Bandan Das <bsd@redhat.com>, Andrew Honig <ahonig@google.com>
Subject: Re: [PATCH v4 2/5] random: Add and use arch_get_rng_seed
References: <cover.1405620944.git.luto@amacapital.net> <9c2a0549519b4eb5eee2d5d480f8e83a574273df.1405620944.git.luto@amacapital.net> <20140722135915.GB25291@thunk.org> <CALCETrVY9KNLsbxhtLRatdb34ZP3XvMyys358dpB3oCKezdBwA@mail.gmail.com> <53CED031.9090907@zytor.com> <CALCETrV3FHinFXSWJsQjnsXM2H5OyuAbR3_1A401raLes6fNAg@mail.gmail.com>
In-Reply-To: <CALCETrV3FHinFXSWJsQjnsXM2H5OyuAbR3_1A401raLes6fNAg@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2014 02:04 PM, Andy Lutomirski wrote:
> 
> Just to check: do you mean the RDRAND is very likely to work (i.e.
> arch_get_random_long will return true) or that RDRAND will actually
> reseed several times during initialization?
> 

I mean that RDRAND will actually reseed several times during
initialization.  The documented architectural limit is actually
extremely conservative.

Either way, it isn't really different from seeding from a VM hosts
/dev/urandom...

	-hpa

