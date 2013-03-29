Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987Ab3C2H10 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 03:27:26 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:64297 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320Ab3C2H1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 03:27:24 -0400
MIME-Version: 1.0
In-Reply-To: <20130328181332.GD14088@htj.dyndns.org>
References: <cover.1363617402.git.viresh.kumar@linaro.org>
	<fb2e721fc43fbc3517a7ebb905aa573b12bb83a5.1363617402.git.viresh.kumar@linaro.org>
	<20130321001211.GC31256@htj.dyndns.org>
	<CAKohponKUGbwEZ_edu353Y7YVZKgFOhZunTSUi04FGYWveftkw@mail.gmail.com>
	<20130321182937.GB20500@htj.dyndns.org>
	<20130328181332.GD14088@htj.dyndns.org>
Date: Fri, 29 Mar 2013 12:57:23 +0530
Message-ID: <CAKohpomkGxUy6-7tByBjQvAGSUn4EdVCpGo+94fn7vF8YgKRLQ@mail.gmail.com>
Subject: Re: [PATCH V3 3/7] workqueue: Add helpers to schedule work on any cpu
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Tejun Heo <tj@kernel.org>
Cc: pjt@google.com, paul.mckenney@linaro.org, tglx@linutronix.de,
        mingo@redhat.com, peterz@infradead.org, rostedt@goodmis.org,
        linaro-kernel@lists.linaro.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, Arvind.Chauhan@arm.com,
        linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 March 2013 23:43, Tejun Heo <tj@kernel.org> wrote:
> Viresh, would it be difficult to make another measurement of the same
> workload with the said workqueues converted to unbound?  I think that
> would at least provide a nice reference point.

My heart is shattered after getting the results :)


Cluster A15 Energy      Cluster A7 Energy       Total
-------------------------      -----------------------       ------

Without this patchset (Energy in Joules):
---------------------------------------------------

0.151162                2.183545                2.334707
0.223730                2.687067                2.910797
0.289687                2.732702                3.022389
0.454198                2.745908                3.200106
0.495552                2.746465                3.242017

Average:
0.322866                2.619137                2.942003


With this patchset (Energy in Joules):
-----------------------------------------------

0.133361                2.267822                2.401183
0.260626                2.833389                3.094015
0.142365                2.277929                2.420294
0.246793                2.582550                2.829343
0.130462                2.257033                2.387495

Average:
0.182721                2.443745                2.626466


With WQ Unbound (Energy in Joules):
-----------------------------------------------

0.226421                2.283658                2.510079
0.151361                2.236656                2.388017
0.197726                2.249849                2.447575
0.221915                2.229446                2.451361
0.347098                2.257707                2.604805

Average:
0.2289042              2.2514632              2.4803674

PS: I have to add another generic workqueue for these tests:
system_unbound_freezable_wq as block layer was using
system_freezable_wq.

--
viresh
