Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751759Ab3FHIi2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 04:38:28 -0400
Received: from intranet.asianux.com ([58.214.24.6]:28999 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475Ab3FHIiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 04:38:23 -0400
X-Spam-Score: -100.8
Message-ID: <51B2ED4A.3060504@asianux.com>
Date: Sat, 08 Jun 2013 16:37:30 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Mike Frysinger <vapier@gentoo.org>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Arnd Bergmann <arnd@arndb.de>, realmz paranoid <realmz6@gmail.com>,
        linux390@de.ibm.com,
        "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-m32r@ml.linux-m32r.org, linux-m32r-ja@ml.linux-m32r.org,
        linux-s390@vger.kernel.org, Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH] arch: asm-geniric: for atomic_set_mask() 1st param, use
 'unsigned int' instead of 'unsigned long'
References: <51B2E262.3030603@asianux.com> <CAMuHMdVg12Wm4fZYDdgV0m4+Bo76hm=nckGtSkobRfbsmNo2wA@mail.gmail.com>
In-Reply-To: <CAMuHMdVg12Wm4fZYDdgV0m4+Bo76hm=nckGtSkobRfbsmNo2wA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2013 04:31 PM, Geert Uytterhoeven wrote:
> Haven't done a real review, but my eye fell on it:
> 

Thank you for your review, firstly.

> On Sat, Jun 8, 2013 at 9:50 AM, Chen Gang <gang.chen@asianux.com> wrote:
>> > diff --git a/arch/m32r/include/asm/atomic.h b/arch/m32r/include/asm/atomic.h
>> > index 0d81697..233c743 100644
>> > --- a/arch/m32r/include/asm/atomic.h
>> > +++ b/arch/m32r/include/asm/atomic.h
>> > @@ -264,7 +264,7 @@ static __inline__ int __atomic_add_unless(atomic_t *v, int a, int u)
>> >  }
>> >
>> >
>> > -static __inline__ void atomic_clear_mask(unsigned long  mask, atomic_t *addr)
>> > +static __inline__ void atomic_clear_mask(unsigned int mask, atomic_t *addr)
>> >  {
>> >         unsigned long flags;
>> >         unsigned long tmp;
> Shouldn't this become "unsigned int tmp" for consistency, too?
> 

It seems better. (although I guess: for 'm32r', both 'long' and 'int'
are 32-bit).

I will wait for 1 day at least, if no additional suggestions or
completions, I will send patch v2.

>> > @@ -286,7 +286,7 @@ static __inline__ void atomic_clear_mask(unsigned long  mask, atomic_t *addr)
>> >         local_irq_restore(flags);
>> >  }
>> >
>> > -static __inline__ void atomic_set_mask(unsigned long  mask, atomic_t *addr)
>> > +static __inline__ void atomic_set_mask(unsigned int mask, atomic_t *addr)
>> >  {
>> >         unsigned long flags;
>> >         unsigned long tmp;
> Likewise.
> 
> There may be other places that need changes.

OK, I will check them.


Thanks.
-- 
Chen Gang

Asianux Corporation
