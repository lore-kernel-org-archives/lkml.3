Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316AbaJ2VMA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 17:12:00 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:49145 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757256AbaJ2VL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 17:11:56 -0400
MIME-Version: 1.0
In-Reply-To: <20141029194738.GA29911@arm.com>
References: <1414496662-25202-1-git-send-email-will.deacon@arm.com>
	<1414496662-25202-2-git-send-email-will.deacon@arm.com>
	<CA+55aFxVtxA-j7uwVCeB4asm4DB-gz4xnsygW8_s0OYfU8hXrw@mail.gmail.com>
	<CA+55aFwpOCeXdThX3zB64AU4hFwufD6UdJDi2tkD8Q7yEV2pOA@mail.gmail.com>
	<20141029194738.GA29911@arm.com>
Date: Wed, 29 Oct 2014 14:11:56 -0700
X-Google-Sender-Auth: I8RVwmGgv-hhdTMzrYQBCo-6h1M
Message-ID: <CA+55aFxoQSm5ko8bQxPd8usXxaZy_RgGpv36PTiEzYaWcOiwTA@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] zap_pte_range: update addr when forcing flush
 after TLB batching faiure
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 12:47 PM, Will Deacon <will.deacon@arm.com> wrote:
>
> I've cooked up something (see below), but it unfortunately makes a couple
> of minor changes to powerpc and microblaze to address redefinitions of
> some of the gather callbacks (tlb{start,end}vma, __tlb_remove_tlb_entry).
>
> On the plus side, it tidies up the force_flush case in zap_pte_range
> quite nicely (assuming I didn't screw it up again).

Yes, this looks fine to me. Looks like a good cleanup, and moves more
code to generic headers rather than having arch-specific stuff.

Ben, can you check that this is ok on powerpc? Who else should
double-check this due to having been involved in tlb flushing? But I
think this is good to go, modulo checking other architectures for
sanity.

                    Linus
