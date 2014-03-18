Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054AbaCRFGP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 01:06:15 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:55752 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbaCRFGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 01:06:13 -0400
MIME-Version: 1.0
In-Reply-To: <53234A70.70506@gmail.com>
References: <1394732168-12638-1-git-send-email-dirk.j.brandewie@intel.com>
	<CAOh2x==at2PtHRpa=-_V6O5Z9aSog4r9BDb7ixJgBZk_+vfPtg@mail.gmail.com>
	<53231BF4.2000308@intel.com>
	<CAKohponGN4JNwLKLjvFOPkru0=6JajOKKH=oJneDkKp=PyAmRA@mail.gmail.com>
	<53234A70.70506@gmail.com>
Date: Tue, 18 Mar 2014 10:36:12 +0530
X-Google-Sender-Auth: 1wIKrXHwAy0c4suEwZeLKowkoNI
Message-ID: <CAOh2x=n57WVOAMBsM_nPYOjjMsvWf5WB8RptoyCC63y8iab3Kg@mail.gmail.com>
Subject: Re: [PATCH 0/2] Add exit_prepare callback to the cpufreq_driver interface.
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Dirk Brandewie <dirk.brandewie@gmail.com>
Cc: Dirk Brandewie <dirk.j.brandewie@intel.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Patrick Marlier <patrick.marlier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

It was a long weekend in India due to some holidays and so couldn't reply.

On Fri, Mar 14, 2014 at 11:59 PM, Dirk Brandewie
<dirk.brandewie@gmail.com> wrote:
> On 03/14/2014 10:07 AM, Viresh Kumar wrote:
> Suspend and hotplug are two very different things and if we start
> crossing those wires bad things are going to happen IMHO.
>
> In "normal" operation using the suspend path to do this work could
> work in principal but doesn't handle the case where the user does
>    echo 0 | sudo tee /sys/devices/system/cpu/cpuX/online
>
> Trying force hotplug and suspend into a common mechanism would
> lead to a bunch of special case code or a significant rework of the
> core code IMHO.

What you said is correct, we shouldn't do it. But what I am asking for
is a bit different. The stuff we are doing in core on system suspend
isn't actually related to suspend but only CPU online/offline.

There are platforms which want to set CPUs to a particular frequency
before they are taken out by disable_nonboot_cpus. And then there
are platforms which want to do similar thing when CPUs are taken
down with help of sysfs files. But there is a common baseline there:
Set CPUs to a particular P-state before they are taken down.

And so I wanted to keep a common solution for both these requirements.

> This is guaranteed by the hardware.  Each core has its own MSR for P state
> request.  Any coordination that is required between cores to select the
> package P state is handled by the hardware.

I see.. Let me send some patches which I have in my mind and then we can
decide which set looks more reasonable :)
