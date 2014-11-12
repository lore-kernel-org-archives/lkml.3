Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368AbaKLTPI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 14:15:08 -0500
Received: from mail-ig0-f176.google.com ([209.85.213.176]:62544 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144AbaKLTPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 14:15:06 -0500
MIME-Version: 1.0
X-Originating-IP: [46.116.100.67]
In-Reply-To: <1410553499-55951-6-git-send-email-s-anna@ti.com>
References: <1410553499-55951-1-git-send-email-s-anna@ti.com> <1410553499-55951-6-git-send-email-s-anna@ti.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 12 Nov 2014 21:14:44 +0200
Message-ID: <CAK=WgbZE7_WrsNz5E+MDX7j2tAGEjv91zeCgqhB=Jsiu0+d8vw@mail.gmail.com>
Subject: Re: [PATCHv6 5/5] hwspinlock/omap: add support for dt nodes
To: Suman Anna <s-anna@ti.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Tony Lindgren <tony@atomide.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        Bjorn Andersson <bjorn@kryo.se>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Suman,

On Fri, Sep 12, 2014 at 11:24 PM, Suman Anna <s-anna@ti.com> wrote:
>  static int omap_hwspinlock_probe(struct platform_device *pdev)
>  {
> -       struct hwspinlock_pdata *pdata = pdev->dev.platform_data;
> +       struct device_node *node = pdev->dev.of_node;
>         struct hwspinlock_device *bank;
>         struct hwspinlock *hwlock;
>         struct resource *res;
>         void __iomem *io_base;
> -       int num_locks, i, ret;
> +       int num_locks, i, ret, base_id;
>
> -       if (!pdata)
> +       if (!node)
>                 return -ENODEV;
>
> +       ret = of_hwspin_lock_get_base_id(node);
> +       if (ret < 0 && ret != -EINVAL)
> +               return -ENODEV;
> +       base_id = (ret > 0 ? ret : 0);

Does this mean you allow nodes not to have the base_id property? How
do we protect against multiple nodes not having a base_id property
then?

Implicitly assuming a base_id value (zero in this case) may not be always safe.

Thanks,
Ohad.
