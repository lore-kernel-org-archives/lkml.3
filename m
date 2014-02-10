Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877AbaBJKgV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 05:36:21 -0500
Received: from mail-qc0-f180.google.com ([209.85.216.180]:34622 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801AbaBJKgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 05:36:10 -0500
MIME-Version: 1.0
In-Reply-To: <20140204170746.GD22609@sirena.org.uk>
References: <1391529538-21685-1-git-send-email-ulf.hansson@linaro.org>
	<1391529538-21685-9-git-send-email-ulf.hansson@linaro.org>
	<20140204170746.GD22609@sirena.org.uk>
Date: Mon, 10 Feb 2014 11:36:08 +0100
Message-ID: <CAPDyKFraQUcZ_LjSAwENQA_RVqXokKKgfOZh7WD1vKmJ+5KstQ@mail.gmail.com>
Subject: Re: [PATCH 08/17] spi: pl022: Fully gate clocks at request inactivity
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Alessandro Rubini <rubini@unipv.it>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>, Chris Ball <chris@printf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 February 2014 18:07, Mark Brown <broonie@kernel.org> wrote:
> On Tue, Feb 04, 2014 at 04:58:49PM +0100, Ulf Hansson wrote:
>> Use clk_disable_unprepare and clk_prepare_enable from the runtime PM
>> callbacks, to fully gate|ungate clocks. Potentially this will save more
>> power, depending on the clock tree for the current SOC.
>
> The same patch has already been applied (I noticed and fixed it while
> doing unrelated code review).

Sorry, didn't notice that.

Thanks!

Kind regards
Ulf Hansson

>
>>       pinctrl_pm_select_default_state(dev);
>> -     clk_enable(pl022->clk);
>> +     clk_prepare_enable(pl022->clk);
>
> Someone should really make this check errors though!
