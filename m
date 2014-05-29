Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932701AbaE2NTt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 09:19:49 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:42757 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757401AbaE2NTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:19:47 -0400
Date: Thu, 29 May 2014 14:19:40 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Michal Simek <monstr@monstr.eu>
Cc: Harini Katakam <harinik@xilinx.com>, "wim@iguana.be" <wim@iguana.be>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "rob@landley.net" <rob@landley.net>,
        "michals@xilinx.com" <michals@xilinx.com>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] watchdog: Add Cadence WDT driver
Message-ID: <20140529131940.GG24233@leverpostej>
References: <1401185895-3677-1-git-send-email-harinik@xilinx.com>
 <20140529092106.GC24233@leverpostej>
 <53870129.5010505@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53870129.5010505@monstr.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 10:43:05AM +0100, Michal Simek wrote:
> Hi Mark,
> 
> >> +static struct of_device_id cdns_wdt_of_match[] = {
> >> +       { .compatible = "xlnx,zynq-wdt-r1p2", },
> >> +       { .compatible = "cdns,wdt-r1p2", },
> > 
> > If these can currently be handled identically, why not just have
> > "cdns,wdt-r1p2" in the driver and in your dts have:
> > 
> > compatible = "xlnx,zynq-wdt-r1p2", "cdns,wdt-r1p2";
> > 
> > If we need to distinguish the two for some reason later we can always
> > add the "xlnx,zynq-wdt-r1p2" string to the driver.
> 
> I would prefer to have 2 compatible strings just because
> of that we don't know what is different compare to origin cadence
> version. We have done the same for spi-cadence.c that's why
> it shouldn't be any problem to keep it as is.
> Having zynq compatible property here and using it give us option
> that if another SoC vendor come with new configuration or clean
> cadence one we can simple handle it without changing compatible
> property for us.

Sure, we can have two documented strings. But as I mention for the
moment the driver only needs to support the one string so long as a
given dts has both. Then we can later distinguish the zynq variant (or
any other) as necessary.

Cheers,
Mark.
