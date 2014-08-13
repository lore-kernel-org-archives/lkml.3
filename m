Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288AbaHMWun (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 18:50:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:27694 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754220AbaHMWuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 18:50:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,858,1400050800"; 
   d="scan'208";a="584540284"
Date: Wed, 13 Aug 2014 15:50:35 -0700
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Jason Baron <jbaron@akamai.com>
Cc: rafael.j.wysocki@intel.com, durgadoss.r@intel.com,
        srivatsa.bhat@linux.vnet.ibm.com, srinivas.pandruvada@linux.intel.com,
        linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH] powercap/rapl: add support for cpu model 0x3f
Message-ID: <20140813155035.2af00ef5@ultegra>
In-Reply-To: <20140813203326.957F58004E@prod-mail-relay07.akamai.com>
References: <20140813203326.957F58004E@prod-mail-relay07.akamai.com>
Organization: OTC
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Aug 2014 20:33:26 +0000 (GMT)
Jason Baron <jbaron@akamai.com> wrote:

> I've confirmed that monitoring the package power usage as well
> as setting power limits appear to be working as expected. However,
> I do see in the logs:
> 
> [    5.082632] intel_rapl: RAPL domain core detection failed
> [    5.088370] intel_rapl: RAPL domain uncore detection failed
> 
> So I'm not sure if the h/w simply doesn't support that, or if the
> driver could be improved here. In any case, adding the 0x3f makes
> the driver useful for me. Tested aginst cpu:
> 
> Intel(R) Xeon(R) CPU E5-2650 v3 @ 2.30GHz
> 
I don't have this CPU model to test. Most server processors don't
have uncore domain so detection failed is normal. Looks like you just
have package and dram domain?
Thanks for testing it out, looks good to me. can you send it to
linux-pm list and cc rafael?

> Signed-off-by: Jason Baron <jbaron@akamai.com>
> ---
>  drivers/powercap/intel_rapl.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/powercap/intel_rapl.c
> b/drivers/powercap/intel_rapl.c index b1cda6f..a362dcc 100644
> --- a/drivers/powercap/intel_rapl.c
> +++ b/drivers/powercap/intel_rapl.c
> @@ -953,6 +953,7 @@ static const struct x86_cpu_id rapl_ids[] = {
>  	{ X86_VENDOR_INTEL, 6, 0x3a},/* Ivy Bridge */
>  	{ X86_VENDOR_INTEL, 6, 0x3c},/* Haswell */
>  	{ X86_VENDOR_INTEL, 6, 0x3d},/* Broadwell */
> +	{ X86_VENDOR_INTEL, 6, 0x3f},/* Haswell */
>  	{ X86_VENDOR_INTEL, 6, 0x45},/* Haswell ULT */
>  	/* TODO: Add more CPU IDs after testing */
>  	{}

[Jacob Pan]
