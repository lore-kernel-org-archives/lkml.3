Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965AbaHDNiz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 09:38:55 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:61139 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391AbaHDNix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 09:38:53 -0400
MIME-Version: 1.0
In-Reply-To: <53DF7BC4.9070500@redhat.com>
References: <1406634362-811-1-git-send-email-prarit@redhat.com>
	<2066166.pXm4lKLOID@vostro.rjw.lan>
	<53DA8389.80804@redhat.com>
	<1917362.abr2Y4p7vh@vostro.rjw.lan>
	<53DA8A41.2030601@redhat.com>
	<53DAA60B.6040802@codeaurora.org>
	<53DAA749.5080506@redhat.com>
	<53DAA95B.2040505@codeaurora.org>
	<53DAB038.3050007@redhat.com>
	<53DABFA6.6090503@codeaurora.org>
	<53DACA26.1000908@redhat.com>
	<53DAE592.2030909@codeaurora.org>
	<53DB6B81.6050400@redhat.com>
	<53DBCBE8.6010809@codeaurora.org>
	<CAKohpom0KycrB8qJDM7yEOHOn76J1sEe90CG+JXERJMcxKnOJA@mail.gmail.com>
	<53DF7BC4.9070500@redhat.com>
Date: Mon, 4 Aug 2014 19:08:51 +0530
Message-ID: <CAKohpomEQ__Q4xTaBgHJyE0Meu4au-cXKCAKCqHWTHLRL+R5OA@mail.gmail.com>
Subject: Re: [PATCH] cpufreq, store_scaling_governor requires policy->rwsem to
 be held for duration of changing governors [v2]
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Prarit Bhargava <prarit@redhat.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lenny Szubowicz <lszubowi@redhat.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        =?UTF-8?Q?Robert_Sch=C3=B6ne?= <robert.schoene@tu-dresden.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 August 2014 17:55, Prarit Bhargava <prarit@redhat.com> wrote:
> The issue is the collision between the setup & teardown of the policy's governor
> sysfs files.
>
> On creation the kernel does:
>
> down_write(&policy->rwsem)
> mutex_lock(kernfs_mutex) <- note this is similar to the "old" sysfs_mutex.
>
> The opposite happens on a governor switch, specifically the existing governor's
> exit, and then we get a lockdep warning.

Okay, probably a bit more clarity is what I was looking for. Suppose we try
to change governor, now tell me what will happen.

> I tried to reproduce with the instructions but was unable to ... ut that was on
> Friday ;) and I'm going to try again this morning.  I've also ping'd some of the
> engineers here in the office who are working on ARM to get access to a system to
> do further analysis and testing.

You DON'T need an ARM for that, just try that on any x86 machine which has
multiple groups of CPUs sharing clock line. Or in other terms there are multiple
policy structures there..

You just need to enable the flag we were discussing about, it just decided the
location where governor's directory will get created. Nothing else.
