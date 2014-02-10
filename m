Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974AbaBJRsD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 12:48:03 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:60683 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753785AbaBJRrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 12:47:40 -0500
Date: Mon, 10 Feb 2014 11:47:38 -0600
From: Andy Gross <agross@codeaurora.org>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: Mark Brown <broonie@kernel.org>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-spi@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Alok Chauhan <alokc@codeaurora.org>,
        Gilad Avidov <gavidov@codeaurora.org>,
        Kiran Gunda <kgunda@codeaurora.org>,
        Sagar Dharia <sdharia@codeaurora.org>
Subject: Re: [PATCH 2/2] spi: Add Qualcomm QUP SPI controller support
Message-ID: <20140210174738.GA31596@qualcomm.com>
References: <1391705868-20091-1-git-send-email-iivanov@mm-sol.com>
 <1391705868-20091-3-git-send-email-iivanov@mm-sol.com>
 <20140207073952.GA2610@qualcomm.com>
 <1391766753.27491.60.camel@iivanov-dev>
 <20140207173207.GA19974@qualcomm.com>
 <1392051302.2853.56.camel@iivanov-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392051302.2853.56.camel@iivanov-dev>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 06:55:02PM +0200, Ivan T. Ivanov wrote:

[....]

> > > > Bail here?
> > > 
> > > I don't know. What will be the consequences if controller continue to
> > > operate on its default rate?
> > > 
> > 
> > It is unclear.  But if you can't set the rate that is configured or if there is
> > a misconfiguration, it's probably better to exit the probe and catch it here.
> 
> 
> My preference is to delay clock speed change till first
> SPI transfer. And use wherever transfer itself mandate.
> 

That works.  My only concern is that it might be nice to catch a configuration
problem early rather than wait for the SPI transfer to fail continuously.

[....]

> > > My understanding is:
> > > 
> > > Disabling clocks will timeout transaction, if any. Core Device driver
> > > will call: devm_spi_unregister(), which will wait pending transactions
> > > to complete and then remove the SPI master.
> > 
> > Disabling clocks will confuse the hardware.  We cannot disable clocks while the
> > spi core is active and transferring data.
> 
> I could follow approach taken by other SPI drivers, just reset
> controller and disable clocks.

You have to wait until the hardware is in a sane state.  For the QUP, that means
in a RUN/PAUSE/RESET state.  It cannot be in transition when you cut the clocks.
The safest thing to do is to get the QUP into the RESET state and then cut the
clocks.

[.....]

> > > I am not aware of the difference. My board report v.20020000. 
> > > Is there difference of handling these controllers?
> > 
> > There were some bug fixes between versions.  None of those affect SPI (that I
> > can tell), but it's better to be more descriptive and use the full versions in
> > the compatible tags.
> 
> No strong preference here. Should I add qcom,spi-qup-v2.2.0, then? :-)

According to the documentation, there is no v2.2.0.  It appears there is some
disconnect between the specific HW revision and the documentation.  I'll see if
I can get some clarification from the hardware guys.  For now, I think the 2.1.1
and 2.2.1 tags are fine.


-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
