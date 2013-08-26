Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315Ab3HZHDQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 03:03:16 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:60089 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755892Ab3HZHDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 03:03:14 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-0e-521afda73ce6
Date: Mon, 26 Aug 2013 09:02:55 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        "R, Durgadoss" <durgadoss.r@intel.com>
Subject: Re: [PATCH v7 1/7] cpufreq: Add boost frequency support in core
Message-id: <20130826090255.01b1f299@amdc308.digital.local>
In-reply-to: <CAKohpo=m=smN-qk45dSdq8SOwAyqtE1xLV-Y85GaCbVhBDsmjQ@mail.gmail.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1376388505-30233-1-git-send-email-l.majewski@samsung.com>
 <1376388505-30233-2-git-send-email-l.majewski@samsung.com>
 <CAKohpo=m=smN-qk45dSdq8SOwAyqtE1xLV-Y85GaCbVhBDsmjQ@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAIsWRmVeSWpSXmKPExsVy+t9jAd3lf6WCDKZ+5bfYOGM9q8XTph/s
	FvM+y1r0/bzCbLFm/08mi86zT5gtehdcZbN484jb4vKuOWwWn3uPMFrcblzBZtG/sJfJ4snD
	PjaLjV89HPg8Fu95yeRx59oeNo91094ye/RtWcXo8WhxC6PH8RvbmTw+b5ILYI/isklJzcks
	Sy3St0vgyti+q6TgkljFj/UP2BoYp/N3MXJySAiYSMxvvM0MYYtJXLi3nq2LkYtDSGARo8Ss
	jYcZIZx2Jom7fZvYQKpYBFQlVi84AdbBJqAn8fnuU6YuRg4OEQEtiZc3U0HqmQV2skgse3+L
	ESQuLOAh0XI8DqScV8Ba4u2mL2wgYU6BYImOaQ4Q49uYJA5/7Acbzy8gKdH+7wfUQXYS5z5t
	YIfoFZT4MfkeC4jNDLRq87YmVghbXmLzmrfMExgFZyEpm4WkbBaSsgWMzKsYRVMLkguKk9Jz
	jfSKE3OLS/PS9ZLzczcxguPpmfQOxlUNFocYBTgYlXh4VxRJBQmxJpYVV+YeYpTgYFYS4XV1
	kAwS4k1JrKxKLcqPLyrNSS0+xCjNwaIkznuw1TpQSCA9sSQ1OzW1ILUIJsvEwSnVwLhRuan2
	q55P5ILNJ+xvhAseeLnM+fyU+Adi56rCZ/vOY0m2WvY79lNd2K3eONG7Sz6u12bK8AnxTUn8
	+Nhqun6Q3M5ks/cvouQ55J9JpZfaTmteJ35+qcczy76HX1ZzuavnTNVefWZZTbGQQWhb36pE
	q30t6SvfTr57O7/Y5uku2b8PWDfcL1JiKc5INNRiLipOBABjRlMoowIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Aug 2013 10:58:53 +0530 Viresh Kumar viresh.kumar@linaro.org
wrote,
> Some minor nitpicking, nothing much :)

Is there any chance to pull those corrected patches to v3.12?

> 
> On 13 August 2013 15:38, Lukasz Majewski <l.majewski@samsung.com>
> wrote:
> > diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> > +static int cpufreq_boost_set_sw(int state)
> > +{
> > +       struct cpufreq_frequency_table *freq_table;
> > +       struct cpufreq_policy *policy;
> > +       int ret = -EINVAL;
> > +
> > +       list_for_each_entry(policy, &cpufreq_policy_list,
> > policy_list) {
> > +               freq_table =
> > cpufreq_frequency_get_table(policy->cpu);
> > +               if (freq_table) {
> > +                       ret =
> > cpufreq_frequency_table_cpuinfo(policy,
> > +                                                       freq_table);
> > +                       if (!ret) {
> > +                               policy->user_policy.max =
> > policy->max;
> > +                               __cpufreq_governor(policy,
> > CPUFREQ_GOV_LIMITS);
> > +                       }
> 
> In case ret wasn't 0 (i.e. we failed), we should print an error
> message and break
> our loop ?

After your comments I think, that this code could be rewritten:


	list_for_each_entry(policy, &cpufreq_policy_list, policy_list) {
		freq_table = cpufreq_frequency_get_table(policy->cpu);
		if (freq_table) {
			ret = cpufreq_frequency_table_cpuinfo(policy,
							freq_table);
			if (ret) {
				pr_err("%s: Policy frequency update
				failed\n")
				break;
			}
			
			policy->user_policy.max = policy->max;
			__cpufreq_governor(policy,CPUFREQ_GOV_LIMITS);	
		}
	}

	return ret;
}


> 
> > +               }
> > +       }
> > +
> > +       return ret;
> > +}
> > +
> > +int cpufreq_boost_trigger_state(int state)
> > +{
> > +       unsigned long flags;
> > +       int ret = 0;
> > +
> > +       if (cpufreq_driver->boost_enabled == state)
> > +               return 0;
> > +
> > +       write_lock_irqsave(&cpufreq_driver_lock, flags);
> > +       cpufreq_driver->boost_enabled = state;
> > +       write_unlock_irqrestore(&cpufreq_driver_lock, flags);
> > +
> > +       ret = cpufreq_driver->set_boost(state);
> > +       if (ret) {
> > +               write_lock_irqsave(&cpufreq_driver_lock, flags);
> > +               cpufreq_driver->boost_enabled = !state;
> > +               write_unlock_irqrestore(&cpufreq_driver_lock,
> > flags); +
> > +               pr_err("%s: Cannot %s BOOST\n", __func__,
> > +                      state ? "enabled" : "disabled");
> 
> s/enabled/enable and s/disabled/disable

Ok.

> 
> > +       }
> > +
> > +       return ret;
> > +}
> > +



-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
