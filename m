Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886AbaHUQIc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 12:08:32 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:49400 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641AbaHUQIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 12:08:30 -0400
Date: Thu, 21 Aug 2014 12:08:22 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Mikko Perttunen <mperttunen@nvidia.com>, rui.zhang@intel.com,
        thierry.reding@gmail.com, linux-pm@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 4/4] thermal: Add Tegra SOCTHERM thermal management
 driver
Message-ID: <20140821160821.GC17621@developer>
References: <1407320706-17440-1-git-send-email-mperttunen@nvidia.com>
 <1407320706-17440-5-git-send-email-mperttunen@nvidia.com>
 <53F4FC18.90804@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53F4FC18.90804@wwwdotorg.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Stephen,

On Wed, Aug 20, 2014 at 01:50:48PM -0600, Stephen Warren wrote:
> On 08/06/2014 04:25 AM, Mikko Perttunen wrote:
> > This adds support for the Tegra SOCTHERM thermal sensing and management
> > system found in the Tegra124 system-on-chip. This initial driver supports
> > temperature polling for four thermal zones.
> 
> Since both the Tegra DT patches and this driver all rely on a new header 
> added by patch 1/4, I guess this whole series needs to be applied in one 
> branch. I think it makes sense to apply it to the Tegra since it's 
> likely to have more conflicts there and fewer in the thermal 
> maintainer's tree. It can be applied in a topic branch that can be 
> merged into the thermal maintainer's tree if required to resolve 
> conflicts there.

I agree with you here. The conflicts on thermal side should be mostly on
Kconfigs and Makefiles. But the device tree part should not be hard to
deal with too though.

> 
> Rui, Eduardo, do you agree?

Once we get it properly reviewed and acked, then I am not against it
going via tegra tree, no.

Cheers,

> 
> > diff --git a/drivers/thermal/tegra_soctherm.c b/drivers/thermal/tegra_soctherm.c
> 
> > +static struct of_device_id tegra_soctherm_of_match[] = {
> > +	{ .compatible = "nvidia,tegra124-soctherm" },
> > +	{ },
> > +};
> > +MODULE_DEVICE_TABLE(of, tegra_soctherm_of_match);
> > +
> > +static int thermctl_temp_offsets[] = {
> > +	SENSOR_TEMP1, SENSOR_TEMP2, SENSOR_TEMP1, SENSOR_TEMP2
> > +};
> > +
> > +static int thermctl_temp_shifts[] = {
> > +	16, 16, 0, 0
> > +};
> 
> Can any/all of those be const?
> 
> I don't pretend to know anything about the soctherm HW, but I see no 
> gross issues in the code structure, so,
> Acked-by: Stephen Warren <swarren@nvidia.com>
