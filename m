Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946264Ab3BHNRf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 08:17:35 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:34373 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946001Ab3BHNRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 08:17:33 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Artem Savkov <artem.savkov@gmail.com>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] cpufreq: sleeping function called from invalid context at kernel/workqueue.c:2811
Date: Fri, 08 Feb 2013 14:23:54 +0100
Message-ID: <2280013.XqXuhp58Wi@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc6; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAKohpokvXoBEHqb+axzMJhB3K02bZEzPGF1RO6pyJwsC2Y-8cQ@mail.gmail.com>
References: <20130206202513.GA5626@thinkpad.lan> <1873989.qC1mdEKIl9@vostro.rjw.lan> <CAKohpokvXoBEHqb+axzMJhB3K02bZEzPGF1RO6pyJwsC2Y-8cQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 08, 2013 11:24:39 AM Viresh Kumar wrote:
> On 7 February 2013 06:11, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > Subject: cpufreq: Move sysfs_remove_link() from under a spinlock
> >
> > Commit 73bf0fc "cpufreq: Don't remove sysfs link for policy->cpu"
> > attempted to fix a bug in __cpufreq_remove_dev() by avoiding to
> > remove the link to the "cpufreq" directory for policy->cpu, but it
> > rearranged the code in such a way that sysfs_remove_link() ended up
> > under a spinlock, which caused complaints about sleeping in atomic
> > context to be emitted into the kernel log during system suspend.
> >
> > To fix this, revert commit 73bf0fc partially and move the
> > sysfs_remove_link() in question to a separate block executed for
> > cpus > 1 outside of the spinlock.
> >
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> BTW, i have dropped this patch completely as i got another lock fixing
> patch :)

Sure, I suppose you can get a better fix. :-)

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
