Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756963Ab3CZSQG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 14:16:06 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:57010 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755588Ab3CZSQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 14:16:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH v2.2] dw_dmac: remove unnecessary ENODEV check
Date: Tue, 26 Mar 2013 18:15:54 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-13-generic; KDE/4.3.2; x86_64; ; )
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        "spear-devel" <spear-devel@list.st.com>,
        "Lars-Peter Clausen" <lars@metafoo.de>
References: <CAKohponTj8iHTZqs2pS9m1mOqgbGX5WUDa7B2-xcDP_0sN7ZsQ@mail.gmail.com> <1364318953-5219-1-git-send-email-andriy.shevchenko@linux.intel.com> <CAKohpomxgQy0f51nYePaKs03Us4zfxQy+-_C6J9kYqNK8_iJoQ@mail.gmail.com>
In-Reply-To: <CAKohpomxgQy0f51nYePaKs03Us4zfxQy+-_C6J9kYqNK8_iJoQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303261815.54755.arnd@arndb.de>
X-Provags-ID: V02:K0:b8gHssOnY1+hY44yd8KyU199qec1srVIG2DyHfISv0x
 oa+46IPWydC7/3/B8yvlqiPDefHxTFWv3JkyYjrVzyYW4fBD81
 677SdyCb1uWQaBgEvDF9SFEqEtNOyLcu1cHY20GsWgJa6MLBmA
 SqTA62Nyc0mm1qp1rKRZ9pfJlW5vMalgi3HWQJHlti06aEMjCG
 MpAN+8Bn7sfL9XTdg5UU3iQe4a9SXx0fF9zd7x3iQvqDn8YlkQ
 Z7vcf7jt8fsV2XtrUZ8vb9dy7nTqC4kYtNYh+0t9mSMyXPW2bX
 Vv+5u64aZI82Ri6sNSnPBhOqjFQglstf+ArS1fJ6BGELpSRP77
 xPxt588uas9BBjSAEYAU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 March 2013, Viresh Kumar wrote:
> 
> On 26 March 2013 22:59, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
> > If CONFIG_OF is not set the of_node of the device will always be NULL.
> >
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > ---
> >  drivers/dma/dw_dmac.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> > index 274fd7d..736cffa 100644
> > --- a/drivers/dma/dw_dmac.c
> > +++ b/drivers/dma/dw_dmac.c
> > @@ -1846,7 +1846,7 @@ static int dw_probe(struct platform_device *pdev)
> >         if (pdev->dev.of_node) {
> >                 err = of_dma_controller_register(pdev->dev.of_node,
> >                                                  dw_dma_of_xlate, dw);
> > -               if (err && err != -ENODEV)
> > +               if (err)
> >                         dev_err(&pdev->dev,
> >                                 "could not register of_dma_controller\n");
> 
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>
