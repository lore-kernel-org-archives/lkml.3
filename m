Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620Ab3F0JtG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 05:49:06 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:47666 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab3F0JtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 05:49:04 -0400
X-AuditID: cbfee61b-b7f8e6d00000524c-b0-51cc0a8dd981
Date: Thu, 27 Jun 2013 11:48:52 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocky" <rjw@sisk.pl>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>, t.figa@samsung.com
Subject: Re: [PATCH v4 2/7] cpufreq: Add boost frequency support in core
Message-id: <20130627114852.2889eea6@amdc308.digital.local>
In-reply-to: <CAKohpo==702FnSwhrPi6L1VzLbxO5LT3VDQCru9cwKjgmbppxA@mail.gmail.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1371661969-7660-1-git-send-email-l.majewski@samsung.com>
 <1371661969-7660-3-git-send-email-l.majewski@samsung.com>
 <CAKohpon7GLGvrkFQdWpco5f9P7S8L-2-ETMu2-3dFEDwOgL1RQ@mail.gmail.com>
 <20130626145412.1e9bfa63@amdc308.digital.local>
 <CAKohpo==702FnSwhrPi6L1VzLbxO5LT3VDQCru9cwKjgmbppxA@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOIsWRmVeSWpSXmKPExsVy+t9jAd1erjOBBve361r8ebuc1eJp0w92
	i3mfZS3W7P/JZNF59gmzRe+Cq2wWbx5xW1zeNYfN4nPvEUaL240r2Cz6F/YyWTx52MdmsX7G
	axaLjiPfmC02fvVw4PdYvOclk8eda3vYPNZNe8vs0bdlFaPHo8UtjB7Hb2xn8vi8SS6APYrL
	JiU1J7MstUjfLoErY9fGf+wFC2UrFr2Wb2DcJ9rFyMkhIWAicezLR3YIW0ziwr31bF2MXBxC
	AosYJT40rWKEcNqZJHY9WMICUsUioCrxpLeBDcRmE9CT+Hz3KVMXIweHiICWxMubqSD1zAKn
	WSR2PLgGNlVYwENi+65+VhCbV8Ba4t+8l2A2p0CwxLvvq5khFvxlknizaitYgl9AUqL93w9m
	iJPsJM592sAO0Swo8WPyPbAjmIGWbd7WxAphy0tsXvOWeQKj4CwkZbOQlM1CUraAkXkVo2hq
	QXJBcVJ6rpFecWJucWleul5yfu4mRnB0PZPewbiqweIQowAHoxIP7wfG04FCrIllxZW5hxgl
	OJiVRHgvMpwJFOJNSaysSi3Kjy8qzUktPsQozcGiJM57sNU6UEggPbEkNTs1tSC1CCbLxMEp
	1cAYrfs8xPvCi7l/er//c3v9puT3M7GtZkdCQxcsvh+3TG7f2wtsl2ad3FCzIri9J+fh8qr/
	RY5yT9WTVj05mvl097e7BY9+Re+f7L3+h4HdebmW+Har57dlI2xN67dt764S22TQ+0E1fWX6
	pKWhbtONNorLpQZdan/js7Wb8fcEcSOTCosZv3RClFiKMxINtZiLihMBg6B3xKoCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Jun 2013 14:32:57 +0530, Viresh Kumar wrote:
> On 26 June 2013 18:24, Lukasz Majewski <l.majewski@samsung.com> wrote:
> > On Wed, 26 Jun 2013 16:24:32 +0530, Viresh Kumar wrote:
> >> On 19 June 2013 22:42, Lukasz Majewski <l.majewski@samsung.com>
> >> wrote:
> 
> >> > +static ssize_t store_boost(struct kobject *kobj, struct
> >> > attribute *attr,
> >> > +                                 const char *buf, size_t count)
> >> > +{
> >> > +       int ret, enable;
> >> > +
> >> > +       ret = sscanf(buf, "%d", &enable);
> >> > +       if (ret != 1 || enable < 0 || enable > 1)
> >> > +               return -EINVAL;
> >> > +
> >> > +       if (cpufreq_boost_trigger_state(enable)) {
> >> > +               pr_err("%s: Cannot enable boost!\n", __func__);
> >> > +               return -EINVAL;
> >> > +       }
> >>
> >> Probably do boost_enabled = true here.
> >
> > I would prefer to set boot_enabled at
> > cpufreq_boost_trigger_state() method. It is closer to the
> > cpufreq_driver->enable_boost and cpufreq_boost_trigger_state_sw();
> > functions, which do change the freq.
> 
> I said that as this will be more inclined towards the purpose of
> this routine. This routine should store boost as show_boost()
> is returning it. So, what would be better is if you just return
> 0 or err from cpufreq_boost_trigger_state() and then set boost
> here. This will also solve your problem where you revert back
> to older boost value for failure cases.

I thought about this idea, but at cpufreq_boost_trigger_state_sw()
I iterate through all available policies and call
cpufreq_frequency_table_cpuinfo()[*] on them. In this routine [*] I use 
cpufreq_boost_enabled() [**] route to search for maximal (boost)
frequency.
The [**] reads boost_enabled flag, which shall be updated before. When
this search fails, then I restore the old value of boost_enabled. 

> 
> >> > +                       ret =
> >> > cpufreq_driver->enable_boost(state);
> >                                                   ^^^^^^^^^^^^^
> >                                         I would prefer to change
> > this name to enable_boost_hw
> > It is more informative, since it is tailored to hw based boost
> > (Intel).
> 
> Ok

OK.

> 
> >> > +               else
> >> > +                       ret = cpufreq_boost_trigger_state_sw();
> 
> then why not enable_boost_sw() here? that would be more
> relevant.

Could you be more specific here?

The distinction here is done on purpose:

You can either call cpufreq_driver->enable_boost for HW controlled
boost or cpufreq_boost_trigger_state_sw() for SW controlled one.

I could write:
	if (cpufreq_driver->enable_boost)
		ret = cpufreq_driver->enable_boost(state);

	ret = cpufreq_boost_trigger_state_sw();

But then for Intel CPUs I will iterate over its policies to seek for
CPUFREQ_BOOST_FREQ marked frequencies without any purpose, since HW is
taking care of boosting. 

> 
> > I will rewrite it as follow:
> >
> > if (ret)
> >         boost_enabled = 0;
> >
> > write_unlock_irqrestore(&cpufreq_driver_lock, flags);
> > pr_debug("%s: cpufreq BOOST %s\n", __func__,
> >                  state ? "enabled" : "disabled");
> 
> So, you will not print error but current state? Probably
> printing error is better.

I will change it to:

write_unlock_irqrestore(&cpufreq_driver_lock, flags);
if (ret)
	pr_err("%s: BOOST cannot enable (%d)\n",
			       __func__, ret);

return ret;

I want to avoid time consuming operations (like print) with holding
lock (and boost_enabled shall be modified under lock).

-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
