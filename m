Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932481Ab3DBO6R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 10:58:17 -0400
Received: from relay2.sgi.com ([192.48.179.30]:49628 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760270Ab3DBO6P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 10:58:15 -0400
Date: Tue, 2 Apr 2013 09:58:14 -0500
From: Nathan Zimmer <nzimmer@sgi.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, Nathan Zimmer <nzimmer@sgi.com>,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 2/2] cpufreq: covert the cpufreq_data_lock to a
	spinlock
Message-ID: <20130402145813.GB31757@gulag1.americas.sgi.com>
References: <5159C147.70800@sgi.com> <20130402005618.GA12199@gulag1.americas.sgi.com> <CAKohpo=MVrz5YFqDkLkHCh4uTDrCc6KhVO23kyMPz3MHqOztsA@mail.gmail.com> <8666267.Du60305uqJ@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8666267.Du60305uqJ@vostro.rjw.lan>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 02, 2013 at 02:48:07PM +0200, Rafael J. Wysocki wrote:
> On Tuesday, April 02, 2013 10:34:21 AM Viresh Kumar wrote:
> > On 2 April 2013 06:26, Nathan Zimmer <nzimmer@sgi.com> wrote:
> > > On Mon, Apr 01, 2013 at 10:41:27PM +0200, Rafael J. Wysocki wrote:
> > >> On Monday, April 01, 2013 03:11:09 PM Nathan Zimmer wrote:
> > >> > This eliminates the rest of the contention found in __cpufreq_cpu_get.
> > >> > I am not seeing a way to use the rcu so we will have to make due with a
> > >> > rwlock for now.
> > >> >
> > >> > Cc: Viresh Kumar <viresh.kumar@linaro.org>
> > >> > Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> > >> > Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
> > >>
> > >> I've already applied this one.
> > >>
> > >> Can you please check if the version in my tree is OK?
> > >>
> > >> Rafael
> > >>
> > >
> > > Nope, the previous version was too different, probably best to just replace it.
> > 
> > Nathan,
> > 
> > First of all I should accept that I didn't had your last patch while
> > reviewing this
> > one earlier. Thanks Rafael.
> > 
> > Now, I believe the previous patch which Rafael has pushed was good and we
> > can simply keep it. What you can do is, just add a patch over it (which would
> > mostly be 1/2 of your patchset), that simply separates rcu stuff out of the lock
> > and leave lock for cpufreq_data..
> 
> Yeah, I'd very much prefer that.
> 
> Nathan, I'm going to keep the rwlock patch unless it is demonstrably incorrect.
> 
> Thanks,
> Rafael
> 
> 
> -- 
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.

Ok I'll go that route.

