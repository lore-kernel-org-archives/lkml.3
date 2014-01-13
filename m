Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166AbaAMUxU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 15:53:20 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:58408 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752198AbaAMUxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 15:53:16 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: peterz@infradead.org, mingo@kernel.org, markgross@thegnar.org,
        vincent.guittot@linaro.org, catalin.marinas@arm.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [3/11] issue 3: No understanding of potential cpu capacity
Date: Mon, 13 Jan 2014 22:07:12 +0100
Message-ID: <3700155.hLuCBAXQoy@vostro.rjw.lan>
User-Agent: KMail/4.11.3 (Linux/3.13.0-rc8+; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1389111587-5923-4-git-send-email-morten.rasmussen@arm.com>
References: <1389111587-5923-1-git-send-email-morten.rasmussen@arm.com> <1389111587-5923-4-git-send-email-morten.rasmussen@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 07, 2014 04:19:39 PM Morten Rasmussen wrote:
> To minimize energy it may sometimes be better to put waking tasks on
> partially loaded cpus instead of powering up more cpus (particularly if
> it implies powering up a new cluster/group of cpus with associated
> caches). To make that call, information about the potential spare cycles
> on the busy cpus is required.

That generally is not the only thing that matters.  There's one more factor
called "responsiveness" that used to be popular in the past.  It, roughly,
is about how much time it takes for the system to respond to user actions,
on the average.

> Currently, the CFS scheduler has no knowledge about frequency scaling.
> Frequency scaling governors generally try to match the frequency to
> the load, which means that the idle time has no absolute meaning. The
> potential spare cpu capacity may be much higher than indicated by the
> idle time if the cpu is running at a low P-state.
> 
> The energy trade-off may justify putting another task on a loaded cpu
> even if it causes a change to a higher P-state to handle the extra load.
> Related issues are frequency (and cpu micro architecture) invariant task
> load and power topology information, which are both needed to enable the
> scheduler for energy-aware task placement. This is covered in more
> detail in issue 5.
> 
> The potential cpu capacity cannot be assumed to be constant as thermal
> management may restrict the usage of high performance P-states
> dynamically.

That's correct.  Moreover, all of the above seems to assume that we can get
exact power numbers for all of the involved C-states and P-states.  What if
we can't?

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
