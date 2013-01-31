Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223Ab3AaSiU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 13:38:20 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:59551 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755218Ab3AaSiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 13:38:18 -0500
MIME-Version: 1.0
In-Reply-To: <6099377.PFvsxPeyib@vostro.rjw.lan>
References: <1451967.YMyGeCCNtu@vostro.rjw.lan>
	<6099377.PFvsxPeyib@vostro.rjw.lan>
Date: Thu, 31 Jan 2013 10:38:17 -0800
X-Google-Sender-Auth: lOlTe8bJmha20GpRTygLdRelQy8
Message-ID: <CAE9FiQXPaMCSyH72qqu-NvPbPkeUbQq5Dcb_SdKz6SEiSmdR7Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] ACPI / scan: Fix acpi_bus_get_device() check in acpi_match_device()
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Toshi Kani <toshi.kani@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2013 at 2:03 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>
> Since acpi_bus_get_device() returns int and not acpi_status, change
> acpi_match_device() so that it doesn't apply ACPI_FAILURE() to the
> return value of acpi_bus_get_device().
>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>  drivers/acpi/scan.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> Index: linux-pm/drivers/acpi/scan.c
> ===================================================================
> --- linux-pm.orig/drivers/acpi/scan.c
> +++ linux-pm/drivers/acpi/scan.c
> @@ -491,9 +491,9 @@ const struct acpi_device_id *acpi_match_
>                                                const struct device *dev)
>  {
>         struct acpi_device *adev;
> +       acpi_handle handle = ACPI_HANDLE(dev);
>
> -       if (!ids || !ACPI_HANDLE(dev)
> -           || ACPI_FAILURE(acpi_bus_get_device(ACPI_HANDLE(dev), &adev)))
> +       if (!ids || !handle || acpi_bus_get_device(handle, &adev))
>                 return NULL;
>
>         return __acpi_match_device(adev, ids);
>

Acked-by: Yinghai Lu <yinghai@kernel.org>
