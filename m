Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957AbaJ1SDz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 14:03:55 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:54487 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbaJ1SDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 14:03:54 -0400
MIME-Version: 1.0
In-Reply-To: <20141028170715.GJ29706@arm.com>
References: <1414496662-25202-1-git-send-email-will.deacon@arm.com>
	<1414496662-25202-2-git-send-email-will.deacon@arm.com>
	<CA+55aFxVtxA-j7uwVCeB4asm4DB-gz4xnsygW8_s0OYfU8hXrw@mail.gmail.com>
	<20141028160729.GH29706@arm.com>
	<CA+55aFxvz=guax4KcAszyjkqdqXGwV38O+G23xMvGFJDTrZqtg@mail.gmail.com>
	<20141028170715.GJ29706@arm.com>
Date: Tue, 28 Oct 2014 11:03:53 -0700
X-Google-Sender-Auth: vhjPqoPmWuVCOzw6yB8mZyWORFU
Message-ID: <CA+55aFwNALj9=R-V7cMK3_dT8TP_aGjFQiswSk8yegD_dzj9Wg@mail.gmail.com>
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

On Tue, Oct 28, 2014 at 10:07 AM, Will Deacon <will.deacon@arm.com> wrote:
>
> I don't think that's necessarily true, at least not on the systems I'm
> familiar with. A table walk can be comparatively expensive, particularly
> when virtualisation is involved and the depth of the host and guest page
> tables starts to grow -- we're talking >20 memory accesses per walk. By
> contrast, the TLB invalidation messages are asynchronous and carried on
> the interconnect (a DSB instruction is used to synchronise the updates).

">20 memory accesses per *walk*"? Isn't the ARM a regular table? So
once you've gone down to the pte level, it's just an array, regardless
of how many levels there are.

But I guess there are no actual multi-socket ARM's around in real
life, so you probably don't see the real scaling costs. Within a die,
you're probably right that the overhead is negligible.

                   Linus
