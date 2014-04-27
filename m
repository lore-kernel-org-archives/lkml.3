Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132AbaD0WFa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 18:05:30 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:61724 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751495AbaD0WF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 18:05:29 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Zhang Rui <rui.zhang@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhelgaas@google.com, matthew.garrett@nebula.com,
        rafael.j.wysocki@intel.com, dmitry.torokhov@gmail.com
Subject: Re: [PATCH V5 09/12] ACPI: introduce acpi platform exclude id list
Date: Mon, 28 Apr 2014 00:21:55 +0200
Message-ID: <5562797.vTJauiAbJc@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1396886819-2637-10-git-send-email-rui.zhang@intel.com>
References: <1396886819-2637-1-git-send-email-rui.zhang@intel.com> <1396886819-2637-10-git-send-email-rui.zhang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 08, 2014 12:06:56 AM Zhang Rui wrote:
> For ACPI PIC (PNP0000) and Timer (PNP0100) device objects, although
> they have _HID control method, but they should not be enumerated to
> platform bus, because there will never be any platform drivers for them.
> 
> Thus an exclude id list is introduced in this patch to prevent
> those platform device nodes from being created.
> 
> Signed-off-by: Zhang Rui <rui.zhang@intel.com>

This should go into [6/12] as well.

> ---
>  drivers/acpi/acpi_platform.c |   14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/drivers/acpi/acpi_platform.c b/drivers/acpi/acpi_platform.c
> index 33376a9..91ed43a 100644
> --- a/drivers/acpi/acpi_platform.c
> +++ b/drivers/acpi/acpi_platform.c
> @@ -22,6 +22,17 @@
>  
>  ACPI_MODULE_NAME("platform");
>  
> +static const struct acpi_device_id excluded_id_list[] = {
> +	{"PNP0000", 0},	/* PIC */
> +	{"PNP0100", 0},	/* Timer */
> +	{"", 0},
> +};
> +
> +static bool is_exclusive_device(struct acpi_device *dev)
> +{
> +	return !acpi_match_device_ids(dev, excluded_id_list);
> +}
> +
>  /**
>   * acpi_create_platform_device - Create platform device for ACPI device node
>   * @adev: ACPI device node to create a platform device for.
> @@ -48,6 +59,9 @@ int acpi_create_platform_device(struct acpi_device *adev,
>  	if (adev->physical_node_count)
>  		return 0;
>  
> +	if (is_exclusive_device(adev))
> +		return 0;
> +
>  	INIT_LIST_HEAD(&resource_list);
>  	count = acpi_dev_get_resources(adev, &resource_list, NULL, NULL);
>  	if (count < 0) {
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
