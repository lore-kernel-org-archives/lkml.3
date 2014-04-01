Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762AbaDATJ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 15:09:29 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:55191 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbaDATJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 15:09:26 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwUOe9twEU2F7K5PcDRPk-eS+B9CN=P327bhCYH9Ew=fg@mail.gmail.com>
References: <1396373557-3387-1-git-send-email-andi@firstfloor.org>
	<1396373557-3387-4-git-send-email-andi@firstfloor.org>
	<CA+55aFwUOe9twEU2F7K5PcDRPk-eS+B9CN=P327bhCYH9Ew=fg@mail.gmail.com>
Date: Tue, 1 Apr 2014 12:09:24 -0700
X-Google-Sender-Auth: -8PmlSS9tBDVzLsvHs42Lehiu3o
Message-ID: <CA+55aFyVD5MEt2-sKg8roFJymT1gHHadqq=+q1GBje=mObQhXg@mail.gmail.com>
Subject: Re: [PATCH 3/4] asmlinkage, x86: Add explicit __visible to arch/x86/crypto/*
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 1, 2014 at 11:53 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> You're adding them to assembly routines called from C, which is
> exactly the wrong way around, and pointless. And it's worse than
> pointless churn, it just confuses people, and shows that you are
> confused about the meaning of it.

Basically, all these grep's should return the empty set:

   git grep static.*__visible
   git grep extern.*__visible
   git grep "__visible.*(.*);"

because they are all signs of confusion. A 'static' variable
(declaration _or_ definition) should never be externally visible (as a
definition it might be called from inline asm, I guess, but then it
should be done as an argument so that the compiler sees the use). An
extern declaration can never sanely be marked "__visible", because the
only use of such a declaration is for C code (which by definition
doesn't need it). And the last case is for a function declaration,
which have an implicit extern.

And yeah, we do have a few confused users already (28, to be exact).
They should be fixed. But more importantly, we certainly shouldn't be
adding more of them.

                    Linus
