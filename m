Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456AbaBXSAu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 13:00:50 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:2439 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752737AbaBXSAs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 13:00:48 -0500
Date: Mon, 24 Feb 2014 10:00:41 -0800
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Emilio L?pez <emilio@elopez.com.ar>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Wolfram Sang <wsa@the-dreams.de>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Andy Gross <agross@codeaurora.org>
Subject: Re: [PATCH v3 2/2] i2c: New bus driver for the Qualcomm QUP I2C
 controller
Message-ID: <20140224180040.GC32621@sonymobile.com>
References: <1392943090-30556-1-git-send-email-bjorn.andersson@sonymobile.com>
 <1392943090-30556-3-git-send-email-bjorn.andersson@sonymobile.com>
 <5306BFC4.5000005@elopez.com.ar>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <5306BFC4.5000005@elopez.com.ar>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 20 Feb 18:53 PST 2014, Emilio L?pez wrote:

> Hi Bjorn,
> 
> El 20/02/14 21:38, Bjorn Andersson escribió:
[...]
> > +	clk_freq = 100000;
> > +	if (!of_property_read_u32(node, "clock-frequency", &val))
> > +		clk_freq = val;
> 
> val will be modified only if no error occurs, so you may rewrite this 
> bit as
> 
> +	u32 clk_freq = 100000;
> ...
> +	of_property_read_u32(node, "clock-frequency", &clk_freq)

Seems the two conventions used in the kernel is either your proposal or "if
fail the assign default". So I'll change this.

> 
> > +
> > +	/* We support frequencies up to FAST Mode (400KHz) */
> > +	if (clk_freq <= 0 || clk_freq > 400000) {
> 
> And you can drop the < check when it's unsigned.

Indeed!

> 
> > +		dev_err(qup->dev, "clock frequency not supported %d\n",
> > +			clk_freq);
> > +		return -EIO;
> 
> EIO?

EINVAL

> 
> Cheers,
> 
> Emilio

Thanks,
Bjorn
