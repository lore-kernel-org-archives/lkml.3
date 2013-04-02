Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759559Ab3DBAJG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 20:09:06 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:49710 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758759Ab3DBAJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 20:09:04 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: myungjoo.ham@gmail.com
Cc: Rajagopal Venkat <rajagopal.venkat@linaro.org>,
        Kevin Hilman <khilman@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, patches@linaro.org,
        linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] PM / devfreq: Fix compiler warnings
Date: Tue, 02 Apr 2013 02:16:38 +0200
Message-ID: <2056616.R7YExf9Ucu@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAJ0PZbQNTLEmJQ_sRnByNCzwTKs84dGA7Ap2Yj5KRPefoeNsyw@mail.gmail.com>
References: <1364392374-12236-1-git-send-email-rajagopal.venkat@linaro.org> <1364392374-12236-2-git-send-email-rajagopal.venkat@linaro.org> <CAJ0PZbQNTLEmJQ_sRnByNCzwTKs84dGA7Ap2Yj5KRPefoeNsyw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, March 28, 2013 03:03:12 PM MyungJoo Ham wrote:
> On Wed, Mar 27, 2013 at 10:52 PM, Rajagopal Venkat
> <rajagopal.venkat@linaro.org> wrote:
> > Fix compiler warnings generated when devfreq is not enabled
> > (CONFIG_PM_DEVFREQ is not set).
> >
> > Signed-off-by: Rajagopal Venkat <rajagopal.venkat@linaro.org>
> 
> Thanks!
> 
> Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>

Applied.

Thanks,
Rafael


> > ---
> >  include/linux/devfreq.h |   16 ++++++++--------
> >  1 file changed, 8 insertions(+), 8 deletions(-)
> >
> > diff --git a/include/linux/devfreq.h b/include/linux/devfreq.h
> > index 04ad61d..5f1ab92 100644
> > --- a/include/linux/devfreq.h
> > +++ b/include/linux/devfreq.h
> > @@ -215,7 +215,7 @@ struct devfreq_simple_ondemand_data {
> >  #endif
> >
> >  #else /* !CONFIG_PM_DEVFREQ */
> > -static struct devfreq *devfreq_add_device(struct device *dev,
> > +static inline struct devfreq *devfreq_add_device(struct device *dev,
> >                                           struct devfreq_dev_profile *profile,
> >                                           const char *governor_name,
> >                                           void *data)
> > @@ -223,34 +223,34 @@ static struct devfreq *devfreq_add_device(struct device *dev,
> >         return NULL;
> >  }
> >
> > -static int devfreq_remove_device(struct devfreq *devfreq)
> > +static inline int devfreq_remove_device(struct devfreq *devfreq)
> >  {
> >         return 0;
> >  }
> >
> > -static int devfreq_suspend_device(struct devfreq *devfreq)
> > +static inline int devfreq_suspend_device(struct devfreq *devfreq)
> >  {
> >         return 0;
> >  }
> >
> > -static int devfreq_resume_device(struct devfreq *devfreq)
> > +static inline int devfreq_resume_device(struct devfreq *devfreq)
> >  {
> >         return 0;
> >  }
> >
> > -static struct opp *devfreq_recommended_opp(struct device *dev,
> > +static inline struct opp *devfreq_recommended_opp(struct device *dev,
> >                                            unsigned long *freq, u32 flags)
> >  {
> > -       return -EINVAL;
> > +       return ERR_PTR(-EINVAL);
> >  }
> >
> > -static int devfreq_register_opp_notifier(struct device *dev,
> > +static inline int devfreq_register_opp_notifier(struct device *dev,
> >                                          struct devfreq *devfreq)
> >  {
> >         return -EINVAL;
> >  }
> >
> > -static int devfreq_unregister_opp_notifier(struct device *dev,
> > +static inline int devfreq_unregister_opp_notifier(struct device *dev,
> >                                            struct devfreq *devfreq)
> >  {
> >         return -EINVAL;
> > --
> > 1.7.10.4
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
