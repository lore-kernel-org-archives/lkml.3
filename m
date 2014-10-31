Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760030AbaJaOWs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 10:22:48 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57423 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759435AbaJaOWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 10:22:44 -0400
Date: Fri, 31 Oct 2014 15:22:41 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-pm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <michal.simek@xilinx.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v8 1/5] PM / Runtime: Add getter for querying the IRQ
 safe option
Message-ID: <20141031142241.GA17547@amd>
References: <1413795888-18559-1-git-send-email-k.kozlowski@samsung.com>
 <1413795888-18559-2-git-send-email-k.kozlowski@samsung.com>
 <1414746895.6797.3.camel@AMDC1943>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414746895.6797.3.camel@AMDC1943>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2014-10-31 10:14:55, Krzysztof Kozlowski wrote:
> On pon, 2014-10-20 at 11:04 +0200, Krzysztof Kozlowski wrote:
> > Add a simple getter pm_runtime_is_irq_safe() for querying whether runtime
> > PM IRQ safe was set or not.
> > 
> > Various bus drivers implementing runtime PM may use choose to suspend
> > differently based on IRQ safeness status of child driver (e.g. do not
> > unprepare the clock if IRQ safe is not set).
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
> 
> Rafael, Len, Pavel,
> 
> Is proposed API ok? Do you have any comments?
> 
> I'll upload whole patchset to Russell's patch tracking system. However
> an ack from PM maintainer is probably needed.

I don't like the API. Having callbacks work in different context (irq
/ noirq) based on what another function reports is ugly.

What is the penalty if we always decide callbacks are not IRQ safe?
								Pavel

> > --- a/Documentation/power/runtime_pm.txt
> > +++ b/Documentation/power/runtime_pm.txt
> > @@ -468,6 +468,10 @@ drivers/base/power/runtime.c and include/linux/pm_runtime.h:
> >      - set the power.irq_safe flag for the device, causing the runtime-PM
> >        callbacks to be invoked with interrupts off
> >  
> > +  bool pm_runtime_is_irq_safe(struct device *dev);
> > +    - return true if power.irq_safe flag was set for the device, causing
> > +      the runtime-PM callbacks to be invoked with interrupts off
> > +
> >    void pm_runtime_mark_last_busy(struct device *dev);
> >      - set the power.last_busy field to the current time
> >  
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
