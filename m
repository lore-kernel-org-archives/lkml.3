Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932324AbaJ1Vkj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 17:40:39 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:57665 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754965AbaJ1Vkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 17:40:36 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFxVtxA-j7uwVCeB4asm4DB-gz4xnsygW8_s0OYfU8hXrw@mail.gmail.com>
References: <1414496662-25202-1-git-send-email-will.deacon@arm.com>
	<1414496662-25202-2-git-send-email-will.deacon@arm.com>
	<CA+55aFxVtxA-j7uwVCeB4asm4DB-gz4xnsygW8_s0OYfU8hXrw@mail.gmail.com>
Date: Tue, 28 Oct 2014 14:40:35 -0700
X-Google-Sender-Auth: lmbr8yUrW5sZgGTo_hAg14ONmWw
Message-ID: <CA+55aFwpOCeXdThX3zB64AU4hFwufD6UdJDi2tkD8Q7yEV2pOA@mail.gmail.com>
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

On Tue, Oct 28, 2014 at 8:30 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Tue, Oct 28, 2014 at 4:44 AM, Will Deacon <will.deacon@arm.com> wrote:
>>
>> This patch fixes the problem by incrementing addr by the PAGE_SIZE
>> before breaking out of the loop on batch failure.
>
> This patch seems harmless and right [..]

I've applied it (commit ce9ec37bddb6), and marked it for stable.

I think that bug has been around since at least commit 2b047252d087
("Fix TLB gather virtual address range invalidation corner cases")
which went into 3.11, but that has in turn then was also marked for
stable, so I'm not sure just how far back this fix needs to go. I
suspect the simple answer is "as far back as it applies" ;)

I'll wait and see what you'll do about the other patch.

                 Linus
