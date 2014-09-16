Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbaIPJfD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 05:35:03 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:49594 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706AbaIPJe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 05:34:59 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-92-54180440b440
Message-id: <1410860095.16106.1.camel@AMDC1943>
Subject: Re: [PATCH v4 3/4] amba: Don't unprepare the clocks if device driver
 wants IRQ safe runtime PM
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <michal.simek@xilinx.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Randy Dunlap <rdunlap@infradead.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-doc@vger.kernel.org,
        linux-pm@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Tue, 16 Sep 2014 11:34:55 +0200
In-reply-to: <20140916092006.GG12361@n2100.arm.linux.org.uk>
References: <1410857494-15936-1-git-send-email-k.kozlowski@samsung.com>
 <1410857494-15936-4-git-send-email-k.kozlowski@samsung.com>
 <20140916092006.GG12361@n2100.arm.linux.org.uk>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCIsWRmVeSWpSXmKPExsVy+t/xK7oOLBIhBq+e61psnLGe1WL61AuM
	Fqun/mW1OPBnB6PF2aY37BZLJs9ntZg1ZS+TxcK2JSwWl3fNYbP43HuE0eL2ZV6LtUfuslu8
	exlhcffUUTaLt3ems1icOX2J1WLC7wtsFsfXhlu87NvP4iDs0dLcw+axeYWWx+I9L5k87lzb
	w+ax5M0hVo8tV9tZPGbf/cHo0bdlFaPHitXf2T0+b5Lz2Pv5N0sAdxSXTUpqTmZZapG+XQJX
	xpI/9xkLnrJUvHg5ib2B8TpzFyMnh4SAicT3L/2sELaYxIV769lAbCGBpYwSqz6ldzFyAdmf
	GSVmtv8Ba+AV0Jd4saSHBcQWFsiU6J3VzA5iswkYS2xevgSsWUTAVOLao2fMIM3MAmtZJW6s
	vcIIkmARUJVYsP4HWDOngI3E4RsbWCE2bGeUeHfmDtgkZgF1iUnzFgF1cwCdpCzR2O8GsVhQ
	4sfkeywQJfISm9e8ZZ7AKDALSccsJGWzkJQtYGRexSiaWppcUJyUnmukV5yYW1yal66XnJ+7
	iRESk193MC49ZnWIUYCDUYmHN+OfeIgQa2JZcWXuIUYJDmYlEd6Lf4BCvCmJlVWpRfnxRaU5
	qcWHGJk4OKUaGJcc+p1bI7Hkb9Glt93m0bVrc6QSdpzbaDLdYe+CB/k/5QojX874I8Oty3M2
	OULqYdSEP/7HYjNC7jE0HnDK3vFny8eKFSJ/BHdeOe6vsuyGz/s/y6b71/s07gv6eoyX4ecz
	nz+Om3fJiy95X7Yz/HwFU8Xy++HOO2MiFyle2bMwb9L3K0waOpJKLMUZiYZazEXFiQBAR10q
	pwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wto, 2014-09-16 at 10:20 +0100, Russell King - ARM Linux wrote:
> On Tue, Sep 16, 2014 at 10:51:33AM +0200, Krzysztof Kozlowski wrote:
> > @@ -191,8 +210,11 @@ static int amba_probe(struct device *dev)
> >  		pm_runtime_enable(dev);
> >  
> >  		ret = pcdrv->probe(pcdev, id);
> > -		if (ret == 0)
> > +		if (ret == 0) {
> > +			if (pm_runtime_is_irq_safe(dev))
> > +				pcdev->irq_safe = 1;
> 
> Patch looks good, though I'd prefer this to always explicitly initialise
> pcdev->irq_safe each time a probe succeeds.

No problem, I'll add this and resend.

Thank you for feedback,
Krzysztof

