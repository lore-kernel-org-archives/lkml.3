Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752268AbaBCOPg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 09:15:36 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:17891 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbaBCOPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 09:15:33 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 03 Feb 2014 06:14:10 -0800
Date: Mon, 3 Feb 2014 16:15:29 +0200
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Jim Lin <jilin@nvidia.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Landley <rob@landley.net>, Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "Grant Likely" <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, "Danny Huang" <dahuang@nvidia.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v3 3/6] misc: fuse: Add efuse driver for Tegra
Message-ID: <20140203141529.GF19389@tbergstrom-lnx.Nvidia.com>
References: <1390952176-30402-1-git-send-email-pdeschrijver@nvidia.com>
 <1390952176-30402-4-git-send-email-pdeschrijver@nvidia.com>
 <1390962378.2398.11.camel@jilin-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1390962378.2398.11.camel@jilin-desktop>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 29, 2014 at 03:26:18AM +0100, Jim Lin wrote:
> On Wed, 2014-01-29 at 07:36 +0800, Peter De Schrijver wrote:
> > Implement fuse driver for Tegra20, Tegra30, Tegra114 and Tegra124.
> > 
> > Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
> > ---
> >  Documentation/ABI/testing/sysfs-driver-tegra-fuse |    8 +
> >  drivers/misc/fuse/Makefile                        |    1 +
> >  drivers/misc/fuse/tegra/Makefile                  |    7 +
> >  drivers/misc/fuse/tegra/fuse-tegra.c              |  228 ++++++++++++++++
> >  drivers/misc/fuse/tegra/fuse-tegra20.c            |  136 ++++++++++
> >  drivers/misc/fuse/tegra/fuse-tegra30.c            |  178 +++++++++++++
> >  drivers/misc/fuse/tegra/fuse.h                    |   82 ++++++
> Could we move this fuse.h to other folder under /include/linux
> (like /include/linux/platform_data)
> for other driver to include?

I don't think we should expose everything in fuse.h to the world.

> So other driver can invoke function to read fuse data if needed.

Which functionality do you want? Just reading the fuse data exposed in
the sysfs file from a driver? exporting tegra_fuse_readl() should do
that I think?

Cheers,

Peter.
