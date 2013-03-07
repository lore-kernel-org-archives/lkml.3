Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933159Ab3CGQZT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 11:25:19 -0500
Received: from mail-oa0-f44.google.com ([209.85.219.44]:37016 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756066Ab3CGQZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 11:25:16 -0500
MIME-Version: 1.0
In-Reply-To: <1362666523-9961-1-git-send-email-yxlraid@gmail.com>
References: <1362666523-9961-1-git-send-email-yxlraid@gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 7 Mar 2013 09:24:55 -0700
Message-ID: <CAErSpo69g-dJo4xW+bvGuz=TALfMLQBgQ-_PLvsa-c58AzOVJA@mail.gmail.com>
Subject: Re: [PATCH 1/2] PCI: define macro for marvell vendor ID
To: yxlraid@gmail.com
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Xiangliang Yu <yuxiangl@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 7, 2013 at 7:28 AM,  <yxlraid@gmail.com> wrote:
> From: Xiangliang Yu <yuxiangl@marvell.com>
>
> Define PCI_VENDOR_MARVELL_ID_EXT macro for 0x1b4b vendor ID

"PCI_VENDOR_MARVELL_ID_EXT" is not actually the symbol you defined below.

Per the comment at the top of pci_ids.h, we don't add things here
unless they are shared between multiple drivers.

That said, the 0x1b4b vendor ID is used in mv_init.c, mvumi.h,
mvumi.c, and ahci.c.  If you want to unify all those so they all use
same symbol, and define that symbol here in pci_ids.h, that would be
fine with me.

> ---
>  include/linux/pci_ids.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
> index f11c1c2..a80f9e6 100644
> --- a/include/linux/pci_ids.h
> +++ b/include/linux/pci_ids.h
> @@ -1604,6 +1604,7 @@
>  #define PCI_SUBDEVICE_ID_KEYSPAN_SX2   0x5334
>
>  #define PCI_VENDOR_ID_MARVELL          0x11ab
> +#define PCI_VENDOR_ID_MARVELL_EXT      0x1b4b
>  #define PCI_DEVICE_ID_MARVELL_GT64111  0x4146
>  #define PCI_DEVICE_ID_MARVELL_GT64260  0x6430
>  #define PCI_DEVICE_ID_MARVELL_MV64360  0x6460
> --
> 1.7.5.4
>
