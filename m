Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334Ab3DLLvn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 07:51:43 -0400
Received: from mail-ia0-f180.google.com ([209.85.210.180]:44016 "EHLO
	mail-ia0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074Ab3DLLvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 07:51:41 -0400
MIME-Version: 1.0
In-Reply-To: <1586707.acL064pYmb@vostro.rjw.lan>
References: <CAKohpo=t_YTCTRCfnwQ+GPF=frsTGDigT3RZHJuVQ+R+YZU7Hg@mail.gmail.com>
	<1365415054-30771-1-git-send-email-amit.daniel@samsung.com>
	<CAGo_u6oZM0K8XDMtmXKFyoGy2qf+-HSPvU0EMangM5Jj_prKsA@mail.gmail.com>
	<1586707.acL064pYmb@vostro.rjw.lan>
Date: Fri, 12 Apr 2013 17:21:40 +0530
X-Google-Sender-Auth: E7ZacrSdds7s8xUjHIVtwZjB4E8
Message-ID: <CADGdYn4qJRuLz8=PoXNRRwaNpKO92UshuiQTaK6W6Jj4p79T1A@mail.gmail.com>
Subject: Re: [RESEND PATCH V6 1/4] cpufreq: exynos: Add cpufreq driver for exynos5440
From: amit daniel kachhap <amit.daniel@samsung.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Nishanth Menon <nm@ti.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-pm@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>, cpufreq@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        Thomas Abraham <thomas.abraham@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Inderpal Singh <inderpal.singh@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

On Fri, Apr 12, 2013 at 4:49 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Thursday, April 11, 2013 06:23:52 PM Nishanth Menon wrote:
>> Hi,
>> On Mon, Apr 8, 2013 at 4:57 AM, Amit Daniel Kachhap
>> <amit.daniel@samsung.com> wrote:
>> > +
>> > +static int init_div_table(void)
>> > +{
>> > +       struct cpufreq_frequency_table *freq_tbl = dvfs_info->freq_table;
>> > +       unsigned int tmp, clk_div, ema_div, freq, volt_id;
>> > +       int i = 0;
>> > +       struct opp *opp;
>> > +
>> > +       for (i = 0; freq_tbl[i].frequency != CPUFREQ_TABLE_END; i++) {
>> > +
>> > +               opp = opp_find_freq_exact(dvfs_info->dev,
>> > +                                       freq_tbl[i].frequency * 1000, true);
>> > +               if (IS_ERR(opp)) {
>> > +                       dev_err(dvfs_info->dev,
>> > +                               "failed to find valid OPP for %u KHZ\n",
>> > +                               freq_tbl[i].frequency);
>> > +                       return PTR_ERR(opp);
>> > +               }
>> please use RCU read locks.
>>
>> > +
>> > +               freq = freq_tbl[i].frequency / 1000; /* In MHZ */
>> > +               clk_div = ((freq / CPU_DIV_FREQ_MAX) & P0_7_CPUCLKDEV_MASK)
>> > +                                       << P0_7_CPUCLKDEV_SHIFT;
>> > +               clk_div |= ((freq / CPU_ATB_FREQ_MAX) & P0_7_ATBCLKDEV_MASK)
>> > +                                       << P0_7_ATBCLKDEV_SHIFT;
>> > +               clk_div |= ((freq / CPU_DBG_FREQ_MAX) & P0_7_CSCLKDEV_MASK)
>> > +                                       << P0_7_CSCLKDEV_SHIFT;
>> > +
>> > +               /* Calculate EMA */
>> > +               volt_id = opp_get_voltage(opp);
>> Please use RCU read locks as documented for OPP library.
>
> Argh.  I overlooked that and the series has been applied already.  Care to send
> a fix against linux-pm.git/linux-next?

Will submit a patch with RCU lock changes.

Thanks,
Amit Daniel
>
> Rafael
>
>
> --
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
