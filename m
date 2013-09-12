Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085Ab3ILGlh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 02:41:37 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:36049 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382Ab3ILGle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 02:41:34 -0400
MIME-Version: 1.0
In-Reply-To: <52315E9A.3000607@linux.vnet.ibm.com>
References: <522E1FEF.6080803@wwwdotorg.org>
	<1775778.MeiRhuYy7o@vostro.rjw.lan>
	<522F86AD.6010603@wwwdotorg.org>
	<2521560.SfeNbV74nj@vostro.rjw.lan>
	<52304439.3030301@linux.vnet.ibm.com>
	<CAKohpokTVzikxunqSdUYmLjTOkfhWFJ=N4TTa4rdbj2euCFY-g@mail.gmail.com>
	<CAKohpomzQ8Yzk+OU0btQM6DGm4xsY1RR9uYFrZD3ZHO-bhrwKQ@mail.gmail.com>
	<5230509D.6040205@linux.vnet.ibm.com>
	<CAKohpo=DfmNSMnyVRK0gfx7QGr=jOTbFo6uuGhEOaa2UMkeQAQ@mail.gmail.com>
	<CAKohpo=8mqRmmk17D52yiR9w1V4Z+2UzZ2kzABtrxHbYR+sQzw@mail.gmail.com>
	<52315E9A.3000607@linux.vnet.ibm.com>
Date: Thu, 12 Sep 2013 12:11:33 +0530
Message-ID: <CAKohpo=LuoKTf+mX1oBt97K3sJVu0iN=whN7VGw6kuartnrr+w@mail.gmail.com>
Subject: Re: cpufreq_stats NULL deref on second system suspend
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Stephen Warren <swarren@wwwdotorg.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cpufreq <cpufreq@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 September 2013 11:56, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> I had the same thought when solving this bug.. We have had similar issues with
> CPU hotplug notifiers too: why are they invoked in the same order during both
> CPU down and up, instead of reversing the order? I even had a patchset to perform
> reverse-invocation of notifiers.. http://lwn.net/Articles/508072/
> ... but people didn't find that very compelling to have.
>

> It does to me too, but I think the reason nobody really bothered is because perhaps
> not many other subsystems care about the order in which CPUs are torn down or
> brought up; they just need the total number to match.. cpufreq is one exception
> as we saw with this bug.

Probably its time to re-spin that series and make CPUFreq as one of the users
of that patchset.. Resume should be just opposite of suspend and so
that patchset
would make sense even if not many people care about it :)

Over that there is one more problem that I see, don't know if it is really a big
issue..

After a suspend/resume value of policy->cpu may get changed... And so the
hierarchy of sysfs cpufreq files too.. Folder that had links to other
CPUs folder
can now be actual folders instead of links and vice versa..

Don't know if this can break something ??
