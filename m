Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759822Ab3FDCLu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 22:11:50 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:58855 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759006Ab3FDCLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 22:11:47 -0400
MIME-Version: 1.0
In-Reply-To: <20130604114955.753909b956c4f8e75ace86a0@canb.auug.org.au>
References: <20130604114955.753909b956c4f8e75ace86a0@canb.auug.org.au>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 3 Jun 2013 20:11:26 -0600
Message-ID: <CAErSpo7TJK0W2_KKC8jX-JcdirMNxR7HNwbOvpHqq158MMdy4g@mail.gmail.com>
Subject: Re: linux-next: manual merge of the pci tree with Linus' tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next list <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, Jiang Liu <jiang.liu@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 3, 2013 at 7:49 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Bjorn,
>
> Today's linux-next merge of the pci tree got a conflict in
> drivers/acpi/pci_root.c between commit 3f327e39b4b8 ("PCI: acpiphp:
> Re-enumerate devices when host bridge receives Bus Check") from Linus'
> tree and commit 6dc7d22c6738 ("PCI/ACPI: Use dev_printk(),
> acpi_handle_print(), pr_xxx() when possible") from the pci tree.
>
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Looks perfect, thanks!

> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>
> diff --cc drivers/acpi/pci_root.c
> index e427dc5,122b4dc..0000000
> --- a/drivers/acpi/pci_root.c
> +++ b/drivers/acpi/pci_root.c
> @@@ -639,11 -620,9 +620,11 @@@ static void _handle_hotplug_event_root(
>         switch (type) {
>         case ACPI_NOTIFY_BUS_CHECK:
>                 /* bus enumerate */
> -               printk(KERN_DEBUG "%s: Bus check notify on %s\n", __func__,
> -                                (char *)buffer.pointer);
> +               acpi_handle_printk(KERN_DEBUG, handle,
> +                                  "Bus check notify on %s\n", __func__);
>  -              if (!root)
>  +              if (root)
>  +                      acpiphp_check_host_bridge(handle);
>  +              else
>                         handle_root_bridge_insertion(handle);
>
>                 break;
