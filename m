Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161340AbaKNNrT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 08:47:19 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:36440 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161013AbaKNNrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 08:47:16 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f4-b7f6c6d00000120b-12-546607e169e1
Content-transfer-encoding: 8BIT
Message-id: <1415972831.25433.3.camel@AMDC1943>
Subject: Re: [PATCH v12 5/6] dmaengine: pl330: Add PM sleep support
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dmaengine@vger.kernel.org, Kevin Hilman <khilman@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Fri, 14 Nov 2014 14:47:11 +0100
In-reply-to: <CAPDyKFr+DVd0qZ=ra5W-HxHDqauX6ZwBK8S8t_fboJfk_BUTaA@mail.gmail.com>
References: <1415955033-29093-1-git-send-email-k.kozlowski@samsung.com>
 <1415955033-29093-6-git-send-email-k.kozlowski@samsung.com>
 <CAPDyKFr+DVd0qZ=ra5W-HxHDqauX6ZwBK8S8t_fboJfk_BUTaA@mail.gmail.com>
X-Mailer: Evolution 3.10.4-0ubuntu2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPLMWRmVeSWpSXmKPExsVy+t/xy7oP2dNCDI51CllsnLGe1WL61AuM
	Fqun/mW1eLr5MZPF2aY37BadE5ewW8yaspfJ4vKuOWwWn3uPMFrcvsxrsfbIXXaLu6eOslmc
	OX2J1WLC7wtsFsfXhlu87NvP4iDg0dLcw+Yxu2Mmq8fiPS+ZPDat6mTzuHNtD5vHlqvtLB6z
	7/5g9OjbsorRY8Xq7+wenzfJBXBFcdmkpOZklqUW6dslcGXMnfmZrWCNYEX3vAfMDYyneLsY
	OTkkBEwkDl2aywphi0lcuLeerYuRi0NIYCmjxMFDn5lBErwCghI/Jt9j6WLk4GAWkJc4cikb
	JMwsoC4xad4isBIhgc+MEo8vOUGU60ucefyOGaRcWMBZYuGGfJAwm4CxxOblS9hAbBEBDYk9
	D8+zgqxiFpjAKnFu/w+wG1gEVCWeP3zAAmJzCgRLLP64iRXinjOMEv8mN7OCDJUQUJZo7Heb
	wCgwC8l1sxCum4XkugWMzKsYRVNLkwuKk9JzDfWKE3OLS/PS9ZLzczcxQiLtyw7GxcesDjEK
	cDAq8fAaFKSGCLEmlhVX5h5ilOBgVhLh/f4cKMSbklhZlVqUH19UmpNafIiRiYNTqoHRY9WU
	0uCIBem7eTu+VBZ5r9+cY22isPHAMn6Dvf/9TBd8kvhhK/vsneBJFYF7QfYP55hZsG+96MSi
	e1PXnt9lu1uy1I+Ib9xrVDrkWQ0NNh2X+Tvvk1H8b+nI9AqRFbdWv773S5Rj0/4Pi5Ku/6h4
	1btV4t6KSzWx7If/qxvoehYu3rT2kkOfEktxRqKhFnNRcSIAscECepICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pią, 2014-11-14 at 14:31 +0100, Ulf Hansson wrote:
> On 14 November 2014 09:50, Krzysztof Kozlowski <k.kozlowski@samsung.com> wrote:
> > Add system suspend/resume capabilities to the pl330 driver so the amba
> > bus clock could be also unprepared to conserve energy.
> >
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > ---
> >  drivers/dma/pl330.c | 41 +++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 41 insertions(+)
> >
> > diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
> > index c3bd3584f261..e499bb118f0a 100644
> > --- a/drivers/dma/pl330.c
> > +++ b/drivers/dma/pl330.c
> > @@ -2627,6 +2627,46 @@ static int pl330_dma_device_slave_caps(struct dma_chan *dchan,
> >         return 0;
> >  }
> >
> > +/*
> > + * Runtime PM callbacks are provided by amba/bus.c driver.
> > + *
> > + * It is assumed here that IRQ safe runtime PM is chosen in probe and amba
> > + * bus driver will only disable/enable the clock in runtime PM callbacks.
> > + */
> > +static int __maybe_unused pl330_suspend(struct device *dev)
> > +{
> > +       struct amba_device *pcdev = to_amba_device(dev);
> > +
> > +       pm_runtime_disable(dev);
> > +
> > +       if (!pm_runtime_status_suspended(dev)) {
> > +               /* amba did not disable the clock */
> > +               amba_pclk_disable(pcdev);
> > +       }
> > +       amba_pclk_unprepare(pcdev);
> 
> I would also invoke pm_runtime_set_suspended() here, to reflect that's
> the current runtime PM state of the device.

Strictly speaking the device is not runtime suspended in that moment. PM
runtime callbacks were not called. Although the device status looks like
runtime suspended (clocks disabled) but I think the whole goal here was
to avoid touching runtime PM because this is system sleep.


> I guess I sounds like broken record :-), but using
> pm_runtime_force_suspend() would help to prevent some code duplication
> here.
> 
> Something like this:
> 
> pm_runtime_force_suspend()
> if (pm_runtime_is_irq_safe())
>    amba_pclk_unprepare(pcdev);

With !CONFIG_PM_RUNTIME this would leave clocks prepared...

Thanks for feedback!
Best regards,
Krzysztof



