Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501AbaBRQq2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 11:46:28 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:40816 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751328AbaBRQq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 11:46:27 -0500
Date: Tue, 18 Feb 2014 16:46:14 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ulf Hansson <ulf.hansson@linaro.org>
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
Subject: Re: [PATCH 03/17] mmc: mmci: Mask IRQs for all variants during
	runtime suspend
Message-ID: <20140218164614.GI21483@n2100.arm.linux.org.uk>
References: <1391529538-21685-1-git-send-email-ulf.hansson@linaro.org> <1391529538-21685-4-git-send-email-ulf.hansson@linaro.org> <20140218160542.GH21483@n2100.arm.linux.org.uk> <CAPDyKFq3uAoo7p-7hZgBmMJ4jf9A7dC0aUZJYUE0z1Qq5W=0bw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPDyKFq3uAoo7p-7hZgBmMJ4jf9A7dC0aUZJYUE0z1Qq5W=0bw@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 05:36:52PM +0100, Ulf Hansson wrote:
> If we add SDIO irq support to mmci in future; parts of that
> implementation includes a re-route of DAT1 to a GPIO irq when entering
> runtime suspend state. The mmci HW will in runtime suspend state, not
> be responsible for handling irqs, which is the same as of today.

Note that the "irq thread" in sdio_irq is scheduled for destruction -
it's buggy when the system is under high load and a driver claims a
SDIO irq.  Sched people hate it too...

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
