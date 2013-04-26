Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759428Ab3DZKT0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 06:19:26 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:40131 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758949Ab3DZKTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 06:19:22 -0400
Date: Fri, 26 Apr 2013 12:19:08 +0200
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Russell King <rmk@arm.linux.org.uk>
Cc: Eduardo Valentin <eduardo.valentin@ti.com>,
        Zhang Rui <rui.zhang@intel.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Hongbo Zhang <hongbo.zhang@stericsson.com>,
        devicetree-discuss@lists.ozlabs.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 2/2] thermal: db8500_cpufreq_cooling: remove usage of
 IS_ERR_OR_NULL()
Message-ID: <20130426101908.GA23032@balto.lan>
References: <1366899214-22639-1-git-send-email-eduardo.valentin@ti.com>
 <1366899214-22639-3-git-send-email-eduardo.valentin@ti.com>
 <20130425174635.GB25783@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130425174635.GB25783@flint.arm.linux.org.uk>
X-Operating-System: Linux balto 3.9.0-rc8 x86_64 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 25, 2013 at 06:46:35PM +0100, Russell King wrote:
> On Thu, Apr 25, 2013 at 10:13:34AM -0400, Eduardo Valentin wrote:
> > diff --git a/drivers/thermal/db8500_cpufreq_cooling.c b/drivers/thermal/db8500_cpufreq_cooling.c
> > index 21419851..786d192 100644
> > --- a/drivers/thermal/db8500_cpufreq_cooling.c
> > +++ b/drivers/thermal/db8500_cpufreq_cooling.c
> > @@ -37,7 +37,7 @@ static int db8500_cpufreq_cooling_probe(struct platform_device *pdev)
> >  	cpumask_set_cpu(0, &mask_val);
> >  	cdev = cpufreq_cooling_register(&mask_val);
> >  
> > -	if (IS_ERR_OR_NULL(cdev)) {
> > +	if (IS_ERR(cdev)) {
> >  		dev_err(&pdev->dev, "Failed to register cooling device\n");
> >  		return PTR_ERR(cdev);
> 
> Correct.  cpufreq_cooling_register() returns either an error-pointer or
> a valid pointer.

Acked-by: Fabio Baltieri <fabio.baltieri@linaro.org>

...but more of these are going to appear forever, was the proposed
removal of IS_ERR_OR_NULL rejected?  Can't find any new message about
that on the list.

Fabio

-- 
Fabio Baltieri
