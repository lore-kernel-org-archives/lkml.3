Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932AbaEZKVv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 06:21:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:59514 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501AbaEZKVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 06:21:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,912,1392192000"; 
   d="scan'208";a="537645874"
Date: Mon, 26 May 2014 13:21:45 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Zhang Rui <rui.zhang@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhelgaas@google.com, matthew.garrett@nebula.com,
        rafael.j.wysocki@intel.com, dmitry.torokhov@gmail.com,
        Heikki Krogerus <heikki.krogerus@intel.com>
Subject: Re: [PATCH V7 10/11] ACPI: use platform bus as the default bus for
 _HID enumeration
Message-ID: <20140526102145.GB1765@lahna.fi.intel.com>
References: <1400781753-2682-1-git-send-email-rui.zhang@intel.com>
 <1400781753-2682-11-git-send-email-rui.zhang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400781753-2682-11-git-send-email-rui.zhang@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2014 at 02:02:32AM +0800, Zhang Rui wrote:
> Because of the growing demand for enumerating ACPI devices to
> platform bus, this patch changes the code to enumerate ACPI
> devices to platform bus by default, if the device
> 1. has _HID.
> 2. does not have a scan handler attached.
> 3. is not SPB slave device, which should be enumerated by its parent.
> 
> Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> ---
>  drivers/acpi/acpi_platform.c | 28 ----------------------------
>  drivers/acpi/scan.c          | 43 ++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 42 insertions(+), 29 deletions(-)
> 
> diff --git a/drivers/acpi/acpi_platform.c b/drivers/acpi/acpi_platform.c
> index dbfe49e..33376a9 100644
> --- a/drivers/acpi/acpi_platform.c
> +++ b/drivers/acpi/acpi_platform.c
> @@ -22,24 +22,6 @@
>  
>  ACPI_MODULE_NAME("platform");
>  
> -/*
> - * The following ACPI IDs are known to be suitable for representing as
> - * platform devices.
> - */
> -static const struct acpi_device_id acpi_platform_device_ids[] = {
> -
> -	{ "PNP0D40" },
> -	{ "ACPI0003" },
> -	{ "VPC2004" },
> -	{ "BCM4752" },

You can't remove this one as it is bluetooth connected to HS-UART and
thus has UARTSerialBus() connector.

> -
> -	/* Intel Smart Sound Technology */
> -	{ "INT33C8" },
> -	{ "80860F28" },
> -
> -	{ }
> -};
