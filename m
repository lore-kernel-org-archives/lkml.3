Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096AbaJHILv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 04:11:51 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:56654 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755051AbaJHILq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 04:11:46 -0400
Date: Wed, 8 Oct 2014 09:11:12 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Scott Branden <sbranden@broadcom.com>
Cc: Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        bcm-kernel-feedback-list@broadcom.com,
        Mike Turquette <mturquette@linaro.org>, Alex Elder <elder@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Antti Palosaari <crope@iki.fi>, JD Zheng <jdzheng@broadcom.com>,
        Ray Jui <rjui@broadcom.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Jonathan Richardson <jonathar@broadcom.com>
Subject: Re: [PATCH 1/6] ARM: cygnus: Initial support for Broadcom Cygnus
	SoC
Message-ID: <20141008081112.GB5182@n2100.arm.linux.org.uk>
References: <sbranden@broadcom.com> <1412746025-11998-1-git-send-email-sbranden@broadcom.com> <1412746025-11998-2-git-send-email-sbranden@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412746025-11998-2-git-send-email-sbranden@broadcom.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 10:27:00PM -0700, Scott Branden wrote:
> +static void __init bcm_cygnus_init(void)
> +{
> +	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
> +
> +	l2x0_of_init(0, ~0UL);

Please don't explicitly call l2x0 initialisation.  Instead, set the
appropriate l2c members here:

> +DT_MACHINE_START(BCM_CYGNUS_DT, "Broadcom Cygnus SoC")
> +	.init_machine = bcm_cygnus_init,
> +	.map_io = debug_ll_io_init,
> +	.dt_compat = bcm_cygnus_dt_compat,
> +	.restart   = bcm_cygnus_restart
> +MACHINE_END

and let the core code call it at the appropriate time.  Thanks.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
