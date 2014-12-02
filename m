Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932818AbaLBSZb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 13:25:31 -0500
Received: from mga03.intel.com ([134.134.136.65]:18392 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932649AbaLBSZ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 13:25:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,502,1413270000"; 
   d="scan'208";a="617433251"
Date: Tue, 2 Dec 2014 10:24:02 -0800
From: Kristen Carlson Accardi <kristen@linux.intel.com>
To: Ethan Zhao <ethan.zhao@oracle.com>
Cc: <dirk.j.brandewie@intel.com>, <viresh.kumar@linaro.org>,
        <rjw@rjwysocki.net>, <corbet@lwn.net>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <ethan.kernel@gmail.com>, <joe.jin@oracle.com>,
        <brian.maly@oracle.com>
Subject: Re: [PATCH 2/2 V6] intel_pstate: add kernel parameter to force
 loading on Sun X86 servers.
Message-ID: <20141202102402.09ea6017@kcaccard-desk.amr.corp.intel.com>
In-Reply-To: <1417145777-21897-4-git-send-email-ethan.zhao@oracle.com>
References: <1417145777-21897-1-git-send-email-ethan.zhao@oracle.com>
	<1417145777-21897-4-git-send-email-ethan.zhao@oracle.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Nov 2014 12:36:17 +0900
Ethan Zhao <ethan.zhao@oracle.com> wrote:

> To force loading on Oracle Sun X86 servers, provide one kernel command line
> parameter
> 
>   intel_pstate = ora_force
> 
> For those who be aware of the risk of no power capping capabily working and
> try to get better performance with this driver.

So, is this something you'd expect users to use on production systems,
or is it just for debug?

Thanks,
Kristen

> 
> Signed-off-by: Ethan Zhao <ethan.zhao@oracle.com>
> ---
>  v2: change to hardware vendor specific naming parameter.
>  v4: refine code and doc.
>  v5&v6: fix a typo in doc.
> 
>  Documentation/kernel-parameters.txt | 5 +++++
>  drivers/cpufreq/intel_pstate.c      | 6 +++++-
>  2 files changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 479f332..7d0983e 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -1446,6 +1446,11 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  		       disable
>  		         Do not enable intel_pstate as the default
>  		         scaling driver for the supported processors
> +		       ora_force
> +			 Force loading intel_pstate on Oracle Sun Servers(X86).
> +			 only for those who be aware of the risk of no power capping
> +			 capability working and try to get better performance with this
> +			 driver.
>  
>  	intremap=	[X86-64, Intel-IOMMU]
>  			on	enable Interrupt Remapping (default)
> diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
> index 1bb62ca..2654e13 100644
> --- a/drivers/cpufreq/intel_pstate.c
> +++ b/drivers/cpufreq/intel_pstate.c
> @@ -866,6 +866,7 @@ static struct cpufreq_driver intel_pstate_driver = {
>  };
>  
>  static int __initdata no_load;
> +static unsigned int  ora_force;
>  
>  static int intel_pstate_msrs_not_valid(void)
>  {
> @@ -1003,7 +1004,8 @@ static bool intel_pstate_platform_pwr_mgmt_exists(void)
>  			case PSS:
>  				return intel_pstate_no_acpi_pss();
>  			case PCC:
> -				return intel_pstate_has_acpi_ppc();
> +				return intel_pstate_has_acpi_ppc() &&
> +					(!ora_force);
>  			}
>  	}
>  
> @@ -1078,6 +1080,8 @@ static int __init intel_pstate_setup(char *str)
>  
>  	if (!strcmp(str, "disable"))
>  		no_load = 1;
> +	if (!strcmp(str, "ora_force"))
> +		ora_force = 1;
>  	return 0;
>  }
>  early_param("intel_pstate", intel_pstate_setup);

