Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932366Ab3DBOzl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 10:55:41 -0400
Received: from relay3.sgi.com ([192.48.152.1]:56629 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760270Ab3DBOzj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 10:55:39 -0400
Date: Tue, 2 Apr 2013 09:55:36 -0500
From: Nathan Zimmer <nzimmer@sgi.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Nathan Zimmer <nzimmer@sgi.com>, rjw@sisk.pl, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 1/2] cpufreq: split the cpufreq_driver_lock and use
	the rcu
Message-ID: <20130402145536.GA31757@gulag1.americas.sgi.com>
References: <5159C147.70800@sgi.com> <1364847069-2887-1-git-send-email-nzimmer@sgi.com> <1364847069-2887-2-git-send-email-nzimmer@sgi.com> <CAKohpok7MR28trAddHRi5Lcg0bGBHBnOfJO=yu7SQqGnV5ZCRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpok7MR28trAddHRi5Lcg0bGBHBnOfJO=yu7SQqGnV5ZCRg@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 02, 2013 at 10:35:46AM +0530, Viresh Kumar wrote:
> On 2 April 2013 01:41, Nathan Zimmer <nzimmer@sgi.com> wrote:
> > diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> 
> > +static struct cpufreq_driver __rcu *cpufreq_driver;
> > +static DEFINE_SPINLOCK(cpufreq_driver_lock);
> 
> You really need this lock? This is only used in cpufreq_register_driver
> and unregister_driver... And it doesn't protect other routines at all. And
> because we are using rcu stuff now, probably this lock is just not required.
> 
The lock is unneeded if we expect register and unregister driver to not be
called from muliple threads at once.  I didn't make that assumption.

> > +static DEFINE_SPINLOCK(cpufreq_data_lock);
> 
> Only this one is required and it can be the rwlock which is already pushed
> by rafael.
