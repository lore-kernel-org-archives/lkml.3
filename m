Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677Ab3GTRRB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 13:17:01 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:62309 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754470Ab3GTRRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 13:17:00 -0400
MIME-Version: 1.0
In-Reply-To: <20130719145729.840eeae88fad89d2c6915163@linux-foundation.org>
References: <1374166572-7988-1-git-send-email-uulinux@gmail.com>
	<20130718143928.4f9b45807956e2fdb1ee3a22@linux-foundation.org>
	<CAAV+Mu7A5H_T2EroUDWaCSOs1j5_Z6hRNyzrwU2N1WPAOZ=JDw@mail.gmail.com>
	<20130719145729.840eeae88fad89d2c6915163@linux-foundation.org>
Date: Sun, 21 Jul 2013 01:16:59 +0800
Message-ID: <CAAV+Mu6ehgowpGun81Ooips2Gt=GwpygOiC5wbFk=P7axhom4Q@mail.gmail.com>
Subject: Re: [PATCH] mm: negative left shift count when PAGE_SHIFT > 20
From: Jerry <uulinux@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: zhuwei.lu@archermind.com, tianfu.huang@archermind.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/7/20 Andrew Morton <akpm@linux-foundation.org>:
> On Fri, 19 Jul 2013 07:47:02 +0800 Jerry <uulinux@gmail.com> wrote:
>
>> 2013/7/19 Andrew Morton <akpm@linux-foundation.org>:
>> > On Fri, 19 Jul 2013 00:56:12 +0800 Jerry <uulinux@gmail.com> wrote:
>> >
>> >> When PAGE_SHIFT > 20, the result of "20 - PAGE_SHIFT" is negative. The
>> >> calculating here will generate an unexpected result. In addition, if
>> >> PAGE_SHIFT > 20, The memory size represented by numentries was already
>> >> integral multiple of 1MB.
>> >>
>> >
>> > If you tell me that you have a machine which has PAGE_SIZE=2MB and this
>> > was the only problem which prevented Linux from running on that machine
>> > then I'll apply the patch ;)
>> >
>>
>> Hi Morton:
>> I just "grep -rn "#define\s\+PAGE_SHIFT" arch/", and find the
>> PAGE_SHIFT in some architecture is very big.
>> such as the following in "arch/hexagon/include/asm/page.h"
>> ....
>> #ifdef CONFIG_PAGE_SIZE_256KB
>> #define PAGE_SHIFT 18
>> #define HEXAGON_L1_PTE_SIZE __HVM_PDE_S_256KB
>> #endif
>>
>> #ifdef CONFIG_PAGE_SIZE_1MB
>> #define PAGE_SHIFT 20
>> #define HEXAGON_L1_PTE_SIZE __HVM_PDE_S_1MB
>> #endif
>> .....
>
> Good heavens.
>
>> In my patch, I think compiler would optimize "if (20 > PAGE_SIZE)", it
>> won't generate any machine instruction. Just a guarantee.
>
> Well the existing code is a bit silly looking.  Why can't we just do
>
>         /* round applicable memory size up to nearest megabyte */
>         if (PAGE_SHIFT < 20)
>                 numentries = round_up(nr_kernel_pages, (1 << 20)/PAGE_SIZE);
>
> or similar?

Great. I have adjusted these code lines, and sent the latest one.

--
I love linux!!!
