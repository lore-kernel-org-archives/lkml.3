Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867AbaBXSDj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 13:03:39 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:3098 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752495AbaBXSDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 13:03:37 -0500
Date: Mon, 24 Feb 2014 10:03:30 -0800
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
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
Message-ID: <20140224180330.GD32621@sonymobile.com>
References: <1392943090-30556-1-git-send-email-bjorn.andersson@sonymobile.com>
 <1392943090-30556-3-git-send-email-bjorn.andersson@sonymobile.com>
 <20140221081603.GA3931@lukather>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140221081603.GA3931@lukather>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 21 Feb 00:16 PST 2014, Maxime Ripard wrote:

> Hi Bjorn,
> 
> On Thu, Feb 20, 2014 at 04:38:10PM -0800, Bjorn Andersson wrote:
> > +static int qup_i2c_probe(struct platform_device *pdev)
> > +{
> 
> [ snip ]
> 
> > +
> > +	qup_i2c_enable_clocks(qup);
> > +
> 
> [ snip ]
> 
> > +
> > +	pm_runtime_set_autosuspend_delay(qup->dev, MSEC_PER_SEC);
> > +	pm_runtime_use_autosuspend(qup->dev);
> > +	pm_runtime_enable(qup->dev);
> 
> Since the device is already woken up, you probably need to call
> pm_runtime_set_active here.

Thanks.

> 
> Maxime

Regards,
Bjorn
