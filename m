Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522Ab3HOIFO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 04:05:14 -0400
Received: from mail.active-venture.com ([67.228.131.205]:60816 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179Ab3HOIFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 04:05:05 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <520C8BB0.8030500@roeck-us.net>
Date: Thu, 15 Aug 2013 01:05:04 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>
Subject: Re: [ 00/17] 3.4.58-stable review
References: <20130813063501.728847844@linuxfoundation.org> <520A1D56.2050507@roeck-us.net> <20130813175858.GC7336@kroah.com> <20130813201936.GA18358@roeck-us.net> <20130815063158.GB25754@kroah.com> <520C86BD.2020903@roeck-us.net> <CAMuHMdU+EOC_etihOzUC6N0cqc2qHaGm3_L+gyTRxESCGhOzEg@mail.gmail.com>
In-Reply-To: <CAMuHMdU+EOC_etihOzUC6N0cqc2qHaGm3_L+gyTRxESCGhOzEg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2013 12:55 AM, Geert Uytterhoeven wrote:
> On Thu, Aug 15, 2013 at 9:43 AM, Guenter Roeck <linux@roeck-us.net> wrote:
>> I screwed up my stable repo clone again :(, so the full build will take a
>> bit.
>>
>> mips builds on on 3.4 with all patches applied now fail with:
>> arch/mips/include/asm/page.h: Assembler messages:
>> arch/mips/include/asm/page.h:178: Error: Unrecognized opcode `static inline
>> int pfn_valid(unsigned long pfn)'
>> arch/mips/include/asm/page.h:179: Error: junk at end of line, first
>> unrecognized character is `{'
>> arch/mips/include/asm/page.h:181: Error: Unrecognized opcode `extern
>> unsigned long max_mapnr'
>> arch/mips/include/asm/page.h:183: Error: Unrecognized opcode `return
>> pfn>=ARCH_PFN_OFFSET&&pfn<max_mapnr'
>> arch/mips/include/asm/page.h:184: Error: junk at end of line, first
>> unrecognized character is `}'
>>
>> This is the error I referred to above. Reverting above pfn rework patch
>> fixes that problem,
>> so you might want to remove that patch from the patch queue for now.
>
> Perhaps this one got applied too soon?
>
>   commit 730b8dfe016dd1e91f73d8d3e6724da91397171c
> Author: Ralf Baechle <ralf@linux-mips.org>
> Date:   Fri Dec 28 15:18:02 2012 +0100
>
>      MIPS: page.h: Remove now unnecessary #ifndef __ASSEMBLY__ wrapper.
>
I applied it on top of the other patches, but that did not help.
On the contrary, I get even more errors. Must be something else,
or it needs even more patches.

Guenter

