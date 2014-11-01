Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759335AbaKARBf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 13:01:35 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:34581 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758317AbaKARBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 13:01:31 -0400
MIME-Version: 1.0
In-Reply-To: <1414618065.4257.21.camel@pasglop>
References: <1414496662-25202-1-git-send-email-will.deacon@arm.com>
	<1414496662-25202-2-git-send-email-will.deacon@arm.com>
	<CA+55aFxVtxA-j7uwVCeB4asm4DB-gz4xnsygW8_s0OYfU8hXrw@mail.gmail.com>
	<CA+55aFwpOCeXdThX3zB64AU4hFwufD6UdJDi2tkD8Q7yEV2pOA@mail.gmail.com>
	<20141029194738.GA29911@arm.com>
	<CA+55aFxoQSm5ko8bQxPd8usXxaZy_RgGpv36PTiEzYaWcOiwTA@mail.gmail.com>
	<1414618065.4257.21.camel@pasglop>
Date: Sat, 1 Nov 2014 10:01:30 -0700
X-Google-Sender-Auth: -RQlnCu4mBM55PcCIOLzKGBXnGk
Message-ID: <CA+55aFwZDQgfjMuftKF0TeMwV-uU=4SgJNfH+u4MyQ_UgfiFEg@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] zap_pte_range: update addr when forcing flush
 after TLB batching faiure
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Will Deacon <will.deacon@arm.com>, Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 2:27 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
>
> TLB flushing is only me I think, I'll engage my brain after breakfast
> and see if is all good

Ping? Breakfast is either long over, of you're starting to look a bit
like Mr Creosote...

Anyway, Will, I assume this is not a correctness issue for you, just
an annoying performance issue. Right? Or is there actually some issue
with the actual range not being set to be sufficiently large?

Also, it strikes me that I *think* that you might be able to extend
your patch to remove the whole "need_flush" field, since as far as I
can tell, "tlb->need_flush" is now equivalent to "tlb->start <
tlb->end". Of course, as long as we still require that
"need_flush_all", that doesn't actually save us any space, so maybe
it's not worth changing.

                       Linus
