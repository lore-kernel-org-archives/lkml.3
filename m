Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441Ab3LDEmy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 23:42:54 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:49597 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542Ab3LDEmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 23:42:51 -0500
MIME-Version: 1.0
In-Reply-To: <ee3c0c716da8f1b1146d8829bc5184fbf1c3ead2.1385623064.git.peter.crosthwaite@xilinx.com>
References: <cover.1385623064.git.peter.crosthwaite@xilinx.com>
	<ee3c0c716da8f1b1146d8829bc5184fbf1c3ead2.1385623064.git.peter.crosthwaite@xilinx.com>
Date: Wed, 4 Dec 2013 14:42:50 +1000
X-Google-Sender-Auth: lWet25-Dj2sbKHyrc6hGrnfB5VU
Message-ID: <CAEgOgz5USCRS5cB6bchFjZfafE6syPzWob8H8yNjczgKLB_RRw@mail.gmail.com>
Subject: Re: [PATCH v1 1/2] of: irq: Ignore disabled intc's when searching map
From: Peter Crosthwaite <peter.crosthwaite@xilinx.com>
To: grant-likely <grant-likely@linaro.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Rob Herring <rob.herring@calxeda.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping!

On Thu, Nov 28, 2013 at 5:26 PM, Peter Crosthwaite
<peter.crosthwaite@xilinx.com> wrote:
> When searching the interrupt map, if a matched parent is disabled, just
> ignore it and move on with the search.
>
> This allows for specifying connection of a single device IRQ to
> multiple interrupt controllers via the interrupt map schema. This change
> allows for selection of the active interrupt controller via the already
> existing status = "disabled" mechanism.
>
> Signed-off-by: Peter Crosthwaite <peter.crosthwaite@xilinx.com>
> Acked-by: Michal Simek <michal.simek@xilinx.com>
> ---
>  drivers/of/irq.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/of/irq.c b/drivers/of/irq.c
> index 786b0b4..22e414b 100644
> --- a/drivers/of/irq.c
> +++ b/drivers/of/irq.c
> @@ -217,6 +217,9 @@ int of_irq_parse_raw(const __be32 *addr, struct of_phandle_args *out_irq)
>                                 goto fail;
>                         }
>
> +                       if (!of_device_is_available(newpar))
> +                               match = 0;
> +
>                         /* Get #interrupt-cells and #address-cells of new
>                          * parent
>                          */
> --
> 1.8.4.4
>
