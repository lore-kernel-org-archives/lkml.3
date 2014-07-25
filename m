Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888AbaGYO3c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 10:29:32 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:55129 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802AbaGYO3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 10:29:30 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpo=HKUkGRK4NX7E59z5QthcKbZKETB-DuP10xj3x+vdHaQ@mail.gmail.com>
References: <cover.1404231535.git.viresh.kumar@linaro.org> <20140717093518.486ac244@free-electrons.com>
 <CAKohpokZXUzXKRWBje7QF_jrvOd5dmfmWQ2Csf3xiMuvT_vPYA@mail.gmail.com>
 <2399813.Puj1SZWhCh@vostro.rjw.lan> <CAKohpomKzK8pMJs1gv+uXxhd17HtCQyfjSnVYw9KpGz6FwbgDA@mail.gmail.com>
 <CAKohpo=HKUkGRK4NX7E59z5QthcKbZKETB-DuP10xj3x+vdHaQ@mail.gmail.com>
From: Rob Herring <robherring2@gmail.com>
Date: Fri, 25 Jul 2014 09:29:09 -0500
Message-ID: <CAL_JsqKqCeU0zs+rS1vxsOeh=Kuw_-gaVHtGU76Lb6TchCTytw@mail.gmail.com>
Subject: Re: [PATCH 00/14] cpufreq: cpu0: Extend support beyond CPU0, V2
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Rob Herring <rob.herring@linaro.org>,
        Mike Turquette <mturquette@linaro.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Nishanth Menon <nm@ti.com>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Simon Horman <horms@verge.net.au>,
        Thomas P Abraham <thomas.ab@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Sachin Kamat <spk.linux@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 5:48 AM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 18 July 2014 09:47, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>>> Before I apply anything in this area, I need a clear statement from the ARM
>>> people as a group on what the approach is going to be.
>
> @Rafael: The only patch which has blocked this set is:
>
> cpufreq: cpu0: Extend support beyond CPU0
>
> This is about finding which CPUs share clock line..
>
> Other patches are sort of independent of this one and cpufreq-cpu0 would
> continue to work for existing platforms if we apply these patches.
>
> I was wondering if you would like to apply other patches leaving this one?
> I will then rebase stuff again and send non-controversial patches for 3.17.
> So, that we get something in 3.17 and the last change can be merged during
> rc's as well once we finalize on bindings..
>
>> Mike/Rob/Stephen: I believe Atleast three of you should express your views
>> now :)
>
> Any idea on how can we get some temporary solution for 3.17 as we didn't
> conclude anything yet on bindings ?

A temporary solution would have to be NOT in DT because once you add
something into DT you are stuck with it for some time. You could
simply support independent clocks by looking at the platform type, but
that is still risky since you may want to define the OPP in DT
differently for the 2 cases.

The other problem with temporary solutions is once they are accepted,
people loose motivation to create the permanent solution. "Can you
take this now and I'll fix the issues later" is a red flag to
maintainers.

Rob
