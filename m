Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751888AbaDCLbC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 07:31:02 -0400
Received: from mga11.intel.com ([192.55.52.93]:58520 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790AbaDCLa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 07:30:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,786,1389772800"; 
   d="scan'208";a="513633138"
Date: Thu, 3 Apr 2014 14:38:33 +0300
From: "mika.westerberg@linux.intel.com" <mika.westerberg@linux.intel.com>
To: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: How to pass I2C platform_data under ACPI
Message-ID: <20140403113832.GD19349@intel.com>
References: <D854C92F57B1B347B57E531E78D05EAD57463568@BGSMSX104.gar.corp.intel.com>
 <20140403111240.GC19349@intel.com>
 <D854C92F57B1B347B57E531E78D05EAD57463D21@BGSMSX104.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D854C92F57B1B347B57E531E78D05EAD57463D21@BGSMSX104.gar.corp.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03, 2014 at 11:25:34AM +0000, Pallala, Ramakrishna wrote:
> >> In non ACPI environment I used to initialize the platform_data under 
> >> board or platforms files. Under ACPI how do I do that?
> >
> >If you can't extract that information from ACPI namespace, then one option is to pass platform data along with the device ACPI ID:
> >
> >static const struct acpi_device_id my_acpi_match[] = {
> >	{ "MYID0001", (kernel_ulong_t)&my_platform_data }
> >	...
> >	{ },
> >};
> 
> Thanks for the Quick reply.
> 
> So If I  want to use different platform_data for different boards can I
> do something like below?

Exactly.

> And initialize the platform data in either driver or in separate module
> which gets compiled along with driver?

Typically it has been done in the same driver but I don't see any problems
having a separate module as well.

> static const struct acpi_device_id my_acpi_match[] = {
> 	{ "MYID0001", (kernel_ulong_t)&my_platform_data1 }
> 	{ "MYID0002", (kernel_ulong_t)&my_platform_data2 }
> 	...
> 	{ },
> 
> Thanks,
> Ram
