Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714Ab3GVBbK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 21:31:10 -0400
Received: from mga03.intel.com ([143.182.124.21]:31565 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754593Ab3GVBbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 21:31:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,715,1367996400"; 
   d="scan'208";a="271352228"
Message-ID: <1374456662.2057.19.camel@rzhang1-mobl4>
Subject: Re: thermal / x86: Fix init error code path in package temperature
 driver
From: Zhang Rui <rui.zhang@intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Date: Mon, 22 Jul 2013 09:31:02 +0800
In-Reply-To: <4256112.BE619zcG2D@vostro.rjw.lan>
References: <1652739.TRfBKHdnvc@vostro.rjw.lan>
	 <51EB8014.1030205@linux.intel.com> <4256112.BE619zcG2D@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-07-21 at 15:03 +0200, Rafael J. Wysocki wrote:
> On Saturday, July 20, 2013 11:30:44 PM Srinivas Pandruvada wrote:
> > Hi Rafael,
> > 
> > This is already fixed and currently merged to MM tree. So this should 
> > make to rc2.
> > I don't know whether Rui will push or MM maintainer will push this change.
> 
> Usually Andrew Morton (who maintains -mm) prefers maintainers to push things to
> Linus.
> 
I'll push it for rc2.

thanks,
rui
> Thanks,
> Rafael
> 
> 
> > On 07/20/2013 01:48 PM, Rafael J. Wysocki wrote:
> > > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > >
> > > The error code path of the x86 package temperature thermal driver's
> > > initialization routine, pkg_temp_thermal_init(), makes an unbalanced
> > > call to get_online_cpus(), which causes subsequent CPU offline
> > > operations, and consequently system suspend, to permanently block
> > > in cpu_hotplug_begin() on systems where get_core_online() returns
> > > an error code.
> > >
> > > Remove the extra get_online_cpus() to fix the problem (tested on
> > > Toshiba Portege R500).
> > >
> > > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > ---
> > >   drivers/thermal/x86_pkg_temp_thermal.c |    1 -
> > >   1 file changed, 1 deletion(-)
> > >
> > > Index: linux-pm/drivers/thermal/x86_pkg_temp_thermal.c
> > > ===================================================================
> > > --- linux-pm.orig/drivers/thermal/x86_pkg_temp_thermal.c
> > > +++ linux-pm/drivers/thermal/x86_pkg_temp_thermal.c
> > > @@ -592,7 +592,6 @@ static int __init pkg_temp_thermal_init(
> > >   	return 0;
> > >   
> > >   err_ret:
> > > -	get_online_cpus();
> > >   	for_each_online_cpu(i)
> > >   		put_core_offline(i);
> > >   	put_online_cpus();
> > >
> > >
> > 


