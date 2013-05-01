Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751755Ab3EAQv5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 12:51:57 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:46538 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752025Ab3EAQvt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 12:51:49 -0400
Date: Wed, 1 May 2013 11:51:36 -0500
From: Nishanth Menon <nm@ti.com>
To: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Rob Landley <rob@landley.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Shawn Guo <shawn.guo@linaro.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH 2/2] PM / OPP: check for existing OPP list when
 initialising from device tree
Message-ID: <20130501165136.GB21171@kahuna>
References: <1367406679-21603-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
 <1367406679-21603-3-git-send-email-Sudeep.KarkadaNagesha@arm.com>
 <20130501150403.GA20488@kahuna>
 <518143EF.3010900@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <518143EF.3010900@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17:33-20130501, Sudeep KarkadaNagesha wrote:
> On 01/05/13 16:04, Nishanth Menon wrote:
> > On 12:11-20130501, Sudeep.KarkadaNagesha@arm.com wrote:
> >> From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
[...]
> >> diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
> >> index 4dfdc01..66d52d2 100644
> >> --- a/drivers/base/power/opp.c
> >> +++ b/drivers/base/power/opp.c
> >> @@ -706,6 +706,11 @@ static int of_init_opp_table_from_ofnode(struct device *dev,
> >>  	const __be32 *val;
> >>  	int nr;
> >>  
> >> +	/* Check for existing list for 'dev' */
> >> +	dev_opp = find_device_opp(dev);
> >> +	if (!IS_ERR(dev_opp))
> >> +		return 0; /* Device OPP already initialized */
> >> +
> > It gets a little touchy here -> the normal expectation is for the OPP
> > entries to be populated onetime at boot.
> > For example - driver bug where same device was attempted twice Vs the
> > usecase you mention here - how'd we differentiate between the two?
> 
> Do we really need to differentiate ? How about returning -EEXIST ?
We have tried to provide enough debug information for developers to
detect and fix their mistakes, error value is one part of the story for
callers, error messages emphasis on top of it for the developer.. But,
for some reason I might be led to believe probe and hotplug are separate
usecases - probe of a device indicates it's presence, and hotplug of a
device should ideally be a power state.. But that is just me.
-- 
Regards,
Nishanth Menon
