Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802Ab3IVVTa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 17:19:30 -0400
Received: from mail-qe0-f42.google.com ([209.85.128.42]:63658 "EHLO
	mail-qe0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093Ab3IVVT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 17:19:28 -0400
MIME-Version: 1.0
In-Reply-To: <1379510692-32435-2-git-send-email-treding@nvidia.com>
References: <1379510692-32435-1-git-send-email-treding@nvidia.com>
	<1379510692-32435-2-git-send-email-treding@nvidia.com>
Date: Sun, 22 Sep 2013 16:19:27 -0500
Message-ID: <CAL_JsqLE8aj511oF-gK7Gu5QfmHsQO3+oJ0KFkv0wmuo7i6eiw@mail.gmail.com>
Subject: Re: [PATCH v2 01/10] of/irq: Rework of_irq_count()
From: Rob Herring <robherring2@gmail.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-mips@linux-mips.org,
        Russell King <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>, sparclinux@vger.kernel.org,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 18, 2013 at 8:24 AM, Thierry Reding
<thierry.reding@gmail.com> wrote:
> The of_irq_to_resource() helper that is used to implement of_irq_count()
> tries to resolve interrupts and in fact creates a mapping for resolved
> interrupts. That's pretty heavy lifting for something that claims to
> just return the number of interrupts requested by a given device node.
>
> Instead, use the more lightweight of_irq_map_one(), which, despite the
> name, doesn't create an actual mapping. Perhaps a better name would be
> of_irq_translate_one().
>
> Signed-off-by: Thierry Reding <treding@nvidia.com>

Acked-by: Rob Herring <rob.herring@calxeda.com>

> ---
>  drivers/of/irq.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/of/irq.c b/drivers/of/irq.c
> index 1752988..5f44388 100644
> --- a/drivers/of/irq.c
> +++ b/drivers/of/irq.c
> @@ -368,9 +368,10 @@ EXPORT_SYMBOL_GPL(of_irq_to_resource);
>   */
>  int of_irq_count(struct device_node *dev)
>  {
> +       struct of_irq irq;
>         int nr = 0;
>
> -       while (of_irq_to_resource(dev, nr, NULL))
> +       while (of_irq_map_one(dev, nr, &irq) == 0)
>                 nr++;
>
>         return nr;
> --
> 1.8.4
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
