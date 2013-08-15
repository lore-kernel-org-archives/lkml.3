Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab3HOJHZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 05:07:25 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:59231 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258Ab3HOJHV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 05:07:21 -0400
MIME-Version: 1.0
In-Reply-To: <1376550128.2335.110.camel@rzhang-lenovo>
References: <1375864269-9197-1-git-send-email-ch.naveen@samsung.com> <1376550128.2335.110.camel@rzhang-lenovo>
From: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Date: Thu, 15 Aug 2013 14:37:00 +0530
Message-ID: <CAHfPSqAoW93fQrchgwU8BjwYq0typdAUh9+dAf1A2JRcp8GbbQ@mail.gmail.com>
Subject: Re: [PATCH] thermal: exynos_tmu: fix wrong error check for mapped memory
To: Zhang Rui <rui.zhang@intel.com>
Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>, linux-pm@vger.kernel.org,
        eduardo.valentin@ti.com,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, amit.daniel@samsung.com,
        Kukjin Kim <kgene.kim@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 August 2013 12:32, Zhang Rui <rui.zhang@intel.com> wrote:
>
> On 三, 2013-08-07 at 14:01 +0530, Naveen Krishna Chatradhi wrote:
> > The error check is checking for a "base" mapped memory base
> > instead of "base_common". Fixing the same.
> >
> > Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
>
> applied. Thanks!
> BTW, can you rebase the other three exynos patches you submitted?
I mistakenly rebased on the master branch.
Later found the code base is a lot different in the for-next branch.
I've it in my pipe line, Will submit at the soon.

Thanks Rui,

>
> thanks,
> rui
> > ---
> >  drivers/thermal/samsung/exynos_tmu.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
> > index ec01dfe..a033dbb 100644
> > --- a/drivers/thermal/samsung/exynos_tmu.c
> > +++ b/drivers/thermal/samsung/exynos_tmu.c
> > @@ -592,7 +592,7 @@ static int exynos_map_dt_data(struct platform_device *pdev)
> >
> >       data->base_common = devm_ioremap(&pdev->dev, res.start,
> >                                       resource_size(&res));
> > -     if (!data->base) {
> > +     if (!data->base_common) {
> >               dev_err(&pdev->dev, "Failed to ioremap memory\n");
> >               return -ENOMEM;
> >       }
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/




-- 
Shine bright,
(: Nav :)
