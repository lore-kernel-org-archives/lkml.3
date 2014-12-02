Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933054AbaLBLVh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 06:21:37 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:36800 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933013AbaLBLVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 06:21:35 -0500
Date: Tue, 2 Dec 2014 11:21:30 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Harini Katakam <harinik@xilinx.com>
Cc: "wsa@the-dreams.de" <wsa@the-dreams.de>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        "soren.brinkmann@xilinx.com" <soren.brinkmann@xilinx.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "vishnum@xilinx.com" <vishnum@xilinx.com>
Subject: Re: [PATCH 4/4] i2c: cadence: Defeature repeated start based on
 devicetree property
Message-ID: <20141202112130.GD23671@leverpostej>
References: <1417514749-24319-1-git-send-email-harinik@xilinx.com>
 <1417514749-24319-5-git-send-email-harinik@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417514749-24319-5-git-send-email-harinik@xilinx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2014 at 10:05:49AM +0000, Harini Katakam wrote:
> From: Vishnu Motghare <vishnum@xilinx.com>
> 
> This patch defeatures repeated start in the driver if
> "defeature-repeated-start" property is present in the devicetree.
> 
> This defeature is proposed due to a few bugs in the controller
> - completion indication is not given to the driver at the end of
> a read/receive transfer with HOLD bit set.
> - Invalid read transaction are generated on the bus when HW timeout
> condition occurs with HOLD bit set.
> 
> Signed-off-by: Vishnu Motghare <vishnum@xilinx.com>
> Signed-off-by: Harini Katakam <harinik@xilinx.com>
> ---
>  drivers/i2c/busses/i2c-cadence.c |   44 +++++++++++++++++++++++++++-----------
>  1 file changed, 31 insertions(+), 13 deletions(-)

[...]

> @@ -840,6 +856,8 @@ static int cdns_i2c_probe(struct platform_device *pdev)
>  	cdns_i2c_writereg(CDNS_I2C_CR_ACK_EN | CDNS_I2C_CR_NEA | CDNS_I2C_CR_MS,
>  			  CDNS_I2C_CR_OFFSET);
>  
> +	of_property_read_u32(pdev->dev.of_node,	"defeature-repeated-start",
> +			     &id->defeature_repeated_start);

This will not work with the binding you described. You want to treat
this as a bool, and use of_property_read_bool.

Thanks,
Mark.
