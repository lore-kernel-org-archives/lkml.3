Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758419Ab3GZKK3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 06:10:29 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:31867 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454Ab3GZKK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 06:10:26 -0400
X-AuditID: cbfee61a-b7f196d000007dfa-4d-51f24b110223
Date: Fri, 26 Jul 2013 12:10:16 +0200
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
        Myungjoo Ham <myungjoo.ham@samsung.com>, durgadoss.r@intel.com,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Subject: Re: [PATCH v6 2/8] cpufreq: Add boost frequency support in core
Message-id: <20130726121016.6af979ca@amdc308.digital.local>
In-reply-to: <CAKohpokBGyHa=jHYpf358Aaa2kRko9=NtkS_2H_ywAn59h1axQ@mail.gmail.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1374770011-22171-1-git-send-email-l.majewski@samsung.com>
 <1374770011-22171-3-git-send-email-l.majewski@samsung.com>
 <CAKohpom9QHf+XBYQcajv4tni4_KA2x+Y3BAXWhZkdCFnZxp3XA@mail.gmail.com>
 <20130726103321.21238bbb@amdc308.digital.local>
 <CAKohpokBGyHa=jHYpf358Aaa2kRko9=NtkS_2H_ywAn59h1axQ@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLIsWRmVeSWpSXmKPExsVy+t9jQV1B70+BBhOvc1hsnLGe1eJp0w92
	i3mfZS36fl5htliz/yeTRefZJ8wWvQuuslm8ecRt8f7QM2aLy7vmsFl87j3CaHG7cQWbRf/C
	XiaLJw/72Cw2fvVw4PdYvOclk8eda3vYPG7/e8zssW7aW2aPvi2rGD0eLW5h9Dh+YzuTx+dN
	cgEcUVw2Kak5mWWpRfp2CVwZbTN2sxX8FKvo3NDF2sDYJ9jFyMkhIWAiserOExYIW0ziwr31
	bF2MXBxCAtMZJW69PMoC4bQzSTxq3M4KUsUioCrx9elbRhCbTUBP4vPdp0xdjBwcIgJaEi9v
	poLUMwvcY5Fo7VkDVi8s4CFx5Nc3JhCbV8Ba4vSXN2A2p0CwxJc566C2/WeSmNx3Emwov4Ck
	RPu/H8wQJ9lJnPu0gR2iWVDix+R7YKcyAy3bvK2JFcKWl9i85i3zBEbBWUjKZiEpm4WkbAEj
	8ypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4Eh7JrWDcWWDxSFGAQ5GJR5eBaePgUKsiWXF
	lbmHGCU4mJVEeNc6fgoU4k1JrKxKLcqPLyrNSS0+xCjNwaIkznug1TpQSCA9sSQ1OzW1ILUI
	JsvEwSnVwLhE/tGNnm6HzUEP7oSffWCjPN/as9/klV/3fImFi3pPM3gydQR2lDnklPm6K+xn
	eKqcMGmWkHnQrcoKvv4O8fTjNTIJR8WbLh0SlNIRYgi/3cFv9Sx8ZTd34lqdy05+e5S5326p
	ufhQWzt184L26J8vdW597vqZl2sdkyFpV5BfWn9mu/lPJZbijERDLeai4kQAPE/wJ7ACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jul 2013 15:03:34 +0530 Viresh Kumar wrote,
> On 26 July 2013 14:03, Lukasz Majewski <l.majewski@samsung.com> wrote:
> > On Fri, 26 Jul 2013 12:47:15 +0530 Viresh Kumar wrote,
> >> On 25 July 2013 22:03, Lukasz Majewski <l.majewski@samsung.com>
> >> wrote:
> 
> >> > +int cpufreq_boost_trigger_state(int state)
> >> > +{
> >> > +       unsigned long flags;
> >> > +       int ret = 0;
> >> > +
> >> > +       if (cpufreq_driver->boost_enabled == state)
> >> > +               return 0;
> >> > +
> >> > +       write_lock_irqsave(&cpufreq_driver_lock, flags);
> >> > +       cpufreq_driver->boost_enabled = state;
> >> > +       write_unlock_irqrestore(&cpufreq_driver_lock, flags);
> >             ^^^^^^^^^^^^^^^^^^^^ [*]
> >>
> >> Not sure if we should leave the lock at this point of time, as we
> >> haven't enabled boost until now.
> >
> > The problem here is with the cpufreq_driver->set_boost() call.
> >
> > I tried to avoid acquiring lock at one function and release it at
> > another (in this case cpufreq_boost_set_sw), especially since the
> > __cpufreq_governor() acquires its own lock - good place for
> > deadlock.
> >
> > Is it OK for you to grab lock at one function
> > (cpufreq_boost_trigger_state()) and then at other function
> > (cpufreq_boost_set_sw) release it before calling
> > __cpufreq_governor() and grab it again after its completion?
> 
> >> > +       ret = cpufreq_driver->set_boost(state);
> >> > +       if (ret) {
> >> > +               write_lock_irqsave(&cpufreq_driver_lock, flags);
> >> > +               cpufreq_driver->boost_enabled = 0;
> >>
> >> should be:
> >>                     cpufreq_driver->boost_enabled = !state;
> >
> > For me = 0 (or = false) is more readable.
> > If you wish, I will change it to = !state.
> 
> Its not about readability but logic... What if boost was enabled
> earlier and we are disabling it now.. and we reach here.. We
> need to enable boost again, whereas you are disabling it.

You are right here. I will change this to = !state

> 
> >> > +int cpufreq_boost_supported(void)
> >> > +{
> >> > +       if (cpufreq_driver)
> >>
> >> This routine is always called from places where cpufreq_driver
> >> can't be NULL..
> >
> > It is also called from thermal. And it happens that thermal is
> > initialized earlier.
> > Then "NULL pointer dereference" happens.
> 
> Ok.. Put a likely() around this check for cpufreq_driver..

Ok.

> 
> > In my opinion at [1] we don't need the if (cpufreq_driver) check.
> > But it is up to you to decide.
> 
> leave it as is.

Ok.

> 
> > If we agree about above comments, I will post v7 ASAP.
> 
> Don't post it ASAP, wait for few more days for others to give
> comments.. And also I haven't finished reviewing it until
> now.

Ok.

-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
