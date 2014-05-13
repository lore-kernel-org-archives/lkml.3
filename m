Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942AbaEMPkO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 11:40:14 -0400
Received: from www.linutronix.de ([62.245.132.108]:35867 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772AbaEMPkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 11:40:03 -0400
Date: Tue, 13 May 2014 17:40:02 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt@goodmis.org,
        John Kacur <jkacur@redhat.com>
Subject: Re: [ANNOUNCE] 3.14.3-rt5
Message-ID: <20140513154002.GD15049@linutronix.de>
References: <20140509181214.GK29014@linutronix.de>
 <1399695303.5146.21.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1399695303.5146.21.camel@marge.simpson.net>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mike Galbraith | 2014-05-10 06:15:03 [+0200]:

>On Fri, 2014-05-09 at 20:12 +0200, Sebastian Andrzej Siewior wrote:
>
>> Known issues:
>> 
>>       - bcache is disabled.
>> 
>>       - lazy preempt on x86_64 leads to a crash with some load.
>
>That is only with NO_HZ_FUL enabled here.  Box blows the stack during
>task exit, eyeballing hasn't spotted the why.

Even if I disable NO_HZ_FULL it explodes as soon as hackbench starts.

>> - CPU hotplug works in general. Steven's test script however
>>         deadlocks usually on the second invocation.
>
>My 64 core box runs for up to 14 hours, and never deadlocks.. it
>explodes in what looks like it should be an impossible manner instead.

It deadlocks here and I haven't figured the exact root cause. From what
it looks like is that the irq thread blocks on something during startup
(migrate_disable() or so). One of the blocked irq thrad is disk driver.
The userland tasks then block on ext4 in order to complete the requests.

I also noticed that the frequent cpu up/down fails at some point and my
kvm guest has just 7 out 8 CPUs. That one CPU remains dead and can't get
back online. Once that happens, the deadlock is comming in a few minutes
:)

>-Mike

Sebastian
