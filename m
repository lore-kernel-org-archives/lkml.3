Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636AbaIGW6T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 18:58:19 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:43194 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947AbaIGW6R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 18:58:17 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Abel Vesa <abelvesa@gmail.com>, alex.shi@intel.com,
        vincent.guittot@linaro.org, peterz@infradead.org, pjt@google.com,
        efault@gmx.de, rjw@rjwysocki.net, morten.rasmussen@arm.com,
        svaidy@linux.vnet.ibm.com, arjan@linux.intel.com, mingo@kernel.org,
        preeti@linux.vnet.ibm.com
From: Mike Turquette <mike.turquette@linaro.org>
In-Reply-To: <20140907114705.GA10470@abel-laptop>
Cc: linaro-kernel@lists.linaro.org, markgross@thegnar.org, corbet@lwn.net,
        catalin.marinas@arm.com, sundar.iyer@intel.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, dietmar.eggemann@arm.com
References: <20140907114705.GA10470@abel-laptop>
Message-ID: <20140907225802.19023.64121@quantum>
User-Agent: alot/0.3.5
Subject: Re: Power Scheduler Design
Date: Sun, 07 Sep 2014 15:58:02 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Abel Vesa (2014-09-07 04:47:13)
> For a while now, I've started studying the power aware scheduling problem.
> And like many other rookies out there I took all the lkml mails related
> and read them all (well, almost all) and I saw that there are some
> debating on the implementation.I even look over the implementation
> proposed of Preeti U Murthy. I also worked (just for fun) for a while on
> some ideas of my own (nothing worth sharing, yet) but I have problem
> understanding the design requirements. Here is one. 
> 
>   Some of you (even Ingo) said  that the scheduler should be the one to
> manage the cpu P/C states. In this case the governors of the cpuidle and
> cpufreq would not make any sense anymore.  Does that mean they will not
> be a part of this scheduling solution anymore?

Correct. The current thinking from the energy-aware scheduling (eas)
workshop in September is that the CPUfreq governors will go away, in
time. This won't happen soon.

Of course making smart choices on how and when to change cpu frequency
involves some platform-specific knowledge, and this will likely be
handled by the in-kernel energy model. The energy model will be
per-platform or per-machine. See the recent RFCs from Morten Rasmussen
to get more info on this.

The latest efforts are focused on task placement, but C- and P-states
will come along in the future.

Regards,
Mike
