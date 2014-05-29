Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933050AbaE2HU2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 03:20:28 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:9255 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932421AbaE2HUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 03:20:24 -0400
X-IronPort-AV: E=Sophos;i="4.98,932,1392159600"; 
   d="scan'208";a="76949224"
Date: Thu, 29 May 2014 09:20:20 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: Himangi Saraogi <himangi774@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: touchscreen : Introduce the use of the managed
 version of kzalloc
In-Reply-To: <20140529071510.GF11817@core.coreip.homeip.net>
Message-ID: <alpine.DEB.2.02.1405290919110.1996@localhost6.localdomain6>
References: <20140528180214.GA5957@himangi-Dell> <20140529071510.GF11817@core.coreip.homeip.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > @@ -618,39 +619,22 @@ static int mrstouch_probe(struct platform_device *pdev)
> >  	input_set_abs_params(tsdev->input, ABS_PRESSURE,
> >  			     MRST_PRESSURE_MIN, MRST_PRESSURE_MAX, 0, 0);
> >  
> > -	err = request_threaded_irq(tsdev->irq, NULL, mrstouch_pendet_irq,
> > -				   IRQF_ONESHOT, "mrstouch", tsdev);
> > +	err = devm_request_threaded_irq(&pdev->dev, tsdev->irq, NULL,
> > +					mrstouch_pendet_irq, IRQF_ONESHOT,
> > +					"mrstouch", tsdev);
> >  	if (err) {
> >  		dev_err(tsdev->dev, "unable to allocate irq\n");
> > -		goto err_free_mem;
> > +		return -ENOMEM;
> 
> This is bad conversion. We used to report 'err' returned by
> request_threaded_irq, but now we always report -ENOMEM. I fixed it up
> here and in other places and applied.

Sorry to have missed that.  I guess you got the one on the call to 
mrstouch_adc_init as well?

thanks,
julia
