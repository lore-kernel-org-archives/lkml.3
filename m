Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224AbaIKN0E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 09:26:04 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:39504 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754648AbaIKN0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 09:26:02 -0400
MIME-Version: 1.0
In-Reply-To: <1410360030-26634-1-git-send-email-anders.berg@avagotech.com>
References: <1410360030-26634-1-git-send-email-anders.berg@avagotech.com>
Date: Thu, 11 Sep 2014 15:26:01 +0200
Message-ID: <CACRpkdavQBJkaC40GJkD396JkwPjSr_dzWegn8veLpG-Fcn-SQ@mail.gmail.com>
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

On Wed, Sep 10, 2014 at 4:40 PM, Anders Berg <anders.berg@avagotech.com> wrote:

> Add support for a extended PL022 which has an extra register for controlling up
> to five chip select signals. This controller is found on the AXM5516 SoC.
> Unfortunately the PrimeCell identification registers are identical to a
> standard ARM PL022. To work around this, the peripheral ID must be overridden
> in the device tree using the "arm,primecell-periphid" property with the value
> 0x000b6022.
>
> Signed-off-by: Anders Berg <anders.berg@avagotech.com>
(...)
> +               /*
> +                * PL022 variant that has a chip select control register whih
> +                * allows control of 5 output signals nCS[0:4].
> +                */
> +               .id     = 0x000b6022,

OK so you're defining 0xb6 to the the 8bit ID for LSI.

Do you have some special reason for this, like that it appears
in some other silicon block from LSI? Otherwise I suggest using
0x4c (uppercase 'L') so as to follow the pattern of the other
vendor IDs.

Please patch include/linux/amba/bus.h to add
AMBA_VENDOR_LSI = 0x4c (or 6b) as well, as this is the first
occurence.

Yours,
Linus Walleij
