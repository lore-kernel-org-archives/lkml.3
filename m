Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660AbaDASxo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 14:53:44 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:62761 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbaDASxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 14:53:25 -0400
MIME-Version: 1.0
In-Reply-To: <1396373557-3387-4-git-send-email-andi@firstfloor.org>
References: <1396373557-3387-1-git-send-email-andi@firstfloor.org>
	<1396373557-3387-4-git-send-email-andi@firstfloor.org>
Date: Tue, 1 Apr 2014 11:53:23 -0700
X-Google-Sender-Auth: -DWVvCCJxxRSWOX1IN9aTRBTLck
Message-ID: <CA+55aFwUOe9twEU2F7K5PcDRPk-eS+B9CN=P327bhCYH9Ew=fg@mail.gmail.com>
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

On Tue, Apr 1, 2014 at 10:32 AM, Andi Kleen <andi@firstfloor.org> wrote:
>
> -asmlinkage void aes_enc_blk(struct crypto_aes_ctx *ctx, u8 *out, const u8 *in);
> -asmlinkage void aes_dec_blk(struct crypto_aes_ctx *ctx, u8 *out, const u8 *in);
> +asmlinkage __visible void aes_enc_blk(struct crypto_aes_ctx *ctx, u8 *out, const u8 *in);
> +asmlinkage __visible void aes_dec_blk(struct crypto_aes_ctx *ctx, u8 *out, const u8 *in);

This seems to be more of the same "__visible in declaration" badness.

Don't do it.

As far as I can tell, the only point of "__visible" is on C symbols
called from assembly language.

You're adding them to assembly routines called from C, which is
exactly the wrong way around, and pointless. And it's worse than
pointless churn, it just confuses people, and shows that you are
confused about the meaning of it.

Again, it seems to be because you've mentally tied "asmlinkage"
together with "__visible", but they are totally disjoint. One is about
calling conventions, the other is about the C compiler not hiding the
function when using -fwhole-program.

STOP CONFUSING THE TWO. They are independent and have absolutely
*NOTHING* to do with each other.

             Linus
