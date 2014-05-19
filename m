Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660AbaESNEd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 09:04:33 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:51805 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631AbaESNEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 09:04:31 -0400
MIME-Version: 1.0
In-Reply-To: <1400237477-24831-1-git-send-email-chander.kashyap@linaro.org>
References: <1400237477-24831-1-git-send-email-chander.kashyap@linaro.org>
Date: Mon, 19 May 2014 08:04:30 -0500
X-Google-Sender-Auth: 7Pymbs_2Xq2-I8vXUSkkJFz06c0
Message-ID: <CAGo_u6oQiOJzp2DCCFUfwWWPLKKw=pgZPgdr9LBqfYs-GKb9zg@mail.gmail.com>
Subject: Re: [PATCH] PM / OPP: fix incorrect OPP count handling in of_init_opp_table
From: Nishanth Menon <nm@ti.com>
To: Chander Kashyap <chander.kashyap@linaro.org>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>, pavel@ucw.cz,
        Len Brown <len.brown@intel.com>, gregkh@linuxfoundation.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Chander Kashyap <k.chander@samsung.com>,
        Inderpal Singh <inderpal.s@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2014 at 5:51 AM, Chander Kashyap
<chander.kashyap@linaro.org> wrote:
> In of_init_opp_table function, if a failure to add an OPP is
> detected, the count of OPPs, yet to be added is not updated.
> Fix this by decrementing this count on failure as well.
>
> Signed-off-by: Chander Kashyap <k.chander@samsung.com>
> Signed-off-by: Inderpal Singh <inderpal.s@samsung.com>
> ---
>  drivers/base/power/opp.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
> index d9e376a..faae9cf 100644
> --- a/drivers/base/power/opp.c
> +++ b/drivers/base/power/opp.c
> @@ -643,11 +643,9 @@ int of_init_opp_table(struct device *dev)
>                 unsigned long freq = be32_to_cpup(val++) * 1000;
>                 unsigned long volt = be32_to_cpup(val++);
>
> -               if (dev_pm_opp_add(dev, freq, volt)) {
> +               if (dev_pm_opp_add(dev, freq, volt))
>                         dev_warn(dev, "%s: Failed to add OPP %ld\n",
>                                  __func__, freq);
> -                       continue;
> -               }
>                 nr -= 2;
>         }
Good Catch. Thanks.

Acked-by: Nishanth Menon <nm@ti.com>

--
Regards,
Nishanth Menon
