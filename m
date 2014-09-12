Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795AbaILVTc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 17:19:32 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:51490 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337AbaILVT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 17:19:29 -0400
MIME-Version: 1.0
In-Reply-To: <20140912141429.17d570d1a7e1cb99ec73f0f7@linux-foundation.org>
References: <1410553043-575-1-git-send-email-ard.biesheuvel@linaro.org>
	<20140912141429.17d570d1a7e1cb99ec73f0f7@linux-foundation.org>
Date: Fri, 12 Sep 2014 23:19:27 +0200
Message-ID: <CAKv+Gu8=9tVmKtp5s_SyXF7mGjZ7r9x4iBYnyYfNpBogA9ShVg@mail.gmail.com>
Subject: Re: [PATCH] mm: export symbol dependencies of is_zero_pfn()
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com,
        Christoffer Dall <christoffer.dall@linaro.org>, linux-mm@kvack.org,
        linux-s390@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mips@linux-mips.org, ralf@linux-mips.org, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 September 2014 23:14, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Fri, 12 Sep 2014 22:17:23 +0200 Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
>> In order to make the static inline function is_zero_pfn() callable by
>> modules, export its symbol dependencies 'zero_pfn' and (for s390 and
>> mips) 'zero_page_mask'.
>
> So hexagon and score get the export if/when needed.
>

Exactly.

>> We need this for KVM, as CONFIG_KVM is a tristate for all supported
>> architectures except ARM and arm64, and testing a pfn whether it refers
>> to the zero page is required to correctly distinguish the zero page
>> from other special RAM ranges that may also have the PG_reserved bit
>> set, but need to be treated as MMIO memory.
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> ---
>>  arch/mips/mm/init.c | 1 +
>>  arch/s390/mm/init.c | 1 +
>>  mm/memory.c         | 2 ++
>
> Looks OK to me.  Please include the patch in whichever tree is is that
> needs it, and merge it up via that tree.
>

Thanks.

@Paolo: could you please take this (with Andrew's ack), and put it
before the patch you took earlier today?

Thanks,
Ard.
