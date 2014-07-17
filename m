Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751650AbaGQRd1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 13:33:27 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:65348 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbaGQRdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 13:33:25 -0400
MIME-Version: 1.0
In-Reply-To: <1405465241-28684-3-git-send-email-bjorn.andersson@sonymobile.com>
References: <1405465241-28684-1-git-send-email-bjorn.andersson@sonymobile.com>
	<1405465241-28684-3-git-send-email-bjorn.andersson@sonymobile.com>
Date: Thu, 17 Jul 2014 23:03:23 +0530
Message-ID: <CAMf-jSnPpo39cXLbM9cefUr37J=hnEHqfJSetORxMnjsdoANdw@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] soc: qcom-rpm: Driver for the Qualcomm RPM
From: pramod gurav <pramod.gurav.etc@gmail.com>
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjorn,

On Wed, Jul 16, 2014 at 4:30 AM, Bjorn Andersson
<bjorn.andersson@sonymobile.com> wrote:
> Driver for the Resource Power Manager (RPM) found in Qualcomm 8660, 8960
> and 8064 based devices. The driver exposes resources that child drivers
> can operate on; to implementing regulator, clock and bus frequency
> drivers.
>

[snip]

> +       }
> +
> +       ret = irq_set_irq_wake(irq_ack, 1);

This calls fails and throws error on my ifc6410 with 3.16-rc5.
Does this driver depend on pincntrl. Looks like the DT support for
pincntrl driver is missing in apq8064 dts in mainline.
Is that right?

> +       if (ret)
> +               dev_warn(&pdev->dev, "failed to mark ack irq as wakeup\n");
> +

[snip]

> +               return ret;
> +       }
> +
> +       ret = irq_set_irq_wake(irq_wakeup, 1);

This fails as well.

> +       if (ret)
> +               dev_warn(&pdev->dev, "failed to mark wakeup irq as wakeup\n");
> +
> +       return of_platform_populate(pdev->dev.of_node, NULL, NULL, &pdev->dev);

[snip]


-- 
Thanks and Regards
Pramod
