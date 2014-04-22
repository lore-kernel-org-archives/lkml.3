Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932176AbaDVLQF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 07:16:05 -0400
Received: from mga01.intel.com ([192.55.52.88]:53653 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754432AbaDVLQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 07:16:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,903,1389772800"; 
   d="scan'208";a="524794486"
Date: Tue, 22 Apr 2014 14:23:31 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: wsa@the-dreams.de, rjw@rjwysocki.net, awilliam@redhat.com, lenb@kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [Resend Patch 3/9] ACPI: Add acpi_bus_attach_private_data() to
 facilitate to attach data to ACPI handle
Message-ID: <20140422112331.GG30677@intel.com>
References: <1397654682-7094-1-git-send-email-tianyu.lan@intel.com>
 <1398147855-9868-1-git-send-email-tianyu.lan@intel.com>
 <1398147855-9868-4-git-send-email-tianyu.lan@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398147855-9868-4-git-send-email-tianyu.lan@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 02:24:09PM +0800, Lan Tianyu wrote:
> There is already acpi_bus_get_private_data() to get ACPI handle data
> which is associated with acpi_bus_private_data_handler(). This patch
> is to add acpi_bus_attach_private_data() to make a pair and facilitate
> to attach and get data to/from ACPI handle.
> 
> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
> ---
>  drivers/acpi/bus.c      | 18 +++++++++++++++++-
>  include/acpi/acpi_bus.h |  1 +
>  2 files changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
> index e7e5844..4ed8d48 100644
> --- a/drivers/acpi/bus.c
> +++ b/drivers/acpi/bus.c
> @@ -132,6 +132,22 @@ void acpi_bus_private_data_handler(acpi_handle handle,
>  }
>  EXPORT_SYMBOL(acpi_bus_private_data_handler);
>  
> +int acpi_bus_attach_private_data(acpi_handle handle, void *data)
> +{
> +	acpi_status status;
> +
> +	status = acpi_attach_data(handle,
> +			acpi_bus_private_data_handler, data);
> +	if (ACPI_FAILURE(status)) {
> +		ACPI_ERROR((AE_INFO, "Error attaching device[%p] data\n",
> +				handle));
> +		return -ENODEV;
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(acpi_bus_attach_private_data);

When I added GPIO operation region support, Rafael mentioned that we might
want to add this private data to the struct acpi_device instead.

Either way, looks good to me,

Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
