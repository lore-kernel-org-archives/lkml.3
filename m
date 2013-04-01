Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407Ab3DAIwe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 04:52:34 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:57764 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755591Ab3DAIwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 04:52:32 -0400
MIME-Version: 1.0
In-Reply-To: <CA+V-a8vFrom92g4CE-Kc2gjK8HSo4xkFwMgfmycSJQib0AF+aQ@mail.gmail.com>
References: <1364798210-31517-1-git-send-email-prabhakar.csengg@gmail.com>
	<CA+Z25wXJt=vZnZ-ba+zkOWMgx0AjfnZT1JyHbaF4nuQ8MLvaKg@mail.gmail.com>
	<CA+V-a8vFrom92g4CE-Kc2gjK8HSo4xkFwMgfmycSJQib0AF+aQ@mail.gmail.com>
Date: Mon, 1 Apr 2013 14:22:32 +0530
Message-ID: <CA+Z25wWfB=OM2OKpCJRtS4b3rD9tDLewhLHvfOO3JmBEAqj5mw@mail.gmail.com>
Subject: Re: [PATCH v2] davinci: vpif: add pm_runtime support
From: Rajagopal Venkat <rajagopal.venkat@linaro.org>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LMML <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>, Sekhar Nori <nsekhar@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1 April 2013 13:53, Prabhakar Lad <prabhakar.csengg@gmail.com> wrote:
> On Mon, Apr 1, 2013 at 12:47 PM, Rajagopal Venkat
> <rajagopal.venkat@linaro.org> wrote:
>> On 1 April 2013 12:06, Prabhakar lad <prabhakar.csengg@gmail.com> wrote:
>>> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>>
>>> Add pm_runtime support to the TI Davinci VPIF driver.
>>>
>>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
>>> Cc: Hans Verkuil <hans.verkuil@cisco.com>
>>> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>>> Cc: Sakari Ailus <sakari.ailus@iki.fi>
>>> Cc: Sekhar Nori <nsekhar@ti.com>
>>> ---
>>>  Changes for v2:
>>>  1: Removed use of clk API as pointed by Laurent and Sekhar.
>>>
>>>  drivers/media/platform/davinci/vpif.c |   24 +++++++-----------------
>>>  1 files changed, 7 insertions(+), 17 deletions(-)
>>>
>>> diff --git a/drivers/media/platform/davinci/vpif.c b/drivers/media/platform/davinci/vpif.c
>>> index 28638a8..599cabb 100644
>>> --- a/drivers/media/platform/davinci/vpif.c
>>> +++ b/drivers/media/platform/davinci/vpif.c
>>> @@ -23,8 +23,8 @@
>>>  #include <linux/spinlock.h>
>>>  #include <linux/kernel.h>
>>>  #include <linux/io.h>
>>> -#include <linux/clk.h>
>>>  #include <linux/err.h>
>>> +#include <linux/pm_runtime.h>
>>>  #include <linux/v4l2-dv-timings.h>
>>>
>>>  #include <mach/hardware.h>
>>> @@ -44,7 +44,6 @@ static struct resource        *res;
>>>  spinlock_t vpif_lock;
>>>
>>>  void __iomem *vpif_base;
>>> -struct clk *vpif_clk;
>>>
>>>  /**
>>>   * ch_params: video standard configuration parameters for vpif
>>> @@ -439,19 +438,15 @@ static int vpif_probe(struct platform_device *pdev)
>>>                 goto fail;
>>>         }
>>>
>>> -       vpif_clk = clk_get(&pdev->dev, "vpif");
>>> -       if (IS_ERR(vpif_clk)) {
>>> -               status = PTR_ERR(vpif_clk);
>>> -               goto clk_fail;
>>> -       }
>>> -       clk_prepare_enable(vpif_clk);
>>> +       pm_runtime_enable(&pdev->dev);
>>> +       pm_runtime_resume(&pdev->dev);
>>> +
>>> +       pm_runtime_get(&pdev->dev);
>>
>> I don't see runtime-pm ops being registered. Can you explain how clock
>> prepare/unprepare is taken care by runtime-pm?
>>
> The pm_runtime API handles the clock management for you.
> For Davinci platform runtime PM support for clock management has
> been added (You can find it in  arch/arm/mach-davinci/pm_domain.c)
> When runtime PM is enabled, the davinci runtime PM implementation will
> use the pm_clk layer to enable/disable clocks on demand.

I see. Thanks for the explanation.

>
> For more/detailed understanding you can go through the pm_runtime framework.
>
> Regards,
> --Prabhakar



-- 
Regards,
Rajagopal
