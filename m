Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759842Ab3EOSiJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 14:38:09 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:46247 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759767Ab3EOSiH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 14:38:07 -0400
MIME-Version: 1.0
In-Reply-To: <201305141551.24375.heiko@sntech.de>
References: <201305111330.05046.heiko@sntech.de>
	<201305111331.25405.heiko@sntech.de>
	<CACRpkda-wQyo8aYxbW9RJNcR3Kwe2w5AhaAuUHfaxBksa_Pm2A@mail.gmail.com>
	<201305141551.24375.heiko@sntech.de>
Date: Wed, 15 May 2013 20:38:05 +0200
Message-ID: <CACRpkdY1s7u9Xjzkb+AdFY1xEO1PQOp1ZFPf4r5qPL-=WPkvNQ@mail.gmail.com>
Subject: Re: [RFC 2/4] dma: add dmaengine driver for Samsung s3c24xx SoCs
From: Linus Walleij <linus.walleij@linaro.org>
To: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Dan Williams <djbw@fb.com>, Vinod Koul <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 3:51 PM, Heiko Stübner <heiko@sntech.de> wrote:
> Am Dienstag, 14. Mai 2013, 14:47:19 schrieb Linus Walleij:
>> On Sat, May 11, 2013 at 1:31 PM, Heiko Stübner <heiko@sntech.de> wrote:
>> > Conceptually the s3c24xx-dma feels like a distant relative of the pl08x
>> > with numerous virtual channels being mapped to a lot less physical ones.
>> > The driver therefore borrows a lot from the amba-pl08x driver in this
>> > regard. Functionality-wise the driver gains a memcpy ability in addition
>> > to the slave_sg one.
>> >
>> > The driver currently only supports the "newer" SoCs which can use any
>> > physical channel for any dma slave. Support for the older SoCs where
>> > each channel only supports a subset of possible dma slaves will have to
>> > be added later.
>> >
>> > Tested on a s3c2416-based board, memcpy using the dmatest module and
>> > slave_sg partially using the spi-s3c64xx driver.
>> >
>> > Signed-off-by: Heiko Stuebner <heiko@sntech.de>
>>
>> So have I understood correctly if I assume that *some* S3C
>> variants, i.e. this: arch/arm/mach-s3c64xx/dma.c
>> have a vanilla, unmodified, or just slightly modified
>> PL08x block, while this DMAC is something probably based on
>> the PL08x where some ASIC engineer has had a good time hacking
>> around in the VHDL code to meet some feature requirements.
>> Correct? Or plausible guess?
>
> You're guess is at good as mine :-) . The public s3c64xx (ARM11 based)
> documentation says that it is using s PL080 as dma controller while the
> s3c24xx (ARM9 based) SoCs have this one, which doesn't come with any label in
> the manuals.
> Similar to the s3c64xx using a vic, while the s3c24xx uses something
> homegrown.
>
> The relationship description was more based on the concepts used, i.e. the
> virtual channel concept and general handling of dma transfers feel somehow
> similar - as I said these are my first steps into this, so I still need to
> understand a lot.

OK then, a separate driver seems required, will look a bit closer at
the patch as such.

Yours,
Linus Walleij
