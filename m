Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965Ab3GJABW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 20:01:22 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:36262 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753342Ab3GJABV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 20:01:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Toshi Kani <toshi.kani@hp.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] ACPI / scan: Always call acpi_bus_scan() for bus check notifications
Date: Wed, 10 Jul 2013 02:11:05 +0200
Message-ID: <19368029.jaCH7i2zvY@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1373398362.24916.4.camel@misato.fc.hp.com>
References: <2230821.QbNohsyO0O@vostro.rjw.lan> <1373398362.24916.4.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 09, 2013 01:32:42 PM Toshi Kani wrote:
> On Mon, 2013-07-08 at 02:10 +0200, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > 
> > An ACPI_NOTIFY_BUS_CHECK notification means that we should scan the
> > entire namespace starting from the given handle even if the device
> > represented by that handle is present (other devices below it may
> > just have been added).
> > 
> > For this reason, modify acpi_scan_bus_device_check() to always run
> > acpi_bus_scan() if the notification being handled is of type
> > ACPI_NOTIFY_BUS_CHECK.
> > 
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > Cc: 3.10+ <stable@vger.kernel.org>
> 
> Acked-by: Toshi Kani <toshi.kani@hp.com>
> 
> But, I think we need the additional patch below.

Yes, I think you're right.

Thanks,
Rafael



> =====
> From: Toshi Kani <toshi.kani@hp.com>
> Subject: [PATCH] ACPI: Do not call attach() if device is attached
> 
> attach() of ACPI scan handlers does not expect to be called multiple
> times on a same device.  Also, the attached handler may not be changed
> without calling its detach().  Change acpi_scan_attach_handler() not
> to call attach() when the given device is already attached.
> 
> Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> ---
>  drivers/acpi/scan.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> index 20757e0..2b9e867 100644
> --- a/drivers/acpi/scan.c
> +++ b/drivers/acpi/scan.c
> @@ -1885,6 +1885,9 @@ static int acpi_scan_attach_handler(struct
> acpi_device *device)
>  	struct acpi_hardware_id *hwid;
>  	int ret = 0;
>  
> +	if (device->handler)
> +		return 1;
> +
>  	list_for_each_entry(hwid, &device->pnp.ids, list) {
>  		const struct acpi_device_id *devid;
>  		struct acpi_scan_handler *handler;
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
