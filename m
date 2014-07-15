Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758636AbaGOKvT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 06:51:19 -0400
Received: from mail-qg0-f42.google.com ([209.85.192.42]:56055 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758038AbaGOKvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 06:51:17 -0400
MIME-Version: 1.0
In-Reply-To: <6508070.FGfEk39Nmq@wuerfel>
References: <1405413956-2772-1-git-send-email-lftan@altera.com>
	<1405413956-2772-7-git-send-email-lftan@altera.com>
	<6508070.FGfEk39Nmq@wuerfel>
Date: Tue, 15 Jul 2014 18:51:16 +0800
X-Google-Sender-Auth: Wyn_w1ZcuTUiCMGCGa2f839cuvI
Message-ID: <CAFiDJ58U-uK1izCB1w2-+v-_RWp=3=WEdK29+bhMshh_is9RtQ@mail.gmail.com>
Subject: Re: [PATCH v2 06/29] nios2: I/O Mapping
From: Ley Foon Tan <lftan@altera.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Chung-Lin Tang <cltang@codesourcery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 5:22 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 15 July 2014 16:45:33 Ley Foon Tan wrote:
>> +#ifdef __IO_USE_DUFFS
>> +
>> +/* Use "Duff's Device" to unroll the loops. */
>> +#define __IO_OUT_LOOP(a, b, l)                               \
>> +     do {                                            \
>
> The I/O loops can probably better go into the C file that uses them.
Okay.


>
> These should either use inline functions or macros that behave like them,
> to avoid miscompilation. The normal way to define those macros is
>
> #define inb(a) ({ 0; })
> #define outb(x, a) do { } while (0)
Okay, will update these.

>
>> +static inline void __iomem *ioremap_writethrough(unsigned long physaddr,
>> +                                             unsigned long size)
>> +{
>> +     return __ioremap(physaddr, size, 0);
>> +}
>
> ioremap_writethrough() is not a standard interface, just drop it.
Okay, will drop this.
>
>> +static inline void __iomem *ioremap_fullcache(unsigned long physaddr,
>> +                                             unsigned long size)
>> +{
>> +     return __ioremap(physaddr, size, _PAGE_CACHED);
>> +}
>
> This is more commonly called ioremap_cache().
>
> ioremap_fullcache() is defined on some architectures but never used. If
> you don't use this in your own code, you can drop it as well.

We are not using ioremap_fullcache(), will drop it.

Thanks.

Regards
Ley Foon
