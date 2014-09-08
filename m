Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551AbaIHLCp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 07:02:45 -0400
Received: from exprod7og110.obsmtp.com ([64.18.2.173]:54859 "EHLO
	exprod7og110.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222AbaIHLCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 07:02:43 -0400
MIME-Version: 1.0
In-Reply-To: <20140906135308.GC2601@sirena.org.uk>
References: <1409576021-24828-1-git-send-email-anders.berg@avagotech.com>
	<1409576021-24828-2-git-send-email-anders.berg@avagotech.com>
	<CACRpkdby4H-fivNn_kG2uL0EjsCGAc+t6OyFi0+VcNGf2Z9NQA@mail.gmail.com>
	<20140904170630.GL29327@sirena.org.uk>
	<CACRpkdZEoBan=Lqr1T-iY41U9NfMA_MCLX3LA=juw7X4pmRvSQ@mail.gmail.com>
	<CAE0=X_3QO5p26M=FS7joKS3zD6LAM_moFutHNcyE1-CjauL3Rw@mail.gmail.com>
	<20140906135308.GC2601@sirena.org.uk>
Date: Mon, 8 Sep 2014 13:02:32 +0200
Message-ID: <CAE0=X_2q1Z+pGuh6OY9Si5jbrF9HkczNFUqUgK_8xBekNvMeyQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] gpio: Add driver for AXM55xx SSP chip selects
From: Anders Berg <anders.berg@avagotech.com>
To: Mark Brown <broonie@kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
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

On Sat, Sep 6, 2014 at 3:53 PM, Mark Brown <broonie@kernel.org> wrote:
> On Fri, Sep 05, 2014 at 11:05:37AM +0200, Anders Berg wrote:
>
>> Well, the problem with adding this to the spi-pl022 driver (as a
>> vendor specific extension) is that this IP block unfortunately isn't
>> distinguishable from the standard ARM PL022 implementation (same
>> values in the PrimeCell identification registers). That's why I went
>> down the GPIO path...
>
> Would it not be more straightforward to just register it as a platform
> device in this case, or use a separate OF ID in the DT?  We appear to
> specify a compatible string when registering AMBA devices even if we are
> capable of identifying using the ID registers.

I'll drop this gpio patch for now and submit a patch on the pl022
driver instead. I read the arm,primecell binding and learned that
there is a property (arm,primecell-periphid) that can be used to
override the HW PrimeCell ID. Seems like something to use here, right?

/Anders
