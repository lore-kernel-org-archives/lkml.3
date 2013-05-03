Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763181Ab3ECLEb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 07:04:31 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:38312 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760924Ab3ECLEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 07:04:30 -0400
Date: Fri, 3 May 2013 12:04:24 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Bengt =?iso-8859-1?Q?J=F6nsson?= <bengt.g.jonsson@stericsson.com>
Subject: Re: [PATCH 2/4] mfd: ab8500-gpadc: Suppress 'ignoring
 regulator_enable() return value' warning
Message-ID: <20130503110424.GG24153@gmail.com>
References: <1367509690-24022-1-git-send-email-lee.jones@linaro.org>
 <1367509690-24022-3-git-send-email-lee.jones@linaro.org>
 <CACRpkdaf75sQduyfw58PFmC1ZyNDMxpwAf0OSyRLPP6vFc+wBQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdaf75sQduyfw58PFmC1ZyNDMxpwAf0OSyRLPP6vFc+wBQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 03 May 2013, Linus Walleij wrote:

> On Thu, May 2, 2013 at 5:48 PM, Lee Jones <lee.jones@linaro.org> wrote:
> > drivers/mfd/ab8500-gpadc.c: In function ‘ab8500_gpadc_resume’:
> > drivers/mfd/ab8500-gpadc.c:911:18: warning: ignoring return value of
> >         ‘regulator_enable’, declared with attribute warn_unused_result
> >         [-Wunused-result]
> >
> > Cc: Samuel Ortiz <sameo@linux.intel.com>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  drivers/mfd/ab8500-gpadc.c |    5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/mfd/ab8500-gpadc.c b/drivers/mfd/ab8500-gpadc.c
> > index 5e65b28..7278e53 100644
> > --- a/drivers/mfd/ab8500-gpadc.c
> > +++ b/drivers/mfd/ab8500-gpadc.c
> > @@ -907,8 +907,11 @@ static int ab8500_gpadc_suspend(struct device *dev)
> >  static int ab8500_gpadc_resume(struct device *dev)
> >  {
> >         struct ab8500_gpadc *gpadc = dev_get_drvdata(dev);
> > +       int ret;
> >
> > -       regulator_enable(gpadc->regu);
> > +       ret = regulator_enable(gpadc->regu);
> > +       if (ret < 0)
> > +               return ret;
> >
> >         pm_runtime_mark_last_busy(gpadc->dev);
> >         pm_runtime_put_autosuspend(gpadc->dev);
> 
> Acked-by: Linus Walleij <linus.walleij@linaro.org>

As it has your Ack, I'm going to add an error print as per Srinidhi's
suggestion, test it again and apply this to my MFD tree.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
