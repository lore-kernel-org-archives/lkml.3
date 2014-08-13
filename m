Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509AbaHMQOH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 12:14:07 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:38031 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175AbaHMQOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 12:14:05 -0400
MIME-Version: 1.0
In-Reply-To: <20140813143209.GD6437@thunk.org>
References: <cover.1406177531.git.luto@amacapital.net> <CALCETrXtLf3ZFtyrbwj29C=t3PcTxRT2AJWZCUHdKC3AYyUVAA@mail.gmail.com>
 <20140812191723.GI12871@thunk.org> <CALCETrVmviT=upxHfPfmLy2aUOKdCuCbNg9WZQcx6f=8T8vv=g@mail.gmail.com>
 <53EB1859.6030800@zytor.com> <20140813143209.GD6437@thunk.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 13 Aug 2014 09:13:42 -0700
Message-ID: <CALCETrUQ8yRmmN1kbdCy99ae2+-Xp4caOBgrXvaQhCCUi=i0zg@mail.gmail.com>
Subject: Re: [PATCH v5 0/5] random,x86,kvm: Rework arch RNG seeds and get some
 from kvm
To: "Theodore Ts'o" <tytso@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@amacapital.net>, kvm list <kvm@vger.kernel.org>,
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

On Wed, Aug 13, 2014 at 7:32 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Wed, Aug 13, 2014 at 12:48:41AM -0700, H. Peter Anvin wrote:
>> The proposed arch_get_rng_seed() is not really what it claims to be; it
>> most definitely does not produce seed-grade randomness, instead it seems
>> to be an arch function for best-effort initialization of the entropy
>> pools -- which is fine, it is just something quite different.
>
> Without getting into an argument about which definition of "seed" is
> correct --- it's certainly confusing and different form the RDSEED
> usage of the word "seed".
>
> Do we expect that anyone else besides arch_get_rnd_seed() would
> actually want to use it?

If you mean random.c instead of arch_get_rnd_seed, then I don't expect
there to be other users.  Aside from the "best-effort" bit causing
this to be basically useless on old bare metal, the interface is
really awkward for anything other than the use in random.c.

> I'd argue no; we want the rest of the kernel
> to either use get_random_bytes() or prandom_u32().  Given that, maybe
> we should just call it arch_random_init(), and expect that the only
> user of this interface would be drivers/char/random.c?

Sounds good to me.

FWIW, I'd like to see a second use added in random.c: I think that we
should do this, or even all of init_std_data, on resume from suspend
and especially on resume from hibernate / kexec.

--Andy
