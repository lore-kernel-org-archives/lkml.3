Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761Ab3GUGYU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 02:24:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:3033 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752094Ab3GUGYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 02:24:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,712,1367996400"; 
   d="scan'208";a="349056355"
Message-ID: <51EB8014.1030205@linux.intel.com>
Date: Sat, 20 Jul 2013 23:30:44 -0700
From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Zhang Rui <rui.zhang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: thermal / x86: Fix init error code path in package temperature
 driver
References: <1652739.TRfBKHdnvc@vostro.rjw.lan>
In-Reply-To: <1652739.TRfBKHdnvc@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

This is already fixed and currently merged to MM tree. So this should 
make to rc2.
I don't know whether Rui will push or MM maintainer will push this change.


Thanks,
Srinivas

On 07/20/2013 01:48 PM, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>
> The error code path of the x86 package temperature thermal driver's
> initialization routine, pkg_temp_thermal_init(), makes an unbalanced
> call to get_online_cpus(), which causes subsequent CPU offline
> operations, and consequently system suspend, to permanently block
> in cpu_hotplug_begin() on systems where get_core_online() returns
> an error code.
>
> Remove the extra get_online_cpus() to fix the problem (tested on
> Toshiba Portege R500).
>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>   drivers/thermal/x86_pkg_temp_thermal.c |    1 -
>   1 file changed, 1 deletion(-)
>
> Index: linux-pm/drivers/thermal/x86_pkg_temp_thermal.c
> ===================================================================
> --- linux-pm.orig/drivers/thermal/x86_pkg_temp_thermal.c
> +++ linux-pm/drivers/thermal/x86_pkg_temp_thermal.c
> @@ -592,7 +592,6 @@ static int __init pkg_temp_thermal_init(
>   	return 0;
>   
>   err_ret:
> -	get_online_cpus();
>   	for_each_online_cpu(i)
>   		put_core_offline(i);
>   	put_online_cpus();
>
>

