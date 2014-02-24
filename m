Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbaBXOyO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 09:54:14 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:57806 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553AbaBXOyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 09:54:11 -0500
MIME-Version: 1.0
In-Reply-To: <CAPDyKFq3uAoo7p-7hZgBmMJ4jf9A7dC0aUZJYUE0z1Qq5W=0bw@mail.gmail.com>
References: <1391529538-21685-1-git-send-email-ulf.hansson@linaro.org>
	<1391529538-21685-4-git-send-email-ulf.hansson@linaro.org>
	<20140218160542.GH21483@n2100.arm.linux.org.uk>
	<CAPDyKFq3uAoo7p-7hZgBmMJ4jf9A7dC0aUZJYUE0z1Qq5W=0bw@mail.gmail.com>
Date: Mon, 24 Feb 2014 15:54:10 +0100
Message-ID: <CACRpkdYF4sR4SJ_jZsVLY2tNV0xDfR2GG63bF5e=bkthpDsDGQ@mail.gmail.com>
Subject: Re: [PATCH 03/17] mmc: mmci: Mask IRQs for all variants during
 runtime suspend
From: Linus Walleij <linus.walleij@linaro.org>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Alessandro Rubini <rubini@unipv.it>, Wolfram Sang <wsa@the-dreams.de>,
        Chris Ball <chris@printf.net>, Mark Brown <broonie@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 5:36 PM, Ulf Hansson <ulf.hansson@linaro.org> wrote:
> On 18 February 2014 17:05, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
>> On Tue, Feb 04, 2014 at 04:58:44PM +0100, Ulf Hansson wrote:
>>> In runtime suspended state, we are not expecting IRQs and thus we can
>>> safely mask them, not only for pwrreg_nopower variants but for all.
>>>
>>> Obviously we then also need to make sure we restore the IRQ mask while
>>> becoming runtime resumed.
>>
>> So, what happens when this patch is applied, and a SDIO card is attached
>> which expects to receive interrupts at any moment?
>
> Currently, no variant implements SDIO irq.
>
> The SDIO irq polling mode from the sdio core will still be functional,
> as of today. So, this patch will not break SDIO.
>
>>
>> Given that I've run into this during the last week with a SDHCI controller,
>> I'm not that thrilled with other interfaces doing the same broken thing.
>
> If we add SDIO irq support to mmci in future; parts of that
> implementation includes a re-route of DAT1 to a GPIO irq when entering
> runtime suspend state. The mmci HW will in runtime suspend state, not
> be responsible for handling irqs, which is the same as of today.

[Just smalltalk]

Switching DAT1 to "gpio mode" (which is something of a fallacy, see
explanation in Documentation/pinctrl.txt) is not at all possible in all
implementations of the PL18x, as it depends on exploiting properties
on an assumed pin controller.

Systems that don't have such wakeup features on their pins are
unlikely to support deepsleep in any capacity, and if they do they are
ill-designed from the top level as this needs to be taken into account
when devising the hardware :-/

Yours,
Linus Walleij
