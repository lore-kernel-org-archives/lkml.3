Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256AbbAEPdT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 10:33:19 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:35215 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752838AbbAEPdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 10:33:18 -0500
Message-ID: <1420471996.2090.9.camel@mm-sol.com>
Subject: Re: [PATCH RFC] iio: iadc: wait_for_completion_timeout time in
 jiffies
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Jonathan Cameron <jic23@kernel.org>
Cc: Nicholas Mc Guire <der.herr@hofr.at>, Hartmut Knaack <knaack.h@gmx.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Date: Mon, 05 Jan 2015 17:33:16 +0200
In-Reply-To: <54A9212B.8050709@kernel.org>
References: <1420016386-19638-1-git-send-email-der.herr@hofr.at>
	 <54A9212B.8050709@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.13.7-fta1.2~trusty 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2015-01-04 at 11:16 +0000, Jonathan Cameron wrote:
> On 31/12/14 08:59, Nicholas Mc Guire wrote:
> > The timeout value to wait_for_completion_timeout is in jiffies but
> > the value being passed seems like it was intended to by microseconds
> > Note that the timeout was extremely long thus it might be too short
> > now. In any case it probably should be passed through usecs_to_jiffies()
> > or msecs_to_jiffies()
> > 
> > patch is against linux-next 3.19.0-rc1 -next-20141226
> > 
> > patch was only compile-tested x86_64_defcofnig + CONFIG_SPMI=m
> > CONFIG_IIO=m, CONFIG_QCOM_SPMI_IADC=m
> > 
> > Signed-off-by: Nicholas Mc Guire herr@hofr.at>
> Certainly suspicious and I'd draw the same conclusion you did!
> Anyhow just waiting for Ivan to take a look as it's his driver.

Oops, true. Timeout is calculated in microseconds and have to 
be converted to jiffies.

Thanks.

Acked-by: Ivan T. Ivanov <iivanov@mm-sol.com>


> 
> Thanks,
> 
> Jonathan
> > ---
> >  drivers/iio/adc/qcom-spmi-iadc.c |    3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/iio/adc/qcom-spmi-iadc.c b/drivers/iio/adc/qcom-spmi-iadc.c
> > index b9666f2..3080562 100644
> > --- a/drivers/iio/adc/qcom-spmi-iadc.c
> > +++ b/drivers/iio/adc/qcom-spmi-iadc.c
> > @@ -296,7 +296,8 @@ static int iadc_do_conversion(struct iadc_chip *iadc, int chan, u16 *data)
> >         if (iadc->poll_eoc) {
> >                 ret = iadc_poll_wait_eoc(iadc, wait);
> >         } else {
> > -               ret = wait_for_completion_timeout(&iadc->complete, wait);
> > +               ret = wait_for_completion_timeout(&iadc->complete,
> > +                       usecs_to_jiffies(wait));
> >                 if (!ret)
> >                         ret = -ETIMEDOUT;
> >                 else
> > 
> 
> 
