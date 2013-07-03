Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925Ab3GCLzz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 07:55:55 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:39189 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab3GCLzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 07:55:54 -0400
MIME-Version: 1.0
In-Reply-To: <1372072858-6559-3-git-send-email-yadi.brar@samsung.com>
References: <1372072858-6559-1-git-send-email-yadi.brar@samsung.com>
	<1372072858-6559-3-git-send-email-yadi.brar@samsung.com>
Date: Wed, 3 Jul 2013 17:25:54 +0530
Message-ID: <CAK9yfHy1fFdU1zGcxMsoeYnz8tb-JktSYBScc+Soqge8Q-++Rw@mail.gmail.com>
Subject: Re: [PATCH 2/4] regulator: s2mps11: Implement set_voltage_time_sel()
 ops for bucks
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Yadwinder Singh Brar <yadi.brar@samsung.com>
Cc: linux-kernel@vger.kernel.org, yadi.brar01@gmail.com, sbkim73@samsung.com,
        broonie@kernel.org, lgirdwood@gmail.com, sameo@linux.intel.com,
        rob.herring@calxeda.com, grant.likely@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 June 2013 16:50, Yadwinder Singh Brar <yadi.brar@samsung.com> wrote:
> Currently driver uses local struct s2mps11_info to store ramp rate for bucks
> whic its getting through platform data, so instead of using regulator
> constraints it should use s2mps11_info to calculate ramp delay.
>
> Signed-off-by: Yadwinder Singh Brar <yadi.brar@samsung.com>
[snip]
> +
> +       switch (rdev->desc->id) {
> +       case S2MPS11_BUCK2:
> +               if (!s2mps11->buck2_ramp)
> +                       return 0;
> +               ramp_delay = s2mps11->ramp_delay2;
> +               break;
> +       case S2MPS11_BUCK3:
> +               if (!s2mps11->buck3_ramp)
> +                       return 0;
> +               ramp_delay = s2mps11->ramp_delay34;
> +               break;
> +       case S2MPS11_BUCK4:
> +               if (!s2mps11->buck4_ramp)
> +                       return 0;
> +               ramp_delay = s2mps11->ramp_delay34;
> +               break;
> +       case S2MPS11_BUCK5:
> +               ramp_delay = s2mps11->ramp_delay5;
> +               break;
> +       case S2MPS11_BUCK6:
> +               if (!s2mps11->buck6_ramp)
> +                       return 0;
> +       case S2MPS11_BUCK1:

nit: Why not have this at the beginning?

> +               ramp_delay = s2mps11->ramp_delay16;
> +               break;
> +       case S2MPS11_BUCK7:
> +       case S2MPS11_BUCK8:
> +       case S2MPS11_BUCK10:
> +               ramp_delay = s2mps11->ramp_delay7810;
> +               break;
> +       case S2MPS11_BUCK9:
> +               ramp_delay = s2mps11->ramp_delay9;
> +       }

How about adding a break statement above?

-- 
With warm regards,
Sachin
