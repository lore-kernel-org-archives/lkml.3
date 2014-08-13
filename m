Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751714AbaHMIhZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 04:37:25 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:39987 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbaHMIhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 04:37:22 -0400
MIME-Version: 1.0
In-Reply-To: <53EB1859.6030800@zytor.com>
References: <cover.1406177531.git.luto@amacapital.net> <CALCETrXtLf3ZFtyrbwj29C=t3PcTxRT2AJWZCUHdKC3AYyUVAA@mail.gmail.com>
 <20140812191723.GI12871@thunk.org> <CALCETrVmviT=upxHfPfmLy2aUOKdCuCbNg9WZQcx6f=8T8vv=g@mail.gmail.com>
 <53EB1859.6030800@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 13 Aug 2014 01:37:01 -0700
Message-ID: <CALCETrVA3Eefbhfu_pO28fFPLCZvMBZHj=vpGifkUcBPa0Np1w@mail.gmail.com>
Subject: Re: [PATCH v5 0/5] random,x86,kvm: Rework arch RNG seeds and get some
 from kvm
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>, X86 ML <x86@kernel.org>,
        Bandan Das <bsd@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        kvm list <kvm@vger.kernel.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Daniel Borkmann <dborkman@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Honig <ahonig@google.com>, Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 13, 2014 12:48 AM, "H. Peter Anvin" <hpa@zytor.com> wrote:
>
> On 08/12/2014 12:22 PM, Andy Lutomirski wrote:
> > On Tue, Aug 12, 2014 at 12:17 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> >> On Tue, Aug 12, 2014 at 12:11:29PM -0700, Andy Lutomirski wrote:
> >>>
> >>> What's the status of this series?  I assume that it's too late for at
> >>> least patches 2-5 to make it into 3.17.
> >>
> >> Which tree were you hoping this patch series to go through?  I was
> >> assuming it would go through the x86 tree since the bulk of the
> >> changes in the x86 subsystem (hence my Acked-by).
> >
> > There's some argument that patch 1 should go through the kvm tree.
> > There's no real need for patch 1 and 2-5 to end up in the same kernel
> > release, either.
> >
> >>
> >> IIRC, Peter had some concerns, and I don't remember if they were all
> >> addressed.  Peter?
> >>
> >
> > I don't know.  I rewrite one thing he didn't like and undid the other,
> > but there's plenty of opportunity for this version to be problematic, too.
> >
>
> Sorry, I have been heads down on the current merge window.  I will look
> at this for 3.18, presumably after Kernel Summit.
>
> The proposed arch_get_rng_seed() is not really what it claims to be; it
> most definitely does not produce seed-grade randomness, instead it seems
> to be an arch function for best-effort initialization of the entropy
> pools -- which is fine, it is just something quite different.

Fair enough.  I meant "seed" as in something that initialized a PRNG
(think srand), not "seed" as in a
promised-to-be-cryptographically-secure seed for a DRBG.

I can rename it, update the comment, or otherwise tweak it to make the
intent clearer.

>
> I want to look over it more carefully before acking it, though.

It would also be nice for someone with a Haswell box (and an RDSEED
box) to test it.  I have neither.

>
> Andy, are you going to be in Chicago?

Yes.

>
>         -hpa
>
