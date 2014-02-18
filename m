Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002AbaBRQF6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 11:05:58 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:40731 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755390AbaBRQF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 11:05:57 -0500
Date: Tue, 18 Feb 2014 16:05:42 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, Alessandro Rubini <rubini@unipv.it>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>, Chris Ball <chris@printf.net>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-mmc@vger.kernel.org
Subject: Re: [PATCH 03/17] mmc: mmci: Mask IRQs for all variants during
	runtime suspend
Message-ID: <20140218160542.GH21483@n2100.arm.linux.org.uk>
References: <1391529538-21685-1-git-send-email-ulf.hansson@linaro.org> <1391529538-21685-4-git-send-email-ulf.hansson@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391529538-21685-4-git-send-email-ulf.hansson@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 04, 2014 at 04:58:44PM +0100, Ulf Hansson wrote:
> In runtime suspended state, we are not expecting IRQs and thus we can
> safely mask them, not only for pwrreg_nopower variants but for all.
> 
> Obviously we then also need to make sure we restore the IRQ mask while
> becoming runtime resumed.

So, what happens when this patch is applied, and a SDIO card is attached
which expects to receive interrupts at any moment?

Given that I've run into this during the last week with a SDHCI controller,
I'm not that thrilled with other interfaces doing the same broken thing.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
