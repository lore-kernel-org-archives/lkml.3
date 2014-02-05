Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906AbaBEK0m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 05:26:42 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:6597 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbaBEK0j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 05:26:39 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 05 Feb 2014 02:25:10 -0800
From: Jim Lin <jilin@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
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
Date: Wed, 5 Feb 2014 18:26:35 +0800
Subject: RE: [PATCH v3 3/6] misc: fuse: Add efuse driver for Tegra
Thread-Topic: [PATCH v3 3/6] misc: fuse: Add efuse driver for Tegra
Thread-Index: Ac8g6meXCQmLg0wjSrqVkGdY8zlzAgBchuxw
Message-ID: <4B9C9637D5087840A465BDCB251780E9E334916736@HKMAIL02.nvidia.com>
References: <1390952176-30402-1-git-send-email-pdeschrijver@nvidia.com>
 <1390952176-30402-4-git-send-email-pdeschrijver@nvidia.com>
 <1390962378.2398.11.camel@jilin-desktop>
 <20140203141529.GF19389@tbergstrom-lnx.Nvidia.com>
In-Reply-To: <20140203141529.GF19389@tbergstrom-lnx.Nvidia.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-TW, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please ignore my comment.
I will try to use exported tegra_fuse_readl().

-----Original Message-----
From: Peter De Schrijver [mailto:pdeschrijver@nvidia.com] 
Sent: Monday, February 03, 2014 10:15 PM
To: Jim Lin
Cc: linux-arm-kernel@lists.infradead.org; linux-tegra@vger.kernel.org; linux-kernel@vger.kernel.org; Rob Landley; Stephen Warren; Thierry Reding; Grant Likely; Rob Herring; Danny Huang; linux-doc@vger.kernel.org; devicetree@vger.kernel.org
Subject: Re: [PATCH v3 3/6] misc: fuse: Add efuse driver for Tegra

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
> Could we move this fuse.h to other folder under /include/linux (like 
> /include/linux/platform_data) for other driver to include?

I don't think we should expose everything in fuse.h to the world.

> So other driver can invoke function to read fuse data if needed.

Which functionality do you want? Just reading the fuse data exposed in the sysfs file from a driver? exporting tegra_fuse_readl() should do that I think?

Cheers,

Peter.

--nvpublic
