Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098AbaGAMGe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 08:06:34 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:49484 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751171AbaGAMGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 08:06:33 -0400
Date: Tue, 1 Jul 2014 13:06:22 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, Alexandre Courbot <gnurou@gmail.com>,
        Mark Brown <broonie@linaro.org>
Subject: Re: [PATCH] regulator: core: Still free GPIOs using gpio_free()
Message-ID: <20140701120622.GJ32514@n2100.arm.linux.org.uk>
References: <1404215726-2480-1-git-send-email-broonie@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404215726-2480-1-git-send-email-broonie@kernel.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2014 at 12:55:26PM +0100, Mark Brown wrote:
> From: Mark Brown <broonie@linaro.org>
> 
> Even though we mostly use GPIO descriptors internally we still use
> gpio_request_one() to request so we need to pair that with gpio_free() to
> release the GPIO.
> 
> Reported-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Mark Brown <broonie@linaro.org>

This doesn't explain the reason...  I see the current GPIO code doing this:

void gpio_free(unsigned gpio)
{
        gpiod_free(gpio_to_desc(gpio));
}
EXPORT_SYMBOL_GPL(gpio_free);

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
