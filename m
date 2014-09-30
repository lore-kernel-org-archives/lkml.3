Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421AbaI3W1r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 18:27:47 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:13349 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750962AbaI3W1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 18:27:46 -0400
Date: Tue, 30 Sep 2014 15:27:55 -0700
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Jeffrey Hugo <jhugo@codeaurora.org>
CC: Ohad Ben-Cohen <ohad@wizery.com>, Kumar Gala <galak@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Grant Likely <grant.likely@linaro.org>, Suman Anna <s-anna@ti.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Eric Holmberg <eholmber@codeaurora.org>,
        "Cavin, Courtney" <Courtney.Cavin@sonymobile.com>
Subject: Re: [PATCH v4] hwspinlock: qcom: Add support for Qualcomm HW Mutex
 block
Message-ID: <20140930222754.GX28481@sonymobile.com>
References: <1412051728-3289-1-git-send-email-bjorn.andersson@sonymobile.com>
 <542B2B4A.7060002@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <542B2B4A.7060002@codeaurora.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 30 Sep 15:14 PDT 2014, Jeffrey Hugo wrote:

> On 9/29/2014 10:35 PM, Bjorn Andersson wrote:

[..]

> > +static int qcom_hwspinlock_probe(struct platform_device *pdev)
> > +{
> > +	struct device_node *node = pdev->dev.of_node;
> > +	const struct of_device_id *match;
> > +	struct hwspinlock_device *bank;
> > +	struct hwspinlock *hwlock;
> > +	struct resource *res;
> > +	void __iomem *iobase;
> > +	unsigned stride, i;
> > +	size_t array_size;
> > +	u32 num_locks;
> > +	int ret;
> > +
> > +	match = of_match_device(qcom_hwspinlock_of_match, &pdev->dev);
> Didn't this have error handling in v2?

It did, but as this is a platform_device and we only support DTthere is no way
match will be NULL if we end up here. So the possible check would be to see
that data is non-null, but for this driver that wouldn't make sense.

Regards,
Bjorn
