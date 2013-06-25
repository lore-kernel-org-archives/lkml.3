Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751306Ab3FYEP2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 00:15:28 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:39249 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750741Ab3FYEP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 00:15:26 -0400
Message-ID: <1372133724.1245.38.camel@joe-AO722>
Subject: Re: [PATCH 25/32] cpufreq: delete __cpuinit usage from all cpufreq
 files
From: Joe Perches <joe@perches.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org
Date: Mon, 24 Jun 2013 21:15:24 -0700
In-Reply-To: <CAKohponpsJBqbj_8u8MUiu7sCEpeg5bcztWJAZdn9uxL5taVZQ@mail.gmail.com>
References: <1372102237-8757-1-git-send-email-paul.gortmaker@windriver.com>
	 <1372102237-8757-26-git-send-email-paul.gortmaker@windriver.com>
	 <CAKohponpsJBqbj_8u8MUiu7sCEpeg5bcztWJAZdn9uxL5taVZQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-06-25 at 09:01 +0530, Viresh Kumar wrote:
> On 25 June 2013 01:00, Paul Gortmaker <paul.gortmaker@windriver.com> wrote:
> > diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
[]
> > -static int __cpuinit cpufreq_cpu_callback(struct notifier_block *nfb,
> > -                                       unsigned long action, void *hcpu)
> > +static int cpufreq_cpu_callback(struct notifier_block *nfb,
> > +                               unsigned long action, void *hcpu)
> 
> You were not required to change second line here and also don't
> change its indentation level. Check this everywhere.

Paul, yes, thanks for doing that here,
but please, do it everywhere...

;)

> > diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
[]
> > @@ -306,7 +306,7 @@ static int cpufreq_stat_notifier_policy(struct notifier_block *nb,
> >  }
> >
> >  static int cpufreq_stat_notifier_trans(struct notifier_block *nb,
> > -               unsigned long val, void *data)
> > +                                      unsigned long val, void *data)
> 
> See.. unnecessary change.

Or from another perspective, ideal change.

> > -static int __cpuinit cpufreq_stat_cpu_callback(struct notifier_block *nfb,
> > +static int cpufreq_stat_cpu_callback(struct notifier_block *nfb,
> >                                                unsigned long action,
> >                                                void *hcpu)

Hey Paul, you missed some too.

Viresh, there's no absolute "right" way to do this.


