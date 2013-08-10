Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968160Ab3HJAcM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 20:32:12 -0400
Received: from mga02.intel.com ([134.134.136.20]:7398 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968043Ab3HJAcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 20:32:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,849,1367996400"; 
   d="scan'208";a="384722261"
Message-ID: <52058BAE.30703@linux.intel.com>
Date: Fri, 09 Aug 2013 17:39:10 -0700
From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
CC: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, rjw@sisk.pl,
        arjan@linux.intel.com, len.brown@intel.com,
        jacob.jun.pan@linux.intel.com, corbet@lwn.net, joe@perches.com,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [RFC v02 0/5] Power Capping Framework and RAPL Driver
References: <1375891965-6921-1-git-send-email-srinivas.pandruvada@linux.intel.com>
In-Reply-To: <1375891965-6921-1-git-send-email-srinivas.pandruvada@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2013 09:12 AM, Srinivas Pandruvada wrote:
> Overview
> With the evolution of technologies, which enables power monitoring and limiting,
> more and more devices are able to constrain their power consumption under certain
> limits. There are several use cases for such technologies:
> - Power monitoring: Each device can report its power consumption.
> - Power Limiting: Setting power limits on the devices allows users to guard against
> platform reaching max system power level.
> - Maximize performance: While staying below a power limit, it allows devices to
> automatically adjust performance to meet demands
> - Dynamic control and re-budgeting: If each device can be constrained to some power,
> extra power can redistributed to other devices, which needs additional performance.
>
> One such example of technology is RAPL (Running Average Power Limit) mechanism
> available in the latest Intel Processors. Intel is slowly adding many devices under
> RAPL control. Also there are other technologies available, for power capping various
> devices. Soon it is very likely that other vendors are also adding or considering
> such implementation.
>
> Power Capping framework is an effort to have a uniform interface available to Linux
> drivers, which will enable
> - A uniform sysfs interface for all devices which can offer power capping
> - A common API for drivers, which will avoid code duplication and easy
> implementation of client drivers.
>
> Also submitting Intel RAPL driver using power capping framework.
>
>
> Revisions:
Thanks for everyone for review. I have received enough negative 
comments, which will require another version.
So please hold off your reviews till next version.

> v02:
> Sign-offs and reviewed-by tags
> Stylistic issues suggested by Joe Perches
> Removed "counter" from power_uw documentation as pointed by Jonathan Corbet
> Submitting Intel RAPL driver using power capping framework
>
> v01:
> Use device model only to register zones and controllers.
>
> v00:
> Presented options
>
> Jacob Pan (2):
>    x86/msr: add 64bit _on_cpu access functions
>    Introduce Intel RAPL power capping driver
>
> Srinivas Pandruvada (3):
>    PowerCap: Documentation
>    PowerCap: Add class driver
>    PowerCap: Added to drivers build
>
>   Documentation/ABI/testing/sysfs-class-powercap   |  165 +++
>   Documentation/powercap/PowerCappingFramework.txt |  686 ++++++++++++
>   arch/x86/include/asm/msr.h                       |   22 +
>   arch/x86/lib/msr-smp.c                           |   62 +
>   drivers/Kconfig                                  |    2 +
>   drivers/Makefile                                 |    1 +
>   drivers/powercap/Kconfig                         |   24 +
>   drivers/powercap/Makefile                        |    6 +
>   drivers/powercap/intel_rapl.c                    | 1305 ++++++++++++++++++++++
>   drivers/powercap/powercap_sys.c                  |  995 +++++++++++++++++
>   include/linux/powercap.h                         |  300 +++++
>   11 files changed, 3568 insertions(+)
>   create mode 100644 Documentation/ABI/testing/sysfs-class-powercap
>   create mode 100644 Documentation/powercap/PowerCappingFramework.txt
>   create mode 100644 drivers/powercap/Kconfig
>   create mode 100644 drivers/powercap/Makefile
>   create mode 100644 drivers/powercap/intel_rapl.c
>   create mode 100644 drivers/powercap/powercap_sys.c
>   create mode 100644 include/linux/powercap.h
>

