Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140AbaBXRwC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 12:52:02 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:19623 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752997AbaBXRv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 12:51:59 -0500
Date: Mon, 24 Feb 2014 09:51:52 -0800
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Joe Perches <joe@perches.com>
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
        Andy Gross <agross@codeaurora.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>
Subject: Re: [PATCH v3 2/2] i2c: New bus driver for the Qualcomm QUP I2C
 controller
Message-ID: <20140224175152.GB32621@sonymobile.com>
References: <1392943090-30556-1-git-send-email-bjorn.andersson@sonymobile.com>
 <1392943090-30556-3-git-send-email-bjorn.andersson@sonymobile.com>
 <1392943934.2594.14.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1392943934.2594.14.camel@joe-AO722>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 20 Feb 16:52 PST 2014, Joe Perches wrote:

> On Thu, 2014-02-20 at 16:38 -0800, Bjorn Andersson wrote:
> > This bus driver supports the QUP i2c hardware controller in the Qualcomm SOCs.
> > The Qualcomm Universal Peripheral Engine (QUP) is a general purpose data path
> > engine with input/output FIFOs and an embedded i2c mini-core. The driver
> > supports FIFO mode (for low bandwidth applications) and block mode (interrupt
> > generated for each block-size data transfer).
> 
> trivia:
> 
> > diff --git a/drivers/i2c/busses/i2c-qup.c b/drivers/i2c/busses/i2c-qup.c
> []
> > +#ifdef CONFIG_PM_SLEEP
> > +static int qup_i2c_suspend(struct device *device)
> > +{
> > +	dev_dbg(device, "system suspend");
> > +	qup_i2c_pm_suspend_runtime(device);
> > +	return 0;
> > +}
> > +
> > +static int qup_i2c_resume(struct device *device)
> > +{
> > +	dev_dbg(device, "system resume");
> > +	qup_i2c_pm_resume_runtime(device);
> > +	pm_runtime_mark_last_busy(device);
> > +	pm_request_autosuspend(device);
> > +	return 0;
> > +}
> > +#endif
> 
> Missing terminating newlines for dev_dbg statements.

Thanks Joe, missed those.

Regards,
Bjorn
