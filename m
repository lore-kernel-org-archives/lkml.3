Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab3I2PTb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 11:19:31 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:52688 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761Ab3I2PT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 11:19:29 -0400
MIME-Version: 1.0
In-Reply-To: <1378135394-31092-1-git-send-email-valentin.ilie@gmail.com>
References: <1378135394-31092-1-git-send-email-valentin.ilie@gmail.com>
Date: Sun, 29 Sep 2013 18:19:28 +0300
X-Google-Sender-Auth: CkxkaPsZ-wGwyGFFtjXLUUW2SP8
Message-ID: <CAHuBVBbDk_bgJ9-R-tr9qrt7O3i6NEF6m2QeWnpU5UCxPC9DrA@mail.gmail.com>
Subject: Re: [PATCH] ARM: mach-iop32x: iq31244: Replace if-then-else with a
 switch statement
From: Valentin Ilie <valentin.ilie@gmail.com>
To: linux@arm.linux.org.uk
Cc: swarren@nvidia.com, rmk+kernel@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Valentin Ilie <valentin.ilie@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 September 2013 18:23, Valentin Ilie <valentin.ilie@gmail.com> wrote:
> Convert a compound if-else blob to a switch statement.
>
> Signed-off-by: Valentin Ilie <valentin.ilie@gmail.com>
> ---
>  arch/arm/mach-iop32x/iq31244.c | 29 +++++++++++------------------
>  1 file changed, 11 insertions(+), 18 deletions(-)
>
> diff --git a/arch/arm/mach-iop32x/iq31244.c b/arch/arm/mach-iop32x/iq31244.c
> index f2cd296..3415f11 100644
> --- a/arch/arm/mach-iop32x/iq31244.c
> +++ b/arch/arm/mach-iop32x/iq31244.c
> @@ -101,28 +101,21 @@ void __init iq31244_map_io(void)
>  static int __init
>  ep80219_pci_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
>  {
> -       int irq;
> -
> -       if (slot == 0) {
> -               /* CFlash */
> -               irq = IRQ_IOP32X_XINT1;
> -       } else if (slot == 1) {
> -               /* 82551 Pro 100 */
> -               irq = IRQ_IOP32X_XINT0;
> -       } else if (slot == 2) {
> -               /* PCI-X Slot */
> -               irq = IRQ_IOP32X_XINT3;
> -       } else if (slot == 3) {
> -               /* SATA */
> -               irq = IRQ_IOP32X_XINT2;
> -       } else {
> +       switch (slot) {
> +       case 0: /* CFlash */
> +               return IRQ_IOP32X_XINT1;
> +       case 1: /* 82551 Pro 100 */
> +               return IRQ_IOP32X_XINT0;
> +       case 2: /* PCI-X Slot */
> +               return IRQ_IOP32X_XINT3;
> +       case 3: /* SATA */
> +               return IRQ_IOP32X_XINT2;
> +       default:
>                 printk(KERN_ERR "ep80219_pci_map_irq() called for unknown "
>                         "device PCI:%d:%d:%d\n", dev->bus->number,
>                         PCI_SLOT(dev->devfn), PCI_FUNC(dev->devfn));
> -               irq = -1;
> +               return -1;
>         }
> -
> -       return irq;
>  }
>
>  static struct hw_pci ep80219_pci __initdata = {
> --
> 1.8.1.2
>

Can someone look into this?

-- 
Valentin Ilie
