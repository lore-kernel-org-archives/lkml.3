Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756944Ab3DXPFc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 11:05:32 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:51576 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756857Ab3DXPFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 11:05:30 -0400
MIME-Version: 1.0
In-Reply-To: <CAF2Aj3jHPvc=hOcgLq8LONppGtnxUPP96HRPLfCwQ5x4HONUOw@mail.gmail.com>
References: <1365532783-27425-1-git-send-email-lee.jones@linaro.org>
	<CACRpkdYUT+5J-phV=ez-EkmA9EdfxwmDMApTssi+P3=mSE3cew@mail.gmail.com>
	<CAF2Aj3jHPvc=hOcgLq8LONppGtnxUPP96HRPLfCwQ5x4HONUOw@mail.gmail.com>
Date: Wed, 24 Apr 2013 17:05:29 +0200
Message-ID: <CACRpkdZceyOte4vG8QcN5Dy1ooiTT69oOQ1Ud=SffRWbPMXOSg@mail.gmail.com>
Subject: Re: [PATCH 1/8] dmaengine: ste_dma40: Assign memcpy channels in the driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Arnd Bergmann <arnd@arndb.de>, Vinod Koul <vinod.koul@intel.com>,
        Per Forlin <per.forlin@stericsson.com>, Dan Williams <djbw@fb.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 24, 2013 at 4:54 PM, Lee Jones <lee.jones@linaro.org> wrote:
> On 24 April 2013 14:45, Linus Walleij <linus.walleij@linaro.org> wrote:
>> On Tue, Apr 9, 2013 at 8:39 PM, Lee Jones <lee.jones@linaro.org> wrote:
>>
>> > The channels reserved for memcpy are the same for all currently
>> > supported platforms. With this in mind, we can ease the platform
>> > data passing requirement by moving these assignments out from
>> > platform code and place them directly into the driver.
>> >
>> > Cc: Vinod Koul <vinod.koul@intel.com>
>> > Cc: Dan Williams <djbw@fb.com>
>> > Cc: Per Forlin <per.forlin@stericsson.com>
>> > Acked-by: Arnd Bergmann <arnd@arndb.de>
>> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
>>
>> (...)
>>
>> > -/* Reserved event lines for memcpy only */
>> > -static int dma40_memcpy_event[] = {
>> > -       DB8500_DMA_MEMCPY_TX_0,
>> > -       DB8500_DMA_MEMCPY_TX_1,
>> > -       DB8500_DMA_MEMCPY_TX_2,
>> > -       DB8500_DMA_MEMCPY_TX_3,
>> > -       DB8500_DMA_MEMCPY_TX_4,
>> > -       DB8500_DMA_MEMCPY_TX_5,
>> > -};
>>
>> (...)
>>
>> > +/* Reserved event lines for memcpy only. */
>> > +static int dma40_memcpy_channels[] = { 56, 57, 58, 59, 60 };
>>
>> So what's so bad with using the #defines?
>>
>> I would prefer if you took the entire content of
>> arch/arm/mach-ux500/ste-dma40-db8500.h
>> and copied into the DMA driver, so you atleast
>> have a chance of understanding what these numbers
>> are about.
>
>
> I did attempt to do that, but Arnd NAK:ed it:
>
> "Hmm, not sure about this one. The slave numbers are not really
> platform_data and I think they should not be exposed to drivers. It
> makes sense to keep the numbers for the memcpy channels in the driver
> itself as they are hardwired in the driver, but the slave channels
> should stay in the platform I think."
>
> ... and I didn't want to duplicate the defines, but I'll so whatever
> you choose.

I don't think I agree.

OK atleast define the numbers with something like
#define DB8500_DMA_MEMCPY_TX_0 56
etc, just hard-coding the numbers is pretty unhelpful, OK?

Ultimately these 5 numbers should (optionally) come in from
the device tree node for the DMA40 itself, maybe a later patch
adds that...?

Yours,
Linus Walleij
