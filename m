Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918AbaBYElo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 23:41:44 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:52890 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848AbaBYElm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 23:41:42 -0500
MIME-Version: 1.0
In-Reply-To: <CAKohpokGtcJbdzt0FPZnKjSFi54Np+Ss7--Z83UEZp8FMY94pQ@mail.gmail.com>
References: <15ccc0609cb9ee3db0ad3a95b29bf69d11ea197c.1392375504.git.viresh.kumar@linaro.org>
	<CAKohpo=mQWxoKTduR8FrrB4Qz45qXQrJjSudq=FkCJtHBTbo2Q@mail.gmail.com>
	<5301CE86.9020105@linux.vnet.ibm.com>
	<1489022.1IbaesBAQQ@vostro.rjw.lan>
	<CAKohpokGtcJbdzt0FPZnKjSFi54Np+Ss7--Z83UEZp8FMY94pQ@mail.gmail.com>
Date: Tue, 25 Feb 2014 10:11:41 +0530
Message-ID: <CAKohpokk5-6vGV93fZDob8Q=xZXsd7E4OkMUAC1M6Z71G=d1Ow@mail.gmail.com>
Subject: Re: [PATCH 1/2] cpufreq: Return error if ->get() failed in cpufreq_update_policy()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pierre Ossman <pierre-list@ossman.eu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 February 2014 07:49, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 18 February 2014 03:30, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
>> On Monday, February 17, 2014 02:25:34 PM Srivatsa S. Bhat wrote:
>>> Why go to no_policy when we can actually set things right?
>>>
>>> Anyway, I am not arguing against this strongly. I just wanted to share my
>>> thoughts, since this is the approach that made more sense to me.
>>
>> And I agree with that.  In particular, since we're going to set the new
>> policy *anyway* at this point, we can adjust the current frequency just fine
>> in the process, can't we?
>
> Though I still feel that it wouldn't be the right thing to do as get()
> just can't
> return zero. Actually I was planning to place a WARN() over its return value
> of zero.
>
> Anyway, as two of the three are in favor of this we can get that in.. But how
> would that work?
>
> - What frequency should we call cpufreq_driver_target ?
> - Remember that it wouldn't do anything if policy->cur is same as new freq.
> - Also remember that drivers need special attention if new freq is > old
> freq or vice versa. As they will change voltage before or after change here.
> And because we actually don't know what frequency we are at currently, how
> will we decide that?

@Rafael/Srivatsa: Ping!!
