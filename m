Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751613Ab3KRQCj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 11:02:39 -0500
Received: from mail-oa0-f41.google.com ([209.85.219.41]:51158 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203Ab3KRQCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 11:02:31 -0500
Date: Mon, 18 Nov 2013 16:02:26 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        angus.clark@st.com
Subject: Re: [PATCH 02/10] mtd: st_spi_fsm: Supply all register address and
 bit logic defines
Message-ID: <20131118160226.GO13640@lee--X1>
References: <1384438956-31153-3-git-send-email-lee.jones@linaro.org>
 <CACRpkdaccxcTfKc-y7rPEH1H3yua3ubLvuvTzWnMs1rOwjiVNw@mail.gmail.com>
 <20131118093229.GB13640@lee--X1>
 <20131118133940.GC14306@sirena.org.uk>
 <20131118142447.GJ13640@lee--X1>
 <20131118144512.GB24408@sirena.org.uk>
 <20131118145614.GM13640@lee--X1>
 <20131118151651.GE24408@sirena.org.uk>
 <20131118153110.GN13640@lee--X1>
 <20131118154137.GA28334@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131118154137.GA28334@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Nov 2013, Mark Brown wrote:

> On Mon, Nov 18, 2013 at 03:31:10PM +0000, Lee Jones wrote:
> > On Mon, 18 Nov 2013, Mark Brown wrote:
> 
> > > This doesn't seem realistic, you're assuming that system integrators
> > > won't go and use chips you've not heard of and at least in the case of
> > > things like quad read my understanding is that the commands aren't
> > > standardised so the host just has to know what to write.
> 
> > I'm not following? What are you suggesting?
> 
> Like I say I'm suggesting that the bit of the code that understands the
> flash chip is separate to the bit of code that knows the mechanics of
> sending commands and data to the chip.
> 
> > After some analysis we have come to the conclusion that using m25p80
> > is not feasible. It makes more sense for this to be an
> > orthogonal/stand-alone driver.
> 
> That seems plausible for the controller side but it seems surprising for
> the flash chip side.

The issue is that almost the entire driver is controller side. The
only bits that are the same (and not in all cases) are the OPCODEs,
but they are one liners (21 lines out of 1153). Most of the
controllers which use this stuff could reuse quite a bit of the m25p80
driver as they just write the message containing the OPCODE as the
m25p80 driver sets it up, but that's simply not the case with our
controller. We would have to pull the OPCODE out and based on which
one it is, we'd have to build our own message.

Put it this way, if we tried to use the m25p80 our controller driver
would most likely be twice as large and twice as complex as it is
currently, which is exactly the inverse of what we're trying to
achieve here.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
