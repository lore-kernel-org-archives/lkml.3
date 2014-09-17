Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756434AbaIQQtc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 12:49:32 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:49898 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756393AbaIQQt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 12:49:29 -0400
Date: Wed, 17 Sep 2014 09:49:25 -0700
From: Lee Jones <lee.jones@linaro.org>
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Daniel Walker <dwalker@fifo99.com>,
        David Brown <davidb@codeaurora.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: ssbi: promote the driver to subsys level
Message-ID: <20140917164925.GO30918@lee--X1>
References: <1410915594-15599-1-git-send-email-srinivas.kandagatla@linaro.org>
 <20140917160305.GH30918@lee--X1>
 <CAGkH4DOPHQWBVZgiLZugcoTZNJiS-ar8KNvq96W5UmX8C6GCTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGkH4DOPHQWBVZgiLZugcoTZNJiS-ar8KNvq96W5UmX8C6GCTg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Sep 2014, Srinivas Kandagatla wrote:

> On 17 Sep 2014 09:03, "Lee Jones" <lee.jones@linaro.org> wrote:
> >
> > On Wed, 17 Sep 2014, Srinivas Kandagatla wrote:
> >
> > > This patch promtes the driver to be at subsystem level as this driver
> > > will be used by gpio controller drivers which inturn are used by many
> > > platform drivers.
> >
> > Any reason why you're not using -EPROBE?
> >
> EPROBE is possible but it's going to add few more cycles to boot time.
> 
> As this driver is a very basic driver on which other drivers depend
> ensuring the sequence would improve the boot time.

We only tend to promote drivers' init level as a last resort.  If
-EPROBE_DEFER is possible, please use that instead.

> > > Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> > > ---
> > >  drivers/mfd/ssbi.c | 7 ++++++-
> > >  1 file changed, 6 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/mfd/ssbi.c b/drivers/mfd/ssbi.c
> > > index b78942e..4fbe02e 100644
> > > --- a/drivers/mfd/ssbi.c
> > > +++ b/drivers/mfd/ssbi.c
> > > @@ -331,7 +331,12 @@ static struct platform_driver ssbi_driver = {
> > >               .of_match_table = ssbi_match_table,
> > >       },
> > >  };
> > > -module_platform_driver(ssbi_driver);
> > > +
> > > +static int ssbi_init(void)
> > > +{
> > > +     return platform_driver_register(&ssbi_driver);
> > > +}
> > > +subsys_initcall(ssbi_init);
> > >
> > >  MODULE_LICENSE("GPL v2");
> > >  MODULE_VERSION("1.0");
> >

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
