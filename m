Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965175AbaFTHTp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 03:19:45 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:49751 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934032AbaFTHTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 03:19:43 -0400
MIME-Version: 1.0
In-Reply-To: <20140619212713.496614337@linutronix.de>
References: <20140619212606.431750473@linutronix.de>
	<20140619212713.496614337@linutronix.de>
Date: Fri, 20 Jun 2014 12:49:43 +0530
X-Google-Sender-Auth: HWGw9HZhSvsc714fbc06HQcXuEs
Message-ID: <CAOh2x==trCJcQnzekEdcFoBb2i1Mc7hMsJq94iu2dzrZ=Xkeow@mail.gmail.com>
Subject: Re: [patch 08/13] irqchip: spear_shirq: Precalculate status mask
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Shiraz Hashim <shiraz.linux.kernel@gmail.com>,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 3:04 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> Calculate the status mask at compile time, not at runtime.
>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  drivers/irqchip/spear-shirq.c |   13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
>
> Index: linux/drivers/irqchip/spear-shirq.c
> ===================================================================
> --- linux.orig/drivers/irqchip/spear-shirq.c
> +++ linux/drivers/irqchip/spear-shirq.c
> @@ -49,6 +49,7 @@ struct shirq_regs {
>   *
>   * base:       Base register address
>   * regs:       Register configuration for shared irq block
> + * mask:       Mask to apply to the status register
>   * virq_base:  Base virtual interrupt number
>   * nr_irqs:    Number of interrupts handled by this block
>   * offset:     Bit offset of the first interrupt
> @@ -57,6 +58,7 @@ struct shirq_regs {
>  struct spear_shirq {
>         void __iomem            *base;
>         struct shirq_regs       regs;
> +       u32                     mask;
>         u32                     virq_base;
>         u32                     nr_irqs;
>         u32                     offset;
> @@ -72,6 +74,7 @@ static DEFINE_SPINLOCK(lock);
>  static struct spear_shirq spear300_shirq_ras1 = {
>         .offset         = 0,
>         .nr_irqs        = 9,
> +       .mask           = ((0x1 << 9) - 1) << 0,
>         .regs = {
>                 .enb_reg = SPEAR300_INT_ENB_MASK_REG,
>                 .status_reg = SPEAR300_INT_STS_MASK_REG,
> @@ -89,6 +92,7 @@ static struct spear_shirq *spear300_shir
>  static struct spear_shirq spear310_shirq_ras1 = {
>         .offset         = 0,
>         .nr_irqs        = 8,
> +       .mask           = ((0x1 << 8) - 1) << 0,
>         .regs = {
>                 .enb_reg = -1,
>                 .status_reg = SPEAR310_INT_STS_MASK_REG,
> @@ -99,6 +103,7 @@ static struct spear_shirq spear310_shirq
>  static struct spear_shirq spear310_shirq_ras2 = {
>         .offset         = 8,
>         .nr_irqs        = 5,
> +       .mask           = ((0x1 << 5) - 1) << 8,
>         .regs = {
>                 .enb_reg = -1,
>                 .status_reg = SPEAR310_INT_STS_MASK_REG,
> @@ -109,6 +114,7 @@ static struct spear_shirq spear310_shirq
>  static struct spear_shirq spear310_shirq_ras3 = {
>         .offset         = 13,
>         .nr_irqs        = 1,
> +       .mask           = ((0x1 << 1) - 1) << 13,
>         .regs = {
>                 .enb_reg = -1,
>                 .status_reg = SPEAR310_INT_STS_MASK_REG,
> @@ -119,6 +125,7 @@ static struct spear_shirq spear310_shirq
>  static struct spear_shirq spear310_shirq_intrcomm_ras = {
>         .offset         = 14,
>         .nr_irqs        = 3,
> +       .mask           = ((0x1 << 3) - 1) << 14,
>         .regs = {
>                 .enb_reg = -1,
>                 .status_reg = SPEAR310_INT_STS_MASK_REG,
> @@ -141,6 +148,7 @@ static struct spear_shirq *spear310_shir
>  static struct spear_shirq spear320_shirq_ras3 = {
>         .offset         = 0,
>         .nr_irqs        = 7,
> +       .mask           = ((0x1 << 7) - 1) << 0,
>         .disabled       = 1,
>         .regs = {
>                 .enb_reg = SPEAR320_INT_ENB_MASK_REG,
> @@ -154,6 +162,7 @@ static struct spear_shirq spear320_shirq
>  static struct spear_shirq spear320_shirq_ras1 = {
>         .offset         = 7,
>         .nr_irqs        = 3,
> +       .mask           = ((0x1 << 3) - 1) << 7,
>         .regs = {
>                 .enb_reg = -1,
>                 .status_reg = SPEAR320_INT_STS_MASK_REG,
> @@ -165,6 +174,7 @@ static struct spear_shirq spear320_shirq
>  static struct spear_shirq spear320_shirq_ras2 = {
>         .offset         = 10,
>         .nr_irqs        = 1,
> +       .mask           = ((0x1 << 1) - 1) << 10,
>         .regs = {
>                 .enb_reg = -1,
>                 .status_reg = SPEAR320_INT_STS_MASK_REG,
> @@ -176,6 +186,7 @@ static struct spear_shirq spear320_shirq
>  static struct spear_shirq spear320_shirq_intrcomm_ras = {
>         .offset         = 11,
>         .nr_irqs        = 11,
> +       .mask           = ((0x1 << 11) - 1) << 11,
>         .regs = {
>                 .enb_reg = -1,
>                 .status_reg = SPEAR320_INT_STS_MASK_REG,

If you like, maybe this instead of above diff:

diff --git a/drivers/irqchip/spear-shirq.c b/drivers/irqchip/spear-shirq.c
index 3fdda3a..40c5c1b 100644
--- a/drivers/irqchip/spear-shirq.c
+++ b/drivers/irqchip/spear-shirq.c
@@ -281,6 +281,8 @@ static int __init shirq_init(struct spear_shirq
**shirq_blocks, int block_nr,
                shirq_blocks[i]->base = base;
                shirq_blocks[i]->irq_base = irq_find_mapping(shirq_domain,
                                hwirq);
+               shirq_blocks[i]->mask = ((0x1 << shirq_blocks[i]->nr_irqs) - 1)
+                                       << shirq_blocks[i]->offset;
                shirq_blocks[i]->irq = irq_of_parse_and_map(np, i);

                spear_shirq_register(shirq_blocks[i]);


> @@ -239,7 +250,7 @@ static void shirq_handler(unsigned irq,
>
>         chip->irq_ack(idata);
>
> -       mask = ((0x1 << shirq->nr_irqs) - 1) << shirq->offset;
> +       mask = shirq->mask;
>         while ((val = readl(shirq->base + shirq->regs.status_reg) &
>                                 mask)) {
>
>
>
