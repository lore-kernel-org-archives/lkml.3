Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760121Ab3DZLD4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 07:03:56 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39264 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265Ab3DZLDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 07:03:55 -0400
Date: Fri, 26 Apr 2013 12:03:34 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: Eduardo Valentin <eduardo.valentin@ti.com>,
        Zhang Rui <rui.zhang@intel.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Hongbo Zhang <hongbo.zhang@stericsson.com>,
        devicetree-discuss@lists.ozlabs.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 2/2] thermal: db8500_cpufreq_cooling: remove usage of
	IS_ERR_OR_NULL()
Message-ID: <20130426110334.GB4862@flint.arm.linux.org.uk>
References: <1366899214-22639-1-git-send-email-eduardo.valentin@ti.com> <1366899214-22639-3-git-send-email-eduardo.valentin@ti.com> <20130425174635.GB25783@flint.arm.linux.org.uk> <20130426101908.GA23032@balto.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130426101908.GA23032@balto.lan>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 26, 2013 at 12:19:08PM +0200, Fabio Baltieri wrote:
> On Thu, Apr 25, 2013 at 06:46:35PM +0100, Russell King wrote:
> > On Thu, Apr 25, 2013 at 10:13:34AM -0400, Eduardo Valentin wrote:
> > > diff --git a/drivers/thermal/db8500_cpufreq_cooling.c b/drivers/thermal/db8500_cpufreq_cooling.c
> > > index 21419851..786d192 100644
> > > --- a/drivers/thermal/db8500_cpufreq_cooling.c
> > > +++ b/drivers/thermal/db8500_cpufreq_cooling.c
> > > @@ -37,7 +37,7 @@ static int db8500_cpufreq_cooling_probe(struct platform_device *pdev)
> > >  	cpumask_set_cpu(0, &mask_val);
> > >  	cdev = cpufreq_cooling_register(&mask_val);
> > >  
> > > -	if (IS_ERR_OR_NULL(cdev)) {
> > > +	if (IS_ERR(cdev)) {
> > >  		dev_err(&pdev->dev, "Failed to register cooling device\n");
> > >  		return PTR_ERR(cdev);
> > 
> > Correct.  cpufreq_cooling_register() returns either an error-pointer or
> > a valid pointer.
> 
> Acked-by: Fabio Baltieri <fabio.baltieri@linaro.org>
> 
> ...but more of these are going to appear forever, was the proposed
> removal of IS_ERR_OR_NULL rejected?  Can't find any new message about
> that on the list.

We first need to get rid of the existing users of it - I've got rid of
most of those in arch/arm - but it seems that I never pushed that in the
last merge window.

Really it needs the cooperation of everyone to make it happen across the
tree with everyone removing IS_ERR_OR_NULL() in their subsystem.  There
are currently 366 instances of this macro being used in the entire tree
which is far too many to even mark it as deprecated.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
