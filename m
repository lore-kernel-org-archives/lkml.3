Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282AbaIEJFu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 05:05:50 -0400
Received: from exprod7og112.obsmtp.com ([64.18.2.177]:55325 "EHLO
	exprod7og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755924AbaIEJFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 05:05:48 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdZEoBan=Lqr1T-iY41U9NfMA_MCLX3LA=juw7X4pmRvSQ@mail.gmail.com>
References: <1409576021-24828-1-git-send-email-anders.berg@avagotech.com>
	<1409576021-24828-2-git-send-email-anders.berg@avagotech.com>
	<CACRpkdby4H-fivNn_kG2uL0EjsCGAc+t6OyFi0+VcNGf2Z9NQA@mail.gmail.com>
	<20140904170630.GL29327@sirena.org.uk>
	<CACRpkdZEoBan=Lqr1T-iY41U9NfMA_MCLX3LA=juw7X4pmRvSQ@mail.gmail.com>
Date: Fri, 5 Sep 2014 11:05:37 +0200
Message-ID: <CAE0=X_3QO5p26M=FS7joKS3zD6LAM_moFutHNcyE1-CjauL3Rw@mail.gmail.com>
Subject: Re: [PATCH 1/2] gpio: Add driver for AXM55xx SSP chip selects
From: Anders Berg <anders.berg@avagotech.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Mark Brown <broonie@kernel.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Sep 4, 2014 at 7:06 PM, Mark Brown <broonie@kernel.org> wrote:
>> On Thu, Sep 04, 2014 at 07:04:44PM +0200, Linus Walleij wrote:
>>> I need an ACK from Mark Brown on this before I apply.
>>> The driver seems to do what it should, but I need Mark to
>>> be OK with exporting the CS signals from an SSP/SPI block
>>> to be exposed to Linux as GPIOs.
>>>
>>> (Top-posting and quoting patch verbatim so Mark gets it.)
>>
>> I don't see any sort of reasoning for this?
>
> Maybe there was some earlier, but this is an excellent opportunity
> to repeat it... So Anders: why do you want to do this?
>

Well, the problem with adding this to the spi-pl022 driver (as a
vendor specific extension) is that this IP block unfortunately isn't
distinguishable from the standard ARM PL022 implementation (same
values in the PrimeCell identification registers). That's why I went
down the GPIO path...

/Anders
