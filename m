Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409Ab3DBWnU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:43:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:55432 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756493Ab3DBWnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:43:17 -0400
Message-ID: <515B50CF.7050103@infradead.org>
Date: Tue, 02 Apr 2013 14:42:39 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH 1/1] Introduce Intel RAPL cooling device driver
References: <1364940936-20846-1-git-send-email-jacob.jun.pan@linux.intel.com> <1364940936-20846-2-git-send-email-jacob.jun.pan@linux.intel.com>
In-Reply-To: <1364940936-20846-2-git-send-email-jacob.jun.pan@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/13 15:15, Jacob Pan wrote:
> RAPL(Running Average Power Limit) interface provides platform software
> with the ability to monitor, control, and get notifications on SOC
> power consumptions. Since its first appearance on Sandy Bridge, more
> features have being added to extend its usage. In RAPL, platforms are
> divided into domains for fine grained control. These domains include
> package, DRAM controller, CPU core (Power Plane 0), graphics uncore
> (power plane 1), etc.
> 
> The purpose of this driver is to expose RAPL for userspace
> consumption. Overall, RAPL fits in the generic thermal layer in
> that platform level power capping and monitoring are mainly used for
> thermal management and thermal layer provides the abstracted interface
> needed to have portable applications.
> 
> Specifically, userspace is presented with per domain cooling device
> with sysfs links to its kobject. Although RAPL domain provides many
> parameters for fine tuning, long term power limit is exposed as the
> single knob via cooling device state. Whereas the rest of the
> parameters are still accessible via the linked kobject. This simplifies
> the interface for both simple and advanced use cases.
> 
> Eventfd is used to provide notifications to the userspace. At per domain
> level, use can choose any event capable parameters to register for
> threshold crossing notifications. This is shamelessly "borrowed" from
> cgroup with some trimming/fitting.
> 
> Zhang, Rui's initial RAPL driver was used as a reference and starting
> point. Many thanks.
> https://lkml.org/lkml/2011/5/26/93
> 
> Unlike the patch above, which is mainly for monitoring, this driver
> focus on the control and usability by user applications.
> 
> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> ---
>  drivers/platform/x86/Kconfig      |    8 +
>  drivers/platform/x86/Makefile     |    1 +
>  drivers/platform/x86/intel_rapl.c | 1323 +++++++++++++++++++++++++++++++++++++
>  drivers/platform/x86/intel_rapl.h |  249 +++++++
>  4 files changed, 1581 insertions(+)
>  create mode 100644 drivers/platform/x86/intel_rapl.c
>  create mode 100644 drivers/platform/x86/intel_rapl.h
> 
> diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
> index 3338437..34bcd52 100644
> --- a/drivers/platform/x86/Kconfig
> +++ b/drivers/platform/x86/Kconfig
> @@ -781,4 +781,12 @@ config APPLE_GMUX
>  	  graphics as well as the backlight. Currently only backlight
>  	  control is supported by the driver.
>  
> +config INTEL_RAPL
> +	tristate "Intel RAPL Support"
> +	depends on X86 && THERMAL
> +	default y
> +	---help---
> +	  RAPL, AKA, Running Average Power Limit provides mechanisms to enforce

	  RAPL, aka Running Average Power Limit, provides mechanisms to enforce

or a.k.a., but not AKA

or even:
	  RAPL (Running Average Power Limit) provides mechanisms to enforce


> +	  and monitor per domain power consumption limits of supported Intel CPUs.
> +
>  endif # X86_PLATFORM_DEVICES


-- 
~Randy
