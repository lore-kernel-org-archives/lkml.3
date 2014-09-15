Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511AbaIOPLj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 11:11:39 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:37676 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564AbaIOPLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 11:11:37 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-5b-541701a641df
Message-id: <1410793893.883.4.camel@AMDC1943>
Subject: Re: [PATCH v3 1/4] PM / Runtime: Add getter for quering the IRQ safe
 option
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <michal.simek@xilinx.com>, linux-pm@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Mon, 15 Sep 2014 17:11:33 +0200
In-reply-to: <Pine.LNX.4.44L0.1409151056170.1360-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1409151056170.1360-100000@iolanthe.rowland.org>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDLMWRmVeSWpSXmKPExsVy+t/xy7rLGMVDDF6807fYOGM9q8X0qRcY
	LVZP/ctqceDPDkaLs01v2C2WTJ7PanF51xw2i8+9Rxgtbl/mtVh75C67xbuXERYTfl9gszi+
	NtziZd9+Fgc+j5bmHjaPxXteMnncubaHzWPJm0OsHrPv/mD06NuyitHj8yY5j72ff7MEcERx
	2aSk5mSWpRbp2yVwZUz//oS9YC9XxfHjc9gaGDdwdDFyckgImEhM/XyBDcIWk7hwbz2QzcUh
	JLCUUaL9xCEmCOczo8SJb6fBqngFdCW+393KAmILC4RJrD/cC2azCRhLbF6+BKxGREBLYnPT
	S2aQZmaBBhaJLxumsIMkWARUJVZcvQnWwCngK/F5zimgDRxAG3wkTnyMBwkzC6hLTJq3iBkk
	LCGgLNHY7waxVlDix+R7LBAl8hKb17xlnsAoMAtJxywkZbOQlC1gZF7FKJpamlxQnJSea6hX
	nJhbXJqXrpecn7uJERJDX3YwLj5mdYhRgINRiYd34Q6xECHWxLLiytxDjBIczEoivLy/gEK8
	KYmVValF+fFFpTmpxYcYmTg4pRoYmTYtnbvB3ZXpf7fhExmji629B1aE+O7Y9a6/8PPf5+uX
	X3f7v9zUpe9rZdACUcnixQYvNr1OeRx/Yw9n6dKaVJe5CQKv7zEfcq688q3C/tAxm8WPRb0T
	NQyfinSmM25P0rB79GvVlkm7Fhw0qv3sMfPM8aAKNW3Buhfnhbaf2NZ45ffePbWxrUosxRmJ
	hlrMRcWJAFtOWgp/AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pon, 2014-09-15 at 10:57 -0400, Alan Stern wrote:
> On Mon, 15 Sep 2014, Krzysztof Kozlowski wrote:
> 
> > Add a simple getter pm_runtime_is_irq_safe() for quering whether runtime
> > PM IRQ safe was set or not.
> > 
> > Various bus drivers implementing runtime PM may use choose to suspend
> > differently based on IRQ safeness status of child driver (e.g. do not
> > unprepare the clock if IRQ safe is not set).
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > ---
> >  include/linux/pm_runtime.h | 6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/include/linux/pm_runtime.h b/include/linux/pm_runtime.h
> > index 367f49b9a1c9..44d74f0f182e 100644
> > --- a/include/linux/pm_runtime.h
> > +++ b/include/linux/pm_runtime.h
> > @@ -128,6 +128,11 @@ static inline void pm_runtime_mark_last_busy(struct device *dev)
> >  	ACCESS_ONCE(dev->power.last_busy) = jiffies;
> >  }
> >  
> > +static inline bool pm_runtime_is_irq_safe(struct device *dev)
> > +{
> > +	return dev->power.irq_safe;
> > +}
> > +
> 
> If you add something to the runtime PM API, you must update the 
> documentation file (Documentation/power/runtime_pm.txt) 
> correspondingly.


Thank you for pointing this out. I'll fix this and re-spin.

Best regards,
Krzysztof

> 
> Alan Stern

