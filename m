Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715AbaJVTK3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 15:10:29 -0400
Received: from mail-oi0-f44.google.com ([209.85.218.44]:51547 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529AbaJVTK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 15:10:27 -0400
MIME-Version: 1.0
In-Reply-To: <20141022164454.GI15370@e104818-lin.cambridge.arm.com>
References: <1413993983-17310-1-git-send-email-mathieu.poirier@linaro.org>
	<20141022164454.GI15370@e104818-lin.cambridge.arm.com>
Date: Wed, 22 Oct 2014 21:10:27 +0200
Message-ID: <CANLsYkx08dw=YYBoRJ47QC+iL578HxPoMFcRDw6aKsvyqaqtkw@mail.gmail.com>
Subject: Re: [PATCH] ARM: supplementing IO accessors with 64 bit capability
From: Mathieu Poirier <mathieu.poirier@linaro.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "stefano.stabellini@eu.citrix.com" <stefano.stabellini@eu.citrix.com>,
        "ezequiel.garcia@free-electrons.com" 
	<ezequiel.garcia@free-electrons.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        "thomas.petazzoni@free-electrons.com" 
	<thomas.petazzoni@free-electrons.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 October 2014 18:44, Catalin Marinas <catalin.marinas@arm.com> wrote:
> On Wed, Oct 22, 2014 at 05:06:23PM +0100, mathieu.poirier@linaro.org wrote:
>> +#if __LINUX_ARM_ARCH__ >= 5
>
> My old ARMv5 book does not list LDRD/STRD. It looks like they only come
> with ARMv5TE. Are there any processors prior to this supported by the
> kernel?
>
>> +static inline void __raw_writeq(u64 val, volatile void __iomem *addr)
>> +{
>> +     asm volatile("strd %1, %0"
>> +                  : "+Qo" (*(volatile u64 __force *)addr)
>> +                  : "r" (val));
>> +}
>> +
>> +static inline u64 __raw_readq(const volatile void __iomem *addr)
>> +{
>> +     u64 val;
>> +     asm volatile("ldrd %1, %0"
>> +                  : "+Qo" (*(volatile u64 __force *)addr),
>> +                    "=r" (val));
>> +     return val;
>> +}
>> +#endif
>
> I'm curious why you need these. Do you have a device that needs a 64-bit
> single access or you are trying to read two consecutive registers?

The fundamental data size of Coresight STM32 for ARMv7 is
implementation defined and can be 32 or 64bit.  As such stimulus ports
can support transaction sizes of up to 64 bit.

Mathieu

>
> --
> Catalin
