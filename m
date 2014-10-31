Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760763AbaJaOkX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 10:40:23 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:59331 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759301AbaJaOkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 10:40:20 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f4-b7f6c6d00000120b-c9-54539f514db6
Content-transfer-encoding: 8BIT
Message-id: <1414766416.6537.6.camel@AMDC1943>
Subject: Re: [PATCH v8 1/5] PM / Runtime: Add getter for querying the IRQ safe
 option
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Pavel Machek <pavel@ucw.cz>
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
Date: Fri, 31 Oct 2014 15:40:16 +0100
In-reply-to: <20141031142241.GA17547@amd>
References: <1413795888-18559-1-git-send-email-k.kozlowski@samsung.com>
 <1413795888-18559-2-git-send-email-k.kozlowski@samsung.com>
 <1414746895.6797.3.camel@AMDC1943> <20141031142241.GA17547@amd>
X-Mailer: Evolution 3.10.4-0ubuntu2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjkeLIzCtJLcpLzFFi42I5/e/4Vd3A+cEhBuu7TC02zljPavHkQDuj
	xfSpFxgtVk/9y2pxtukNu8WSyfNZLWZN2ctksbBtCYvF5V1z2Cw+9x5htLh9mddi7ZG77Bbv
	XkZY3D11lM3izOlLrBYTfl9gszi+NtziZd9+Fgchj5bmHjaPxXteMnncubYHyOqbzOqx5M0h
	Vo8tV9tZPGbf/cHo0bdlFaPHitXf2T0+b5Lz2Pv5N0sAdxSXTUpqTmZZapG+XQJXxoRZ01kK
	dghUzN6xkbmB8QdPFyMHh4SAicSvX9ZdjJxAppjEhXvr2boYuTiEBJYySpxfs4sNJMErICjx
	Y/I9FpB6ZgF5iSOXskHCzALqEpPmLWKGqP/MKPFiywVWiHo9idUrprCD2MIC4RL3l20Bi7MJ
	GEtsXr4EbKYI0JytfSvAmpkFulklOmbPBkuwCKhK7LvSygRicwpoSvxp3cMIseE4o8S21sVM
	EFcrSzT2u01gFJiF5L5ZCPfNQnLfAkbmVYyiqaXJBcVJ6bmGesWJucWleel6yfm5mxghcfhl
	B+PiY1aHGAU4GJV4eFdIBocIsSaWFVfmHmKU4GBWEuH90QEU4k1JrKxKLcqPLyrNSS0+xMjE
	wSnVwChbFTR1/70C1VCfyBOP5HyN2oqyNjHOUgmtkSxtmhkeXGLtMX/ip4htrXKOm2f28rJf
	mDRl9dlJChxvtKxPVcQxTny/6Vw8j8O0mC8xKsFX9gsUHdow6y9nEu+vuYopT+auSHa/xpq6
	uP5N4t30fR0XMu6d4H31wcuG7dnfDMZ/q89sWuofFafEUpyRaKjFXFScCABIFBvdoQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pią, 2014-10-31 at 15:22 +0100, Pavel Machek wrote:
> On Fri 2014-10-31 10:14:55, Krzysztof Kozlowski wrote:
> > On pon, 2014-10-20 at 11:04 +0200, Krzysztof Kozlowski wrote:
> > > Add a simple getter pm_runtime_is_irq_safe() for querying whether runtime
> > > PM IRQ safe was set or not.
> > > 
> > > Various bus drivers implementing runtime PM may use choose to suspend
> > > differently based on IRQ safeness status of child driver (e.g. do not
> > > unprepare the clock if IRQ safe is not set).
> > > 
> > > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > > Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
> > 
> > Rafael, Len, Pavel,
> > 
> > Is proposed API ok? Do you have any comments?
> > 
> > I'll upload whole patchset to Russell's patch tracking system. However
> > an ack from PM maintainer is probably needed.
> 
> I don't like the API. Having callbacks work in different context (irq
> / noirq) based on what another function reports is ugly.
> 
> What is the penalty if we always decide callbacks are not IRQ safe?

Then pm_runtime_get_sync() could not be called in atomic context. The
pl330 runtime PM would have to be completely reworked because one
pm_runtime_get_sync() is called in device_issue_pending which cannot
sleep (at least in non preemptible kernels). Probably this can be solved
some way... 

Best regards,
Krzysztof


> 
> > > --- a/Documentation/power/runtime_pm.txt
> > > +++ b/Documentation/power/runtime_pm.txt
> > > @@ -468,6 +468,10 @@ drivers/base/power/runtime.c and include/linux/pm_runtime.h:
> > >      - set the power.irq_safe flag for the device, causing the runtime-PM
> > >        callbacks to be invoked with interrupts off
> > >  
> > > +  bool pm_runtime_is_irq_safe(struct device *dev);
> > > +    - return true if power.irq_safe flag was set for the device, causing
> > > +      the runtime-PM callbacks to be invoked with interrupts off
> > > +
> > >    void pm_runtime_mark_last_busy(struct device *dev);
> > >      - set the power.last_busy field to the current time
> > >  

