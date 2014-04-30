Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946049AbaD3QnJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 12:43:09 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:59129 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933593AbaD3QnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 12:43:06 -0400
Date: Wed, 30 Apr 2014 10:42:36 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 07/15] ARM: dts: kirkwood: consolidate common pinctrl
 settings
Message-ID: <20140430164236.GC12944@obsidianresearch.com>
References: <1398862602-29595-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1398862602-29595-8-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398862602-29595-8-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 02:56:34PM +0200, Sebastian Hesselbarth wrote:
> All SoCs have the same pinctrl setting for NAND, UART0/1, SPI, TWSI0,
> and GBE1. Move it to the common pinctrl node that we now have.

There are two possible choices for UART0, UART1, and SPI on kirkwood..

For instance I use this on my board:

                                pmx_spi0: pmx-spi0 {
                                        marvell,pins = "mpp7", "mpp10", "mpp11", "mpp12";
                                        marvell,function = "spi";
                                };

vs

> +
> +			pmx_spi: pmx-spi {
> +				marvell,pins = "mpp0", "mpp1", "mpp2", "mpp3";
> +				marvell,function = "spi";
> +			};

It looks like all the boards in the kernel use the same choice, so it
makes some sense to consolidate, but I assume a board file can
override the marvell,pins?

Otherwise the rest of your patchset looked sane to me.

Regards,
Jason
