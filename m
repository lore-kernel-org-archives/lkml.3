Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786AbaIKV3q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 17:29:46 -0400
Received: from exprod7og124.obsmtp.com ([64.18.2.26]:58315 "EHLO
	exprod7og124.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726AbaIKV3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 17:29:45 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdavQBJkaC40GJkD396JkwPjSr_dzWegn8veLpG-Fcn-SQ@mail.gmail.com>
References: <1410360030-26634-1-git-send-email-anders.berg@avagotech.com>
	<CACRpkdavQBJkaC40GJkD396JkwPjSr_dzWegn8veLpG-Fcn-SQ@mail.gmail.com>
Date: Thu, 11 Sep 2014 23:29:43 +0200
Message-ID: <CAE0=X_2W43VdysVJ6JGEMPuwq2nUSyYRX6Rm=Ds+Hait0i4gsg@mail.gmail.com>
Subject: Re: [PATCH] spi: pl022: Add support for chip select extension
From: Anders Berg <anders.berg@avagotech.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Mark Brown <broonie@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 3:26 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Wed, Sep 10, 2014 at 4:40 PM, Anders Berg <anders.berg@avagotech.com> wrote:
>
>> Add support for a extended PL022 which has an extra register for controlling up
>> to five chip select signals. This controller is found on the AXM5516 SoC.
>> Unfortunately the PrimeCell identification registers are identical to a
>> standard ARM PL022. To work around this, the peripheral ID must be overridden
>> in the device tree using the "arm,primecell-periphid" property with the value
>> 0x000b6022.
>>
>> Signed-off-by: Anders Berg <anders.berg@avagotech.com>
> (...)
>> +               /*
>> +                * PL022 variant that has a chip select control register whih
>> +                * allows control of 5 output signals nCS[0:4].
>> +                */
>> +               .id     = 0x000b6022,
>
> OK so you're defining 0xb6 to the the 8bit ID for LSI.
>
> Do you have some special reason for this, like that it appears
> in some other silicon block from LSI? Otherwise I suggest using
> 0x4c (uppercase 'L') so as to follow the pattern of the other
> vendor IDs.

I picked 0xb6 since I've seen some reference manuals for other AMBA
peripherals the use of JEDEC assigned vendor IDs in this register
field (see the PL390 TRM for example). So I put the LSI Logic 7-bit
JEDEC ID (0x36) there: [0:6] = 0x36, [7] = 1 (the MSB set to '1' to
signify the use of JEDEC ID instead of a "classic" AMBA vendor).

/Anders
