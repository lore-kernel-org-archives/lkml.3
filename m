Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356Ab3ILPzT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 11:55:19 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:60183 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753039Ab3ILPzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 11:55:17 -0400
Message-ID: <5231E3E2.1050101@wwwdotorg.org>
Date: Thu, 12 Sep 2013 09:55:14 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
CC: Viresh Kumar <viresh.kumar@linaro.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cpufreq <cpufreq@vger.kernel.org>
Subject: Re: cpufreq_stats NULL deref on second system suspend
References: <522E1FEF.6080803@wwwdotorg.org> <1775778.MeiRhuYy7o@vostro.rjw.lan>	<522F86AD.6010603@wwwdotorg.org> <2521560.SfeNbV74nj@vostro.rjw.lan>	<52304439.3030301@linux.vnet.ibm.com> <CAKohpokTVzikxunqSdUYmLjTOkfhWFJ=N4TTa4rdbj2euCFY-g@mail.gmail.com> <CAKohpomzQ8Yzk+OU0btQM6DGm4xsY1RR9uYFrZD3ZHO-bhrwKQ@mail.gmail.com> <5230509D.6040205@linux.vnet.ibm.com> <CAKohpo=DfmNSMnyVRK0gfx7QGr=jOTbFo6uuGhEOaa2UMkeQAQ@mail.gmail.com> <CAKohpo=8mqRmmk17D52yiR9w1V4Z+2UzZ2kzABtrxHbYR+sQzw@mail.gmail.com> <52315E9A.3000607@linux.vnet.ibm.com>
In-Reply-To: <52315E9A.3000607@linux.vnet.ibm.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2013 12:26 AM, Srivatsa S. Bhat wrote:
> On 09/12/2013 11:22 AM, Viresh Kumar wrote:
...
>> Now coming back to the ideas I have...
>> Same code will work if hotplug sequence is fixed a bit. Why aren't we doing
>> exact opposite of suspend in resume?
>>
>> We are removing CPUs (leaving the boot cpu) in ascending order and then
>> adding them back in same order.. Why?
>>
>> Why not remove CPUs in descending order and add in ascending order? Or
>> remove in ascending order and add in descending order?
> 
> I had the same thought when solving this bug.. We have had similar issues with
> CPU hotplug notifiers too: why are they invoked in the same order during both
> CPU down and up, instead of reversing the order? I even had a patchset to perform
> reverse-invocation of notifiers.. http://lwn.net/Articles/508072/
> ... but people didn't find that very compelling to have.

I'm not sure if you're talking about the order the CPUs get plugged back
in after resume, or the order of the (pair of?) notifiers that gets
called for each individual CPU.

Sorry if this is blindingly obvious, but with CPU hotplug, I can
manually unplug/re-plug CPUs in any order I feel like, and cpufreq had
better work if I do that. Given that, I don't think there's any
particular need for suspend/resume to unplug/re-plug CPUs in any
particular order for correctness at least, although perhaps it'd be nice
cosmetically for some reason?
