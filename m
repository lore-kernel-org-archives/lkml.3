Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847AbaHMHtA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 03:49:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51532 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751784AbaHMHs7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 03:48:59 -0400
Message-ID: <53EB1859.6030800@zytor.com>
Date: Wed, 13 Aug 2014 00:48:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>, "Theodore Ts'o" <tytso@mit.edu>,
        kvm list <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>, X86 ML <x86@kernel.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Bandan Das <bsd@redhat.com>, Andrew Honig <ahonig@google.com>
Subject: Re: [PATCH v5 0/5] random,x86,kvm: Rework arch RNG seeds and get
 some from kvm
References: <cover.1406177531.git.luto@amacapital.net> <CALCETrXtLf3ZFtyrbwj29C=t3PcTxRT2AJWZCUHdKC3AYyUVAA@mail.gmail.com> <20140812191723.GI12871@thunk.org> <CALCETrVmviT=upxHfPfmLy2aUOKdCuCbNg9WZQcx6f=8T8vv=g@mail.gmail.com>
In-Reply-To: <CALCETrVmviT=upxHfPfmLy2aUOKdCuCbNg9WZQcx6f=8T8vv=g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2014 12:22 PM, Andy Lutomirski wrote:
> On Tue, Aug 12, 2014 at 12:17 PM, Theodore Ts'o <tytso@mit.edu> wrote:
>> On Tue, Aug 12, 2014 at 12:11:29PM -0700, Andy Lutomirski wrote:
>>>
>>> What's the status of this series?  I assume that it's too late for at
>>> least patches 2-5 to make it into 3.17.
>>
>> Which tree were you hoping this patch series to go through?  I was
>> assuming it would go through the x86 tree since the bulk of the
>> changes in the x86 subsystem (hence my Acked-by).
> 
> There's some argument that patch 1 should go through the kvm tree.
> There's no real need for patch 1 and 2-5 to end up in the same kernel
> release, either.
> 
>>
>> IIRC, Peter had some concerns, and I don't remember if they were all
>> addressed.  Peter?
>>
> 
> I don't know.  I rewrite one thing he didn't like and undid the other,
> but there's plenty of opportunity for this version to be problematic, too.
> 

Sorry, I have been heads down on the current merge window.  I will look
at this for 3.18, presumably after Kernel Summit.

The proposed arch_get_rng_seed() is not really what it claims to be; it
most definitely does not produce seed-grade randomness, instead it seems
to be an arch function for best-effort initialization of the entropy
pools -- which is fine, it is just something quite different.

I want to look over it more carefully before acking it, though.

Andy, are you going to be in Chicago?

	-hpa

