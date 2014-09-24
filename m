Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040AbaIXKJc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 06:09:32 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:46043 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbaIXKJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 06:09:28 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f4-b7f156d0000063c7-ee-542298557a91
Content-transfer-encoding: 8BIT
Message-id: <1411553363.9968.0.camel@AMDC1943>
Subject: Re: [PATCH v4 4/4] dma: pl330: add Power Management support
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dmaengine@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <michal.simek@xilinx.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Randy Dunlap <rdunlap@infradead.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Wed, 24 Sep 2014 12:09:23 +0200
In-reply-to: <CAPDyKFoaP74t7ZWM66=jDgRcY-9FBM1OxMiZKL++HAO1m19DWg@mail.gmail.com>
References: <1410857494-15936-1-git-send-email-k.kozlowski@samsung.com>
 <1410857494-15936-5-git-send-email-k.kozlowski@samsung.com>
 <CAPDyKFqoLQh=FYg33LTSp-HTs-oJDT4y_K6hGRoiu9zDxOX9sw@mail.gmail.com>
 <1411034996.23919.9.camel@AMDC1943>
 <CAPDyKFoaP74t7ZWM66=jDgRcY-9FBM1OxMiZKL++HAO1m19DWg@mail.gmail.com>
X-Mailer: Evolution 3.10.4-0ubuntu2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRmVeSWpSXmKPExsVy+t/xq7qhM5RCDKZ/UrbYOGM9q8X0qRcY
	LVZP/ctqceDPDkaLs01v2C2WTJ7PajFryl4mi4VtS1gsLu+aw2bxufcIo8Xty7wWa4/cZbd4
	9zLC4u6po2wWb+9MZ7E4c/oSq8WE3xfYLI6vDbd42befxUHYo6W5h81j8wotj8V7XjJ53Lm2
	h81jyZtDrB5brrazeMy++4PRo2/LKkaPFau/s3t83iTnsffzb5YA7igum5TUnMyy1CJ9uwSu
	jGOLTrAXPFeoeL9mBmMD42+JLkZODgkBE4kVVy+xQdhiEhfurQeyuTiEBJYySrw6/oQZJMEr
	ICjxY/I9li5GDg5mAXmJI5eyQcLMAuoSk+YtYoao/8wo0TX/EBNEvZ7E1+f/2EFsYQEXiT9b
	b7GC2GwCxhKbly8BWyYioCGx5+F5VpBmZoEJbBJPd8wFK2IRUJVYtHYvWDOnQLDEnoZJTBAb
	djJJTJv0mhnkCgkBZYnGfrcJjAKzkNw3C+G+WUjuW8DIvIpRNLU0uaA4KT3XUK84Mbe4NC9d
	Lzk/dxMjJCK/7GBcfMzqEKMAB6MSD+8EcaUQIdbEsuLK3EOMEhzMSiK8r3qAQrwpiZVVqUX5
	8UWlOanFhxiZODilGhindW7NEVj9+eGiiVvfVU7M2XS/ZP6lZ8c8VTx6BPT0XXg50v89t75s
	Zar+iPnU7p86kWqvD/qf79r4kP/jrE1F4ncnLT42R8W0L9SytjvP8GeymfL/o2HbD/Fm3j1U
	nHT6uMTR3NPKm81y1Tlz9pgvWhyduOvAhViJ3kSv6Qui8w22TN+b+lxDiaU4I9FQi7moOBEA
	BsFrKKYCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wto, 2014-09-23 at 17:39 +0200, Ulf Hansson wrote:
> On 18 September 2014 12:09, Krzysztof Kozlowski <k.kozlowski@samsung.com> wrote:
> > On śro, 2014-09-17 at 20:42 +0200, Ulf Hansson wrote:
> >> On 16 September 2014 10:51, Krzysztof Kozlowski <k.kozlowski@samsung.com> wrote:
> >
> > [...]
> >
> >> >
> >> > @@ -2585,6 +2620,34 @@ static int pl330_dma_device_slave_caps(struct dma_chan *dchan,
> >> >         return 0;
> >> >  }
> >> >
> >> > +/*
> >> > + * Assume that IRQ safe runtime PM is chosen in probe and amba bus driver
> >> > + * will only disable/enable the clock in runtime PM suspend/resume.
> >> > + */
> >> > +static int __maybe_unused pl330_suspend(struct device *dev)
> >> > +{
> >> > +       struct amba_device *pcdev = to_amba_device(dev);
> >> > +
> >> > +       if (!pm_runtime_suspended(dev))
> >> > +               amba_pclk_disable(pcdev);
> >>
> >> I would suggest to use pm_runtime_force_suspend() instead of the above.
> >
> > Sure, I can change it but... (see below)
> >
> >>
> >> > +       amba_pclk_unprepare(pcdev);
> >> > +
> >> > +       return 0;
> >> > +}
> >> > +
> >> > +static int __maybe_unused pl330_resume(struct device *dev)
> >> > +{
> >> > +       struct amba_device *pcdev = to_amba_device(dev);
> >> > +
> >> > +       amba_pclk_prepare(pcdev);
> >> > +       if (!pm_runtime_suspended(dev))
> >> > +               return amba_pclk_enable(pcdev);
> >>
> >> The above if statement could be replaced with pm_runtime_force_resume().
> >
> > But that would lead to runtime resuming the device even when it is not
> > needed. We don't have to fully wakeup the device during resume operation
> > when the device was runtime suspended before suspend.
> 
> That's true - but that's not a big issue I believe. I think the below
> problems are worse. :-)
> 
> 1) You don't disable runtime PM, thus not preventing the runtime PM
> callbacks from being invoked.
> 2) You don't update the runtime PM status, thus not reflecting the
> actual state of the device.
> 
> Both the above may cause unbalanced clk_enable|disable calls.
> 
> Don't get me wrong, I certainly think the "don't do runtime PM resume
> during system PM resume" is interesting to solve. But that it's a
> common problem and should be supported by the runtime PM API somehow
> instead. I have been thinking of extending the
> pm_runtime_force_resume() API to support this, let's see when that
> happens. :-)

OK, I get the point. I'll fix this.


> >
> >>
> >> Doing that, means the amba_pclk_enable|disable() don't need to be
> >> exported from the AMBA bus header, but entirely handled by the AMBA
> >> bus itself.
> >>
> >> > +
> >> > +       return 0;
> >> > +}
> >> > +
> >> > +static SIMPLE_DEV_PM_OPS(pl330_pm, pl330_suspend, pl330_resume);
> >> > +
> >> >  static int
> >> >  pl330_probe(struct amba_device *adev, const struct amba_id *id)
> >> >  {
> >> > @@ -2738,6 +2801,9 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
> >> >                 pcfg->data_buf_dep, pcfg->data_bus_width / 8, pcfg->num_chan,
> >> >                 pcfg->num_peri, pcfg->num_events);
> >> >
> >>
> >> You need pm_runtime_set_active() here as well.
> >
> > This is done by amba/bus.c. Do I have to do it again?
> 
> Ohh, you are right! No need to add it!
> 
> >
> >>
> >> > +       pm_runtime_irq_safe(&adev->dev);
> >> > +       pm_runtime_put_noidle(&adev->dev);
> >>
> >> Why pm_runtime_put_noidle(), that seems like you might end up leaving
> >> the device in active state - unless you get some request. Likely not
> >> what you want?
> >
> > Hmmm... I am sorry but I do not get the point here. It could be
> > pm_runtime_put() as well because initially we start with counter
> > incremented by amba/bus.c.
> 
> The "no_idle" version will prevent the device from going inactive,
> unless a new cycle of pm_runtime_get() to pm_runtime_put() happens,
> which there are no guarantees of.

Right.

Thanks for reviewing the code. I'll send the next version removing also
the amba_pclk_enable|disable() macros.

Best regards,
Krzysztof

> 
> Kind regards
> Uffe

