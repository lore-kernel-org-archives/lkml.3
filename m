Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199Ab3HZGvD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 02:51:03 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:18516 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755892Ab3HZGvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 02:51:00 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-75-521afacef47c
Date: Mon, 26 Aug 2013 08:50:46 +0200
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
Subject: Re: [PATCH v7 3/7] thermal:boost: Automatic enable/disable of BOOST
 feature
Message-id: <20130826085046.797baf96@amdc308.digital.local>
In-reply-to: <CAKohpo=KSVOFr5PXcpTZTaSq3_fv7AZgSiHiY-kWYREj6JdUoA@mail.gmail.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1376388505-30233-1-git-send-email-l.majewski@samsung.com>
 <1376388505-30233-4-git-send-email-l.majewski@samsung.com>
 <CAKohpo=KSVOFr5PXcpTZTaSq3_fv7AZgSiHiY-kWYREj6JdUoA@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEIsWRmVeSWpSXmKPExsVy+t9jQd1zv6SCDG5OkrXYOGM9q8XTph/s
	FvM+y1r0/bzCbLFm/08mi86zT5gtehdcZbN484jb4vKuOWwWn3uPMFrcblzBZtG/sJfJ4snD
	PjaLjV89HPg8Fu95yeRx59oeNo91094ye/RtWcXo8WhxC6PH8RvbmTw+b5ILYI/isklJzcks
	Sy3St0vgynj/9z9TwSyuin/32tgaGCdzdDFyckgImEhc+X+fFcIWk7hwbz1bFyMXh5DAdEaJ
	fXePskI47UwSm06sZAGpYhFQlXgw7SBYB5uAnsTnu0+Zuhg5OEQEtCRe3kwFqWcW2Mkisez9
	LUaQuLBAmMS06WDLeAWsJU507GUEsTkFgiWef2+Bmt/GJHHy4So2kAS/gKRE+78fzBAX2Umc
	+7SBHaJZUOLH5HtgNzAD7dq8rYkVwpaX2LzmLfMERsFZSMpmISmbhaRsASPzKkbR1ILkguKk
	9FwjveLE3OLSvHS95PzcTYzgmHomvYNxVYPFIUYBDkYlHt4VRVJBQqyJZcWVuYcYJTiYlUR4
	XR0kg4R4UxIrq1KL8uOLSnNSiw8xSnOwKInzHmy1DhQSSE8sSc1OTS1ILYLJMnFwSjUwLl6i
	P3deyq+pnTUyj89qBG80Otjs5pv3buLZ5UfMV8Wxp7rfPCrMMiVZ6bdAxdGeGouyVk/B+9yb
	lA/enheZuoFvczprvyrnRoPNny2mfdryWeFHqsLqjWsbNkZNqv7mevK0pelF8Y6GwG9LnaZ/
	lC+J2H8jMTiQ+S3TtvPB/9hlTt+bEnD9tBJLcUaioRZzUXEiADMOx32lAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Aug 2013 11:03:51 +0530 Viresh Kumar viresh.kumar@linaro.org
wrote,
> On 13 August 2013 15:38, Lukasz Majewski <l.majewski@samsung.com>
> wrote:
> > diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
> > index b5defd4..ec19da9 100644
> > --- a/include/linux/cpufreq.h
> > +++ b/include/linux/cpufreq.h
> > @@ -408,10 +408,24 @@ int cpufreq_frequency_table_target(struct
> > cpufreq_policy *policy,
> >
> >  void cpufreq_frequency_table_update_policy_cpu(struct
> > cpufreq_policy *policy); ssize_t cpufreq_show_cpus(const struct
> > cpumask *mask, char *buf); +#ifdef CONFIG_CPU_FREQ
> >  int cpufreq_boost_trigger_state(int state);
> >  int cpufreq_boost_supported(void);
> >  int cpufreq_boost_enabled(void);
> > -
> > +#else
> > +static inline int cpufreq_boost_trigger_state(int state)
> > +{
> > +       return 0;
> > +}
> > +static inline int cpufreq_boost_supported(void)
> > +{
> > +       return 0;
> > +}
> > +static inline int cpufreq_boost_enabled(void)
> > +{
> > +       return 0;
> > +}
> > +#endif
> 
> I almost gave an Ack before I saw this :)
> This should be moved to the first patch I believe..

Ok, I will move it there.

-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
