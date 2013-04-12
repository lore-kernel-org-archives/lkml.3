Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197Ab3DLLLm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 07:11:42 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:56932 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752878Ab3DLLLk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 07:11:40 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nishanth Menon <nm@ti.com>
Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>, linux-pm@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>, cpufreq@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Inderpal Singh <inderpal.singh@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RESEND PATCH V6 1/4] cpufreq: exynos: Add cpufreq driver for exynos5440
Date: Fri, 12 Apr 2013 13:19:28 +0200
Message-ID: <1586707.acL064pYmb@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc6+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAGo_u6oZM0K8XDMtmXKFyoGy2qf+-HSPvU0EMangM5Jj_prKsA@mail.gmail.com>
References: <CAKohpo=t_YTCTRCfnwQ+GPF=frsTGDigT3RZHJuVQ+R+YZU7Hg@mail.gmail.com> <1365415054-30771-1-git-send-email-amit.daniel@samsung.com> <CAGo_u6oZM0K8XDMtmXKFyoGy2qf+-HSPvU0EMangM5Jj_prKsA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, April 11, 2013 06:23:52 PM Nishanth Menon wrote:
> Hi,
> On Mon, Apr 8, 2013 at 4:57 AM, Amit Daniel Kachhap
> <amit.daniel@samsung.com> wrote:
> > +
> > +static int init_div_table(void)
> > +{
> > +       struct cpufreq_frequency_table *freq_tbl = dvfs_info->freq_table;
> > +       unsigned int tmp, clk_div, ema_div, freq, volt_id;
> > +       int i = 0;
> > +       struct opp *opp;
> > +
> > +       for (i = 0; freq_tbl[i].frequency != CPUFREQ_TABLE_END; i++) {
> > +
> > +               opp = opp_find_freq_exact(dvfs_info->dev,
> > +                                       freq_tbl[i].frequency * 1000, true);
> > +               if (IS_ERR(opp)) {
> > +                       dev_err(dvfs_info->dev,
> > +                               "failed to find valid OPP for %u KHZ\n",
> > +                               freq_tbl[i].frequency);
> > +                       return PTR_ERR(opp);
> > +               }
> please use RCU read locks.
> 
> > +
> > +               freq = freq_tbl[i].frequency / 1000; /* In MHZ */
> > +               clk_div = ((freq / CPU_DIV_FREQ_MAX) & P0_7_CPUCLKDEV_MASK)
> > +                                       << P0_7_CPUCLKDEV_SHIFT;
> > +               clk_div |= ((freq / CPU_ATB_FREQ_MAX) & P0_7_ATBCLKDEV_MASK)
> > +                                       << P0_7_ATBCLKDEV_SHIFT;
> > +               clk_div |= ((freq / CPU_DBG_FREQ_MAX) & P0_7_CSCLKDEV_MASK)
> > +                                       << P0_7_CSCLKDEV_SHIFT;
> > +
> > +               /* Calculate EMA */
> > +               volt_id = opp_get_voltage(opp);
> Please use RCU read locks as documented for OPP library.

Argh.  I overlooked that and the series has been applied already.  Care to send
a fix against linux-pm.git/linux-next?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
