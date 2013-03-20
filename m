Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933515Ab3CTEX5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 00:23:57 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:63010 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab3CTEXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 00:23:55 -0400
MIME-Version: 1.0
In-Reply-To: <1409962.M4gLo8y6eX@vostro.rjw.lan>
References: <cover.1362381470.git.viresh.kumar@linaro.org>
	<3174774.7AKCbYrzc6@vostro.rjw.lan>
	<CAKohpokwdtSwQmcK=gb2mpzjzp0vpbS7Sra-EhM3QsiQwpog1w@mail.gmail.com>
	<1409962.M4gLo8y6eX@vostro.rjw.lan>
Date: Wed, 20 Mar 2013 09:53:54 +0530
Message-ID: <CAKohponm_NpYJVcMVcXfMrn+cOFH6OZ2AnWSsVVeSzpmzLM4DQ@mail.gmail.com>
Subject: Re: [PATCH V3 4/4] cpufreq: Add Kconfig option to enable/disable have_multiple_policies
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 March 2013 05:50, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Thursday, March 14, 2013 08:39:55 AM Viresh Kumar wrote:
>> On 14 March 2013 03:11, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > On Tuesday, March 12, 2013 08:55:12 AM Viresh Kumar wrote:
>> >> On 12 March 2013 07:38, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> >> > One more question before I apply it.
>> >> >
>> >> > Is there any architecture/platform that will set
>> >> > CONFIG_CPU_FREQ_HAVE_MULTIPLE_POLICIES and keep have_multiple_policies unset
>> >> > at the same time?
>> >>
>> >> No, they are redundant. That's why i have been forcing to drop this patch.
>> >
>> > I see.
>> >
>> > What about having the Kconfig option alone, however?
>>
>> Even that is not enough. We build multiplatform kernels and so need a
>> variable to be set by platform.
>
> Which means the Kconfig option and the field are not redundant in fact.

Yes. Redundant was the wrong word. Actually Kconfig option is just not required
as we can work efficiently without it.

> But do we need the field to reside in the policy structure?  It looks like
> it may just be a global bool variable

Yes. It is not per policy but per cpufreq driver. And this can be done
by sharing
a function from cpufreq core to driver. But when do you want me to
call this function
(which will set this global variable). If we do it from init, then we
will end up calling it
again and again. Then it has to be called before calling
cpufreq_register_driver(),
as init() gets called internally.

> (in which case the Kconfig option could be dropped IMO).

We are aligned now :)

> Is there any particular reason to put that thing into
> struct cpufreq_policy?

Just the problem i mentioned to you.
