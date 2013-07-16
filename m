Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932615Ab3GPMHT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 08:07:19 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:25488 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932146Ab3GPMHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 08:07:16 -0400
X-AuditID: cbfee61a-b7f196d000007dfa-81-51e537512d5d
Date: Tue, 16 Jul 2013 14:06:32 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>, l.majewski@majess.pl,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH v5 2/7] cpufreq: Add boost frequency support in core
Message-id: <20130716140632.70fb2838@amdc308.digital.local>
In-reply-to: <CAKohpomfWKiRjznXeYsg32xAAWPTBQ4Gd0D_pftbA5=zMDiH4Q@mail.gmail.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1372927830-2949-1-git-send-email-l.majewski@samsung.com>
 <1372927830-2949-3-git-send-email-l.majewski@samsung.com>
 <CAKohpomfWKiRjznXeYsg32xAAWPTBQ4Gd0D_pftbA5=zMDiH4Q@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjkeLIzCtJLcpLzFFi42I5/e+xoG6g+dNAg4+9lhZ/3i5ntXja9IPd
	Yt5nWYs1+38yWXSefcJs0bvgKpvFm0fcFpd3zWGz+Nx7hNHiduMKNov+hb1MFk8e9rFZbPzq
	4cDrsXjPSyaPO9f2sHmsm/aW2aNvyypGj0eLWxg9jt/YzuTxeZNcAHsUl01Kak5mWWqRvl0C
	V0b7vxlMBZPEK1raG5gbGBcIdDFyckgImEjM2HyAGcIWk7hwbz1bFyMXh5DAdEaJFb8aGSGc
	diaJnWfuAmU4OFgEVCW2NUWANLAJ6El8vvuUCcQWEfCVWLRoMxNIPbPAOWaJxS+XsYIkhAU8
	JBbtvgNWxCtgLbGxez47iM0pECxxeOUJVogFLUwSnbO+sYAk+AUkJdr//YA6yU7i3KcN7BDN
	ghI/Jt8Dq2EW0JLYvK2JFcKWl9i85i3zBEbBWUjKZiEpm4WkbAEj8ypG0dSC5ILipPRcQ73i
	xNzi0rx0veT83E2M4Fh6JrWDcWWDxSFGAQ5GJR5eCZ4ngUKsiWXFlbmHGCU4mJVEeENMnwYK
	8aYkVlalFuXHF5XmpBYfYpTmYFES5z3Qah0oJJCeWJKanZpakFoEk2Xi4JRqYOQ23rhM/NH/
	bZH3fs5eYfxu/V/XxE1TKtc/02hor9XcE+QuWpi0Ju+Vly0ns0fm9nev5t00kt5u0vPesTc8
	5ITcsR8CqlKJ/A8ud18WNda0SxCVWPgiUuqxXfOuGyxnXxv9Fv22+VmicpLIZbH2vRMUojyX
	aPx/ftHe7C9PbKPYpVc3bINrK5VYijMSDbWYi4oTARd7CUShAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jul 2013 15:11:54 +0530 Viresh Kumar viresh.kumar@linaro.org
wrote,
> On 4 July 2013 14:20, Lukasz Majewski <l.majewski@samsung.com> wrote:
> > diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> 
> > +int cpufreq_boost_trigger_state(int state)
> > +{
> > +       unsigned long flags;
> > +       int ret = 0;
> > +
> > +       if (boost_enabled != state) {
> > +               write_lock_irqsave(&cpufreq_driver_lock, flags);
> > +               boost_enabled = state;
> > +
> > +               ret = cpufreq_driver->enable_boost(state);
> > +               if (ret)
> > +                       boost_enabled = 0;
> > +
> > +               write_unlock_irqrestore(&cpufreq_driver_lock,
> > flags); +
> > +               if (ret)
> > +                       pr_err("%s: BOOST cannot enable (%d)\n",
> 
> Who said we are enabling it?

You are right here - also disablement could fail. I will fix it.

> 
> > +                              __func__, ret);
> > +       }
> > +
> > +       return ret;
> > +}
> > +
> > +int cpufreq_boost_supported(void)
> > +{
> > +       if (cpufreq_driver)
> > +               return cpufreq_driver->boost_supported;
> > +
> > +       return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(cpufreq_boost_supported);
> > +
> > +int cpufreq_boost_enabled(void)
> > +{
> > +       return boost_enabled;
> > +}
> > +EXPORT_SYMBOL_GPL(cpufreq_boost_enabled);
> > +
> > +void cpufreq_set_boost_enabled(int state)
	  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ [*]

> 
> Maybe cpufreq_block_boost? As suggested by Rafael.

What do you mean by cpufreq_block_boost()? This name would reverse the
logic.

Function [*] is used to change boost_enabled static flag (defined at
cpufreq.c file) state according to acpi-cpufreq.c boost support status.


> 
> > +{
> > +       boost_enabled = state;
> > +}
> > +EXPORT_SYMBOL_GPL(cpufreq_set_boost_enabled);
> > +
> > +/*********************************************************************
> >   *               REGISTER / UNREGISTER CPUFREQ
> > DRIVER                *
> > *********************************************************************/
> >
> > @@ -2001,6 +2094,22 @@ int cpufreq_register_driver(struct
> > cpufreq_driver *driver_data) cpufreq_driver = driver_data;
> >         write_unlock_irqrestore(&cpufreq_driver_lock, flags);
> >
> > +       if (cpufreq_driver->boost_supported) {
> > +               /*
> > +                * Check if boost driver provides function to
> > enable boost -
> > +                * if not, use cpufreq_boost_enable_sw as default
> > +                */
> > +               if (!cpufreq_driver->enable_boost)
> > +                       cpufreq_driver->enable_boost =
> > &cpufreq_boost_enable_sw;
> 
> & is redundant.

Yes, correct. I will change that.

-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
