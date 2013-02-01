Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757989Ab3BAW6D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 17:58:03 -0500
Received: from mail-ve0-f169.google.com ([209.85.128.169]:36475 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755035Ab3BAW5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 17:57:55 -0500
MIME-Version: 1.0
In-Reply-To: <1359657310.6022.4.camel@x61.thuisdomein>
References: <1359367251.883.13.camel@x61.thuisdomein> <CAErSpo7grYijCUZGWGM4jao+MUqXYQ66q1az6bbKPMX4_Jwcyg@mail.gmail.com>
 <1450113.teKM2dvJbO@vostro.rjw.lan> <1359657310.6022.4.camel@x61.thuisdomein>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 1 Feb 2013 15:57:34 -0700
Message-ID: <CAErSpo7TD8Vw-6V_-pZzarRd=APzEV-xfXQBYTNPceyxyojfsQ@mail.gmail.com>
Subject: Re: [PATCH v2] PCI: pciehp: drop ENTRY messages
To: Paul Bolle <pebolle@tiscali.nl>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2013 at 11:35 AM, Paul Bolle <pebolle@tiscali.nl> wrote:
> In each suspend and resume cycle my laptop prints these messages at
> KERN_INFO level:
>     pciehp 0000:00:1c.1:pcie04: pciehp_suspend ENTRY
>     pciehp 0000:00:1c.0:pcie04: pciehp_suspend ENTRY
>
> and
>     pciehp 0000:00:1c.0:pcie04: pciehp_resume ENTRY
>     pciehp 0000:00:1c.1:pcie04: pciehp_resume ENTRY
>
> Drop these messages, that were probably used to debug the suspend and
> resume code, but now serve no purpose.
>
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

I applied this to pci/misc for v3.9.  Thanks!

Bjorn

> ---
> 0) v1 was called "PCI: pciehp: hide ENTRY messages behind ctrl_dbg()".
> But Bjorn and Rafael prefer to drop these messages completely.
>
> 1) Not even compile tested!
>
>  drivers/pci/hotplug/pciehp_core.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/drivers/pci/hotplug/pciehp_core.c b/drivers/pci/hotplug/pciehp_core.c
> index 939bd1d..7d72c5e 100644
> --- a/drivers/pci/hotplug/pciehp_core.c
> +++ b/drivers/pci/hotplug/pciehp_core.c
> @@ -293,7 +293,6 @@ static void pciehp_remove(struct pcie_device *dev)
>  #ifdef CONFIG_PM
>  static int pciehp_suspend (struct pcie_device *dev)
>  {
> -       dev_info(&dev->device, "%s ENTRY\n", __func__);
>         return 0;
>  }
>
> @@ -303,7 +302,6 @@ static int pciehp_resume (struct pcie_device *dev)
>         struct slot *slot;
>         u8 status;
>
> -       dev_info(&dev->device, "%s ENTRY\n", __func__);
>         ctrl = get_service_data(dev);
>
>         /* reinitialize the chipset's event detection logic */
> --
> 1.7.11.7
>
