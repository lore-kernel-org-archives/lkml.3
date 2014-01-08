Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443AbaAHIb6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 03:31:58 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:8437 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755033AbaAHIbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 03:31:48 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 08 Jan 2014 00:32:12 -0800
Date: Wed, 8 Jan 2014 10:31:33 +0200
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thierry Reding <thierry.reding@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        "Alex Courbot" <acourbot@nvidia.com>, Olof Johansson <olof@lixom.net>,
        Danny Huang <dahuang@nvidia.com>
Subject: Re: [PATCH v2 4/6] ARM: tegra: rework fuse.c
Message-ID: <20140108083133.GK26588@tbergstrom-lnx.Nvidia.com>
References: <1387891931-9854-1-git-send-email-pdeschrijver@nvidia.com>
 <1387891931-9854-5-git-send-email-pdeschrijver@nvidia.com>
 <52CB1722.70306@wwwdotorg.org>
 <20140107141004.GF26588@tbergstrom-lnx.Nvidia.com>
 <52CC67C9.9000704@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <52CC67C9.9000704@wwwdotorg.org>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 09:47:05PM +0100, Stephen Warren wrote:
> On 01/07/2014 07:10 AM, Peter De Schrijver wrote:
> > On Mon, Jan 06, 2014 at 09:50:42PM +0100, Stephen Warren wrote:
> >> On 12/24/2013 06:32 AM, Peter De Schrijver wrote:
> >>> Reduce fuse.c to the minimum functionality required for the early bootstages.
> >>>
> >>> Also export tegra_read_straps() for use by the fuse driver.
> 
> >>> diff --git a/arch/arm/mach-tegra/fuse.c b/arch/arm/mach-tegra/fuse.c
> 
> >>> -int tegra_sku_id;
> >>> -int tegra_cpu_process_id;
> >>> -int tegra_core_process_id;
> >>>  int tegra_chip_id;
> >>> -int tegra_cpu_speedo_id;		/* only exist in Tegra30 and later */
> >>> -int tegra_soc_speedo_id;
> >>>  enum tegra_revision tegra_revision;
> >>
> >> It's a bit odd to remove most of this, but leave a few parts hanging
> >> around. Wouldn't it be better to the drivers/misc/fuse code to export
> >> this, so that /all/ the fuse logic was there, rather than part of it
> >> being left over in arch/arm/? We'll need to fix that up anyway when we
> >> start using these globals on ARMv8, so may as well get it right now.
> >> Also, I rather think that the new drivers/misc/fuse code shouldn't be a
> >> module or driver, so that we can guarantee it's always there to provide
> >> the globals and that they are initialized early enough...
> > 
> > tegra_revision is used in tegra_dt_init() to initialize soc_dev_attr->revision
> > Hence this needs to be available before the fuse driver is initialized.
> 
> Yes, the same for tegra_chip_id too.
> 
> My point is: Why not move all the globals into the fuse driver, and make
> an early call to that fuse driver to initialize all these globals.
> Basically, rework this patch series to simply move the code to
> drivers/misc/fuse/, and keep initializing it by function call rather
> than as a driver probe(). The code can still scan DT to get the required
> reg/clock/... resources, in a similar fashion to e.g. the Tegra timer or
> cpufreq drivers IIRC. Perhaps the sysfs exports could be associated with
> a driver still though - just initialize the globals early?

That's probably better indeed... Will look into that.

Cheers,

Peter.
