Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578AbaBRQgz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 11:36:55 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:50809 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbaBRQgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 11:36:53 -0500
MIME-Version: 1.0
In-Reply-To: <20140218160542.GH21483@n2100.arm.linux.org.uk>
References: <1391529538-21685-1-git-send-email-ulf.hansson@linaro.org>
	<1391529538-21685-4-git-send-email-ulf.hansson@linaro.org>
	<20140218160542.GH21483@n2100.arm.linux.org.uk>
Date: Tue, 18 Feb 2014 17:36:52 +0100
Message-ID: <CAPDyKFq3uAoo7p-7hZgBmMJ4jf9A7dC0aUZJYUE0z1Qq5W=0bw@mail.gmail.com>
Subject: Re: [PATCH 03/17] mmc: mmci: Mask IRQs for all variants during
 runtime suspend
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Alessandro Rubini <rubini@unipv.it>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>, Chris Ball <chris@printf.net>,
        Mark Brown <broonie@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 February 2014 17:05, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Tue, Feb 04, 2014 at 04:58:44PM +0100, Ulf Hansson wrote:
>> In runtime suspended state, we are not expecting IRQs and thus we can
>> safely mask them, not only for pwrreg_nopower variants but for all.
>>
>> Obviously we then also need to make sure we restore the IRQ mask while
>> becoming runtime resumed.
>
> So, what happens when this patch is applied, and a SDIO card is attached
> which expects to receive interrupts at any moment?

Currently, no variant implements SDIO irq.

The SDIO irq polling mode from the sdio core will still be functional,
as of today. So, this patch will not break SDIO.

>
> Given that I've run into this during the last week with a SDHCI controller,
> I'm not that thrilled with other interfaces doing the same broken thing.

If we add SDIO irq support to mmci in future; parts of that
implementation includes a re-route of DAT1 to a GPIO irq when entering
runtime suspend state. The mmci HW will in runtime suspend state, not
be responsible for handling irqs, which is the same as of today.

Kind regards
Ulf Hansson

>
> --
> FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
> in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
> Estimate before purchase was "up to 13.2Mbit".
