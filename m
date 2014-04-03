Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876AbaDCLFU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 07:05:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:48333 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631AbaDCLFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 07:05:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,786,1389772800"; 
   d="scan'208";a="514018425"
Date: Thu, 3 Apr 2014 14:12:40 +0300
From: "mika.westerberg@linux.intel.com" <mika.westerberg@linux.intel.com>
To: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: How to pass I2C platform_data under ACPI
Message-ID: <20140403111240.GC19349@intel.com>
References: <D854C92F57B1B347B57E531E78D05EAD57463568@BGSMSX104.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D854C92F57B1B347B57E531E78D05EAD57463568@BGSMSX104.gar.corp.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03, 2014 at 08:10:40AM +0000, Pallala, Ramakrishna wrote:
> Hi All,
> 
> I am trying to enable a i2c client driver under ACPI. The device is being enumerated behind adapter device and I am getting IRQ resource as well.
> 
> The problem I have now is, how do I pass the platform data to driver?
> 
> struct i2c_board_info {
>         char            type[I2C_NAME_SIZE];
>         unsigned short  flags;
>         unsigned short  addr;
>         void            *platform_data; ===========> how can I initialize this filed.
>         struct dev_archdata     *archdata;
>         struct device_node *of_node;
>         struct acpi_dev_node acpi_node;
>         int             irq;
> };
>  
> In non ACPI environment I used to initialize the platform_data under
> board or platforms files. Under ACPI how do I do that?

If you can't extract that information from ACPI namespace, then one option
is to pass platform data along with the device ACPI ID:

static const struct acpi_device_id my_acpi_match[] = {
	{ "MYID0001", (kernel_ulong_t)&my_platform_data }
	...
	{ },
};

static struct i2c_driver i2c_hid_driver = {
        .driver = {
		...
                .acpi_match_table = ACPI_PTR(my_acpi_match),
        },
...
