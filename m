Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918AbaHEG3T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 02:29:19 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:54345 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817AbaHEG3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 02:29:17 -0400
Message-ID: <3848ac8b087052a65d890dcfe17e3af8.squirrel@www.codeaurora.org>
In-Reply-To: <CAKohpo=VJJFxKo5hNH3GNOZpjeHBc9fWORD9h7SThaFtkM__FA@mail.gmail.com>
References: <1406634362-811-1-git-send-email-prarit@redhat.com>
    <2066166.pXm4lKLOID@vostro.rjw.lan> <53DA8389.80804@redhat.com>
    <1917362.abr2Y4p7vh@vostro.rjw.lan> <53DA8A41.2030601@redhat.com>
    <53DAA60B.6040802@codeaurora.org> <53DAA749.5080506@redhat.com>
    <53DAA95B.2040505@codeaurora.org> <53DAB038.3050007@redhat.com>
    <53DABFA6.6090503@codeaurora.org> <53DACA26.1000908@redhat.com>
    <53DAE592.2030909@codeaurora.org> <53DB6B81.6050400@redhat.com>
    <53DBCBE8.6010809@codeaurora.org>
    <CAKohpom0KycrB8qJDM7yEOHOn76J1sEe90CG+JXERJMcxKnOJA@mail.gmail.com>
    <53DF7BC4.9070500@redhat.com>
    <CAKohpomEQ__Q4xTaBgHJyE0Meu4au-cXKCAKCqHWTHLRL+R5OA@mail.gmail.com>
    <53DFEA25.5070206@codeaurora.org>
    <CAKohpo=VJJFxKo5hNH3GNOZpjeHBc9fWORD9h7SThaFtkM__FA@mail.gmail.com>
Date: Tue, 5 Aug 2014 06:29:12 -0000
Subject: Re: [PATCH] cpufreq, store_scaling_governor requires policy->rwsem
 to be held for duration of changing governors [v2]
From: skannan@codeaurora.org
To: "Viresh Kumar" <viresh.kumar@linaro.org>
Cc: "Saravana Kannan" <skannan@codeaurora.org>,
        "Prarit Bhargava" <prarit@redhat.com>,
        "Stephen Boyd" <sboyd@codeaurora.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "Lenny Szubowicz" <lszubowi@redhat.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        =?iso-8859-1?Q?=22Robert_Sch=C3=B6ne=22?= 
	<robert.schoene@tu-dresden.de>
User-Agent: SquirrelMail/1.4.22-4.el6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Viresh Kumar wrote:
> On 5 August 2014 01:46, Saravana Kannan <skannan@codeaurora.org> wrote:
>> The problem is when between one thread trying to cat a governor's file
>> (say,
>> sampling_rate) vs the governor getting a POLICY_EXIT.
>
> I don't see two threads racing against each other here. Simply changing
> the governor from conservative->ondemand creates this.
>
> Or is it that the kernel is detecting two different orders of taking lock?
>
> But during governor change, isn't the sysfs lock taken first as we are
> storing a value to "scaling_governor"? So, isn't this a sysfs lock first
> in all cases?
>
> In short, I am still unclear about the *exact* problem here.
>
>> Could you please look at my policy free/remove patches? If you can do
>> that,
>> I can work on a fix for this. It might also be simpler to fix after my
>> patch
>> series (not sure, might be).
>
> I had an overall look of those on the day you posted them, but haven't
> commented yet as was going away..
>
> There is no way those can land in 3.17-rc1 atleast and so we still have
> some time to get them pushed..
>
> Anyway, they are my number two priority and the number one is this bug,
> which we have to fix in stable kernels as well. So, a dependency on your
> series wouldn't work..

Sigh... ok. I too will try to fix this one. I already have something in
mind for this.

Looks like Srivatsa has gone off the grid too. I'm hoping at least one of
you can do a review of my series. Come on guys, not everyone has to work
on the same patch/issue. :-(

-Saravana

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

