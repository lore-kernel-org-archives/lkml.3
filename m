Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758764AbaCSJJZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 05:09:25 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41688 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757308AbaCSJJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 05:09:23 -0400
Date: Wed, 19 Mar 2014 09:09:20 +0000
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@kernel.org>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        sameo@linux.intel.com, lee.jones@linaro.org, lgirdwood@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] regulator: arizona-ldo1: Move setup processing
	from arizona-core
Message-ID: <20140319090920.GE1665@opensource.wolfsonmicro.com>
References: <1395163353-1608-1-git-send-email-ckeepax@opensource.wolfsonmicro.com> <1395163353-1608-4-git-send-email-ckeepax@opensource.wolfsonmicro.com> <20140318174430.GI11706@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140318174430.GI11706@sirena.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2014 at 05:44:30PM +0000, Mark Brown wrote:
> On Tue, Mar 18, 2014 at 05:22:31PM +0000, Charles Keepax wrote:
> 
> > -	/*
> > -	 * LDO1 can only be used to supply DCVDD so if it has no
> > -	 * consumers then DCVDD is supplied externally.
> > -	 */
> > -	if (arizona->pdata.ldo1 &&
> > -	    arizona->pdata.ldo1->num_consumer_supplies == 0)
> > -		arizona->external_dcvdd = true;
> > -
> 
> Actually now that I look at this again one issue here - the reason this
> is in the core is that if the system is using an external DCVDD it may
> not be building the regulator driver at all (it won't do anything at
> runtime) so the flag would never get set if it's done by the regulator
> driver.

Ah... missed that. I will respin again.

Thanks,
Charles

