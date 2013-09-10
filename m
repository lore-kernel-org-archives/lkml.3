Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226Ab3IJSHw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 14:07:52 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:55082 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065Ab3IJSHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 14:07:51 -0400
Date: Tue, 10 Sep 2013 11:07:47 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Mark Brown <broonie@kernel.org>, Wei Ni <wni@nvidia.com>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] hwmon: (lm90) Add power control
Message-ID: <20130910180747.GA8164@roeck-us.net>
References: <20130909155043.GA18975@roeck-us.net>
 <522E9059.3070305@nvidia.com>
 <522E93D6.2010304@roeck-us.net>
 <522E94AE.7000804@wwwdotorg.org>
 <522E97CE.4070300@roeck-us.net>
 <522E9C84.9070405@wwwdotorg.org>
 <20130910100939.GW29403@sirena.org.uk>
 <522F35BF.6070909@wwwdotorg.org>
 <20130910170438.GS29403@sirena.org.uk>
 <522F5A65.8040907@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <522F5A65.8040907@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 11:44:05AM -0600, Stephen Warren wrote:
> On 09/10/2013 11:04 AM, Mark Brown wrote:
> > On Tue, Sep 10, 2013 at 09:07:43AM -0600, Stephen Warren wrote:
> >> On 09/10/2013 04:09 AM, Mark Brown wrote:
> > 
> >>> No.  There are a couple of issues here.  One is that we don't want
> >>> to litter all drivers with conditional code to check if they
> >>> actually got the regulator and so on, that's just pointless make
> >>> work on the part of consumers.
> > 
> >> So that's exactly the difference between (a) and (b) above.
> > 
> > Right, but the idea is that we just only ignore a failure to get a
> > supply if we can usefully run without that supply being present and
> > there's more code there than simply ignoring the error - if the driver
> > can genuinely just ignore all errors and otherwise not do anything
> > different then requesting the regulator in the first place is clearly a
> > waste of time and enabling it would be a waste of power.
> > 
> > A driver should only be carrying code for a missing regulator if it can
> > usefully work without it, like the cases where devices can use an
> > internal reference if one is not available.
> 
> OK, so I believe you're saying that the case of a chip with just a
> single power source, which absolutely must be present in HW for the chip
> to be powered, isn't appropriate for regulator_get_optional(). Something
> must always define a regulator for that power source, even if there is
> no external SW control over that power source.
> 
I think you are supposed to use a dummy regulator in that case.

Guenter

> If so, how does a driver (or binding) that's been written without any
> support for a regulator (since so far all boards have had no SW control
> over that power source; it's always on) get enhanced to support boards
> where there is SW control over the power source?
> 
> We either allow the regulator to be optional (since SW control over the
> regulator is optional), or go back to every board file and DT and add a
> dummy regulator in (which then breaks DT ABI, and even ignoring that is
> a pain).
> 
> And note that when I say "optional" at the start of the previous
> paragraph, I'm talking about probe-time regulator_get() operations and
> DT content. Clearly as far as the rest of the driver is concerned,
> something can always provide a dummy regulator so that e.g.
> regulator_enable/disable() elsewhere  always have something to operate
> on. However, probe() either needs to call an API that automatically
> provides such a dummy regulator, or open-code that itself. I'm still not
> clear which option you think should be used.
> 
