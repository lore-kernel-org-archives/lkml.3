Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212Ab3AKO6J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 09:58:09 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:48245 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754926Ab3AKO6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 09:58:06 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] spi: Add the flag indicate to registe new device as children of master or not.
To: Jun Chen <jun.d.chen@intel.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Bi Chao <chao.bi@intel.com>,
        spi-devel-general@lists.sourceforge.net, jun.zhang@intel.com
In-Reply-To: <1356365812.6818.24.camel@chenjun-workstation>
References: <1355848174.1435.25.camel@chenjun-workstation> <20121218152623.GA26077@sirena.org.uk> <1355910243.1435.39.camel@chenjun-workstation> <20121219090416.GK4985@opensource.wolfsonmicro.com> <20121219162142.9E1123E0B72@localhost> <1356111592.731.4.camel@chenjun-workstation> <20121221190618.6D6D03E0C98@localhost> <1356365812.6818.24.camel@chenjun-workstation>
Date: Fri, 11 Jan 2013 14:57:54 +0000
Message-Id: <20130111145754.76BB53E08C3@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Dec 2012 11:16:52 -0500, Jun Chen <jun.d.chen@intel.com> wrote:
> On Fri, 2012-12-21 at 19:06 +0000, Grant Likely wrote:
> > The problem is that I don't understand why this change is necessary.
> > spi_devices should always be children of an spi_master, not siblings.
> > What is the problem you're trying to solve with this change?
> > 
> When spi drivers try to use the core function(spi_register_master),it
> will trigger error,because they use the function
> spi_match_master_to_boardinfo  to create new spi device as the children
> of the master.
> In the old version of spi core, the new devices are registered as
> siblings of the spi_master. My spi driver based on the old version runs
> normal.
> 
> But after applying for this patch:
> {
>     spi: Fix device unregistration when unregistering the bus master
>     
>     Device are added as children of the bus master's parent device, but
>     spi_unregister_master() looks for devices to unregister in the bus
>     master's children. This results in the child devices not being
>     unregistered.
>     
>     Fix this by registering devices as direct children of the bus
> master.
> 
> 
> -	spi->dev.parent = dev;
> +	spi->dev.parent = &master->dev;
> }
> 
> Then my driver will be crash.
> Maybe I have mistake on this issue, thank for your more explanation and
> detail replay. 

Sounds like you've got a driver bug. Make sure it isn't trying to use
the spi_client parent pointer to find the device instance.

g.

