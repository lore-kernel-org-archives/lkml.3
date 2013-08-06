Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032Ab3HFQDF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 12:03:05 -0400
Received: from mail-vb0-f50.google.com ([209.85.212.50]:43314 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755728Ab3HFQDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 12:03:03 -0400
MIME-Version: 1.0
In-Reply-To: <20130806140904.GA9814@mtj.dyndns.org>
References: <1375632446-2581-1-git-send-email-tj@kernel.org>
	<1375632446-2581-4-git-send-email-tj@kernel.org>
	<CAKTCnz=DdG6QD0yPJ1poRZk0NYrYHdkmabvCXY-AR2qC1GSzYA@mail.gmail.com>
	<20130806140904.GA9814@mtj.dyndns.org>
Date: Tue, 6 Aug 2013 21:33:01 +0530
Message-ID: <CAKTCnzm+wXebh1SAvRq0MkqAWtLvTyhsafa7-U6B84P1zj9bRg@mail.gmail.com>
Subject: Re: [PATCH 3/5] cgroup, memcg: move cgroup_event implementation to memcg
From: Balbir Singh <bsingharora@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 6, 2013 at 7:39 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello, Balbir.
>
> On Tue, Aug 06, 2013 at 08:56:34AM +0530, Balbir Singh wrote:
>> [off-topic] Has the unified hierarchy been agreed upon? I did not
>> follow that thread
>
> I consider it agreed upon enough.  There of course are objections but
> I feel fairly comfortable with the amount of existing consensus and
> considering the current state of cgroup in general, especially the API
> leaks, I don't think we have many other choices.  The devil is always
> in the details but unless we meet a major technical barrier, I'm
> pretty sure it's happening.
>

I guess we'll need to see what the details look like :)

>> > events at fixed points, or if that's too restrictive, configureable
>> > cadence or single set of configureable points should be enough.
>>
>> Nit-pick: typo on the spelling of configurable
>
> Will update.
>
>> Tejun, I think the framework was designed to be flexible. Do you see
>> cgroup subsystems never using this?
>
> I can't be a hundred percent sure that we won't need events which are
> configureable per-listener but it's highly unlikely given that we're
> moving onto single agent model and the nature of event delivery -
> spurious events are unlikely to be noticeable unless the frequency is
> very high.  In general, as anything, aiming for extremes isn't a
> healthy design practice.  Maximum flexibility sounds good in isolation
> but nothing is free and it entails unneeded complexity both in
> implementation and usage.  Note that even for memcg, both oom and
> vmpressure don't benefit in any way from all the added complexity at
> all.  The only other place that I can see event being useful at the
> moment is freezer state change notification and that also would only
> require unconditional file modified notification.
>

Hmm.. I think it would be interesting to set thresholds on other
resources instead of pure monitoring. One might want to set thresholds
for CPUACCT usage for example. Freezer is another example like you
mentioned.

>> > +static int cgroup_write_event_control(struct cgroup_subsys_state *css,
>> > +                                     struct cftype *cft, const char *buffer)
>> > +{
>> > +       struct cgroup *cgrp = css->cgroup;
>> > +       struct cgroup_event *event;
>> > +       struct cgroup *cgrp_cfile;
>> > +       unsigned int efd, cfd;
>> > +       struct file *efile;
>> > +       struct file *cfile;
>> > +       char *endp;
>> > +       int ret;
>> > +
>>
>> Can we assert that buffer is NOT NULL here?
>
> The patch moves the code as-is as things become difficult to review
> otherwise.  After the patchset, it belongs to memcg, please feel free
> to modify as memcg people see fit.

OK, Thanks

Balbir Singh
