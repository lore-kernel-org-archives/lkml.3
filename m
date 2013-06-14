Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608Ab3FNRJH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 13:09:07 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:38367 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387Ab3FNRJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 13:09:05 -0400
MIME-Version: 1.0
In-Reply-To: <2491625.TQ1FFQeR38@vostro.rjw.lan>
References: <2491625.TQ1FFQeR38@vostro.rjw.lan>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 14 Jun 2013 11:08:44 -0600
Message-ID: <CAErSpo7Q8H5wmMUPKqquerp_zbFwnac95Gbezd2=STBjtUrnvw@mail.gmail.com>
Subject: Re: [PATCH] PCI / ACPI / PM: Use correct power state strings in messages
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 13, 2013 at 4:29 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>
> Make acpi_pci_set_power_state() print the name of the ACPI device
> power state the device has been actually put into instead of printing
> the name of the requested PCI device power state, which need not be
> the same.
>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>
> For 3.11.
>
> Thanks,
> Rafael
>
> ---
>  drivers/pci/pci-acpi.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Index: linux-pm/drivers/pci/pci-acpi.c
> ===================================================================
> --- linux-pm.orig/drivers/pci/pci-acpi.c
> +++ linux-pm/drivers/pci/pci-acpi.c
> @@ -211,7 +211,7 @@ static int acpi_pci_set_power_state(stru
>
>         if (!error)
>                 dev_info(&dev->dev, "power state changed by ACPI to %s\n",
> -                        pci_power_name(state));
> +                        acpi_power_state_string(state_conv[state]));
>
>         return error;
>  }
>

Just to double-check this, it *looks* like the effective change is
that for PCI_D3hot and PCI_D3cold, we'll print "(unknown)" instead of
"D3hot" and "D3cold" because state_conv[] folds both PCI_D3hot and
PCI_D3cold into ACPI_STATE_D3, and acpi_power_state_string() doesn't
have a case for ACPI_STATE_D3.

Is that what you intended?

Bjorn
