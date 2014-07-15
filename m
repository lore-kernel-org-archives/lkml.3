Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758094AbaGOHGG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 03:06:06 -0400
Received: from dmz-mailsec-scanner-4.mit.edu ([18.9.25.15]:42651 "EHLO
	dmz-mailsec-scanner-4.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757843AbaGOHGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 03:06:04 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Jul 2014 03:06:04 EDT
X-AuditID: 1209190f-f79f86d0000061c8-c2-53c4d1ad2183
Message-ID: <53C4D12E.3040807@mit.edu>
Date: Tue, 15 Jul 2014 12:28:54 +0530
From: "Srivatsa S. Bhat" <srivatsa@MIT.EDU>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Saravana Kannan <skannan@codeaurora.org>,
        Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Todd Poynor <toddpoynor@google.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH v2] cpufreq: Don't destroy/realloc policy/sysfs on hotplug/suspend
References: <1404959850-11617-1-git-send-email-skannan@codeaurora.org> <1405052287-4744-1-git-send-email-skannan@codeaurora.org> <CAKohponB9feyh50p+dL5hyU1ffHAzHU59G-sYCrCm1AbHQe9hw@mail.gmail.com> <2f549e6e4871ccf2a94dd4c8872c7a0b.squirrel@www.codeaurora.org> <CAKohpokhmj1OkCRj=X+Q7eYiun8fsqD2dpEt66VKYnqo3dENVA@mail.gmail.com> <53C0A12A.2060204@codeaurora.org> <CAKohpon9en_VnSx+CVydPsWBHtArvmazn0hrodrRJt9jgOa0-g@mail.gmail.com> <53C42AA8.8010107@codeaurora.org> <CAKohpomkqbHZo9KrJMSwsEKGt6+Ac2Fg2X0+S7ZAo=OzhAc45g@mail.gmail.com> <53C4BDFB.70707@codeaurora.org>
In-Reply-To: <53C4BDFB.70707@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJKsWRmVeSWpSXmKPExsUixG6nrrv24pFggwM9ihabHl9jtZi4/yy7
	xeVdc9gsPvceYbQ4c/oSq8WPM90sFgcuTmSzOLu8mc1i41cPB06Py329TB4LNpV63Lm2h81j
	85J6jy1X21k8Pm+SC2CL4rJJSc3JLEst0rdL4Mr4vm0Oa8F+0Yqe3RfYGhg7BbsYOTkkBEwk
	rl85ygJhi0lcuLeerYuRi0NIYDaTxLH3fxghnI2MEreajrBAONuZJBrPPQFr4RVQkzixcAJQ
	FQcHi4CqxN/eFBCTTUBbYtlGSZAKUYE4icbj3xkhqgUlTs4E6eTgEBGIlbjUyQ8ykVlgLbPE
	g2/TWEFqhAXCJGZuWMcEtYpFov3fYbBmTgEdid+XJ7ODNDMLqEusnycEEmYWkJfY/nYO8wRG
	wVlIVsxCqJqFpGoBI/MqRtmU3Crd3MTMnOLUZN3i5MS8vNQiXRO93MwSvdSU0k2MoBjhlOTf
	wfjtoNIhRgEORiUeXol3h4OFWBPLiitzDzFKcjApifJ+WXMkWIgvKT+lMiOxOCO+qDQntfgQ
	owQHs5IIr8dioBxvSmJlVWpRPkxKmoNFSZz3rbVVsJBAemJJanZqakFqEUxWhoNDSYKXAZgK
	hASLUtNTK9Iyc0oQ0kwcnCDDeYCGv78AMry4IDG3ODMdIn+KUVFKnPf/eaCEAEgiozQPrheW
	wl4xigO9Isz7BqSdB5j+4LpfAQ1mAhpcXnMYZHBJIkJKqoFR8qjC5O/l9cfvHfp5rPfi2vZc
	1rnVP1JtthzfbdotLVzrdveaRdbJXwe8n7yRfmvH8zHd+UhliMfsoidrNv/1ynFcszRDavq6
	GAWTilX9Hiu3fPq6+06XnXwC201WoywRpoTN01nE/qjaRNp1/1f0bdO+KaL4UuP6368yF5fw
	8m07MFvoyKWFSizFGYmGWsxFxYkANsNRuzwDAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2014 11:06 AM, Saravana Kannan wrote:
> On 07/14/2014 09:35 PM, Viresh Kumar wrote:
>> On 15 July 2014 00:38, Saravana Kannan <skannan@codeaurora.org> wrote:
>>> Yeah, it definitely crashes if policy->cpu if an offline cpu. Because
>>> the
>>> mutex would be uninitialized if it's stopped after boot or it would
>>> never
>>> have been initialized (depending on how you fix policy->cpu at boot).
>>>
>>> Look at this snippet on the actual tree and it should be pretty evident.
>>
>> Yeah, I missed it. So the problem is we initialize timer_mutex's for
>> policy->cpus. So we need to do that just for policy->cpu and also we
>> don't
>> need a per-cpu timer_mutex anymore.
>>
> 
> Btw, I tried to take a stab at removing any assumption in cpufreq code
> about policy->cpu being ONLINE.

Wait, allowing an offline CPU to be the policy->cpu (i.e., the CPU which is
considered as the master of the policy/group) is just absurd. If there is
no leader, there is no army. We should NOT sacrifice sane semantics for the
sake of simplifying the code.

> There are 160 instances of those of with
> 23 are in cpufreq.c
>

And that explains why. It is just *natural* to assume that the CPUs governed
by a policy are online. Especially so for the CPU which is supposed to be
the policy leader. Let us please not change that - it will become
counter-intuitive if we do so. [ The other reason is that physical hotplug
is also possible on some systems... in that case your code might make a CPU
which is not even present (but possible) as the policy->cpu.. and great 'fun'
will ensue after that ;-( ]

The goal of this patchset should be to just de-couple the sysfs files/ownership
from the policy->cpu to an extent where it doesn't matter who owns those
files, and probably make it easier to do CPU hotplug without having to
destroy and recreate the files on every hotplug operation.

This is exactly why the _implementation_ matters in this particular case -
if we can't achieve the simplification by keeping sane semantics, then we
shouldn't do the simplification!

That said, I think we should keep trying - we haven't exhausted all ideas
yet :-)

Regards,
Srivatsa S. Bhat

> So, even if we are sure cpufreq.c is fine, it's 137 other uses spread
> across all the other files. I definitely don't want to try and fix those
> as part of this patch. Way too risky and hard to get the test coverage
> it would need. Even some of the acpi cpufreq drivers seem to be making
> this assumption.
> 
> Btw, I think v3 is done. I did some testing and it was fine. But made
> some minor changes. Will test tomorrow to make sure I didn't break
> anything with the minor changes and then send them out.
> 
