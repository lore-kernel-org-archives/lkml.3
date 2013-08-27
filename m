Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab3H0NMg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 09:12:36 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:51970 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321Ab3H0NMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 09:12:35 -0400
MIME-Version: 1.0
In-Reply-To: <1377590237-11046-1-git-send-email-andreas@gaisler.com>
References: <1377590237-11046-1-git-send-email-andreas@gaisler.com>
Date: Tue, 27 Aug 2013 08:12:34 -0500
Message-ID: <CAL_JsqJ4M3L8BXTTRYzt1=hgZ=BUqhNA5RoE8Z=CtvE4qpPb8w@mail.gmail.com>
Subject: Re: [PATCH] of: Define of_irq_find_parent dummy for !defined(CONFIG_OF_IRQ)
From: Rob Herring <robherring2@gmail.com>
To: Andreas Larsson <andreas@gaisler.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lars Poeschel <larsi@wh2.tu-dresden.de>, software@gaisler.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 2:57 AM, Andreas Larsson <andreas@gaisler.com> wrote:
> This changes the dummy version of of_irq_find_parent to be defined when
> !defined(CONFIG_OF_IRQ) instead of when !defined(CONFIG_OF). Without
> this of_irq_find_parent is undefined on SPARC that defines CONFIG_OF but
> not CONFIG_OF_IRQ.

Can you give me some clue about where the failure is. This function
has been here a while, so what changed?

Rob

>
> Signed-off-by: Andreas Larsson <andreas@gaisler.com>
> ---
>  include/linux/of_irq.h |    8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/of_irq.h b/include/linux/of_irq.h
> index 535cecf..d0059a9 100644
> --- a/include/linux/of_irq.h
> +++ b/include/linux/of_irq.h
> @@ -83,11 +83,13 @@ static inline unsigned int irq_of_parse_and_map(struct device_node *dev,
>  {
>         return 0;
>  }
> +#endif /* !CONFIG_OF */
> +
> +#endif /* __OF_IRQ_H */
>
> +#if !defined(CONFIG_OF_IRQ)
>  static inline void *of_irq_find_parent(struct device_node *child)
>  {
>         return NULL;
>  }
> -#endif /* !CONFIG_OF */
> -
> -#endif /* __OF_IRQ_H */
> +#endif /* !CONFIG_OF_IRQ */
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
