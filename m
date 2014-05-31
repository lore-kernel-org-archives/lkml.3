Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932649AbaEaMbV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 08:31:21 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:40491 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756382AbaEaMbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 08:31:19 -0400
Date: Sat, 31 May 2014 13:29:45 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: srinivas.kandagatla@linaro.org
Cc: Ulf Hansson <ulf.hansson@linaro.org>, linux-mmc@vger.kernel.org,
        Chris Ball <chris@printf.net>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linus.walleij@linaro.org
Subject: Re: [PATCH v5 11/13] mmc: mmci: add explicit clk control
Message-ID: <20140531122945.GA20736@n2100.arm.linux.org.uk>
References: <1401469918-26817-1-git-send-email-srinivas.kandagatla@linaro.org> <1401470080-27277-1-git-send-email-srinivas.kandagatla@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401470080-27277-1-git-send-email-srinivas.kandagatla@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 06:14:40PM +0100, srinivas.kandagatla@linaro.org wrote:
> @@ -1325,6 +1329,18 @@ static void mmci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
>  	if (!ios->clock && variant->pwrreg_clkgate)
>  		pwr &= ~MCI_PWR_ON;
>  
> +	if ((host->variant->explicit_mclk_control) &&
> +	    (ios->clock != host->clock_cache)) {

Please explain what use these parens have (or just get rid of them as
they're completely unnecessary - they do nothing for readability.)

In fact, additional useless parens result in readability being harmed.

If you don't know the C precedence rules and as a result feel the need
to litter your code with additional parens, then you really shouldn't
be touching C code in the first place. :)

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
