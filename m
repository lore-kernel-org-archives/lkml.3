Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481Ab3GUMxk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 08:53:40 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:60341 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755375Ab3GUMxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 08:53:38 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: Zhang Rui <rui.zhang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: thermal / x86: Fix init error code path in package temperature driver
Date: Sun, 21 Jul 2013 15:03:38 +0200
Message-ID: <4256112.BE619zcG2D@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <51EB8014.1030205@linux.intel.com>
References: <1652739.TRfBKHdnvc@vostro.rjw.lan> <51EB8014.1030205@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, July 20, 2013 11:30:44 PM Srinivas Pandruvada wrote:
> Hi Rafael,
> 
> This is already fixed and currently merged to MM tree. So this should 
> make to rc2.
> I don't know whether Rui will push or MM maintainer will push this change.

Usually Andrew Morton (who maintains -mm) prefers maintainers to push things to
Linus.

Thanks,
Rafael


> On 07/20/2013 01:48 PM, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >
> > The error code path of the x86 package temperature thermal driver's
> > initialization routine, pkg_temp_thermal_init(), makes an unbalanced
> > call to get_online_cpus(), which causes subsequent CPU offline
> > operations, and consequently system suspend, to permanently block
> > in cpu_hotplug_begin() on systems where get_core_online() returns
> > an error code.
> >
> > Remove the extra get_online_cpus() to fix the problem (tested on
> > Toshiba Portege R500).
> >
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > ---
> >   drivers/thermal/x86_pkg_temp_thermal.c |    1 -
> >   1 file changed, 1 deletion(-)
> >
> > Index: linux-pm/drivers/thermal/x86_pkg_temp_thermal.c
> > ===================================================================
> > --- linux-pm.orig/drivers/thermal/x86_pkg_temp_thermal.c
> > +++ linux-pm/drivers/thermal/x86_pkg_temp_thermal.c
> > @@ -592,7 +592,6 @@ static int __init pkg_temp_thermal_init(
> >   	return 0;
> >   
> >   err_ret:
> > -	get_online_cpus();
> >   	for_each_online_cpu(i)
> >   		put_core_offline(i);
> >   	put_online_cpus();
> >
> >
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
