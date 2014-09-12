Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751143AbaILRAc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 13:00:32 -0400
Received: from mail-oi0-f48.google.com ([209.85.218.48]:50165 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaILRAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 13:00:31 -0400
MIME-Version: 1.0
In-Reply-To: <CAE0=X_1YMs1OUx3H65qbZ9CX-oSiW4Uo65Z7qCW8-6ksc4ovvQ@mail.gmail.com>
References: <1410360030-26634-1-git-send-email-anders.berg@avagotech.com>
	<CACRpkdavQBJkaC40GJkD396JkwPjSr_dzWegn8veLpG-Fcn-SQ@mail.gmail.com>
	<CAE0=X_1YMs1OUx3H65qbZ9CX-oSiW4Uo65Z7qCW8-6ksc4ovvQ@mail.gmail.com>
Date: Fri, 12 Sep 2014 19:00:30 +0200
Message-ID: <CACRpkdZfzsg-upNJaWX5CO6dJn3mg=wzhKhX-koask4ckxVTmQ@mail.gmail.com>
Subject: Re: [PATCH] spi: pl022: Add support for chip select extension
From: Linus Walleij <linus.walleij@linaro.org>
To: Anders Berg <anders.berg@avagotech.com>
Cc: Mark Brown <broonie@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 10:10 PM, Anders Berg <anders.berg@avagotech.com> wrote:
> On Thu, Sep 11, 2014 at 3:26 PM, Linus Walleij <linus.walleij@linaro.org>
> wrote:
>> On Wed, Sep 10, 2014 at 4:40 PM, Anders Berg <anders.berg@avagotech.com>
>> wrote:
>> (...)
>> > +               /*
>> > +                * PL022 variant that has a chip select control register
>> > whih
>> > +                * allows control of 5 output signals nCS[0:4].
>> > +                */
>> > +               .id     = 0x000b6022,
>>
>> OK so you're defining 0xb6 to the the 8bit ID for LSI.
>>
>> Do you have some special reason for this, like that it appears
>> in some other silicon block from LSI? Otherwise I suggest using
>> 0x4c (uppercase 'L') so as to follow the pattern of the other
>> vendor IDs.
>
>
> I picked 0xb6 since I've seen some reference manuals for other AMBA
> peripherals the use of JEDEC assigned vendor IDs in this register field (see
> the PL390 TRM for example). So I put the LSI Logic 7-bit JEDEC ID (0x36)
> there: [0:6] = 0x36, [7] = 1 (the MSB set to '1' to signify the use of JEDEC
> ID instead of a "classic" AMBA vendor).

Hey that's very observant, I had no clue about that scheme!

Can you write a comment about this in <linux/amba/bus.h> when
you patch it (like above the enum) so we know that in the future
when people need to pick new IDs?

Yours,
Linus Walleij
