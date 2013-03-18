Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417Ab3CRIiH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 04:38:07 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:49650 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190Ab3CRIiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 04:38:04 -0400
X-AuditID: 9c930197-b7cc2ae000000eb7-a0-5146d2690390
From: Namhyung Kim <namhyung@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Borislav Petkov <bp@suse.de>,
        Robert Richter <rric@kernel.org>
Subject: Re: [RFC PATCH 0/3] Perf persistent events
References: <1363352789-17991-1-git-send-email-bp@alien8.de>
Date: Mon, 18 Mar 2013 17:38:01 +0900
In-Reply-To: <1363352789-17991-1-git-send-email-bp@alien8.de> (Borislav
	Petkov's message of "Fri, 15 Mar 2013 14:06:26 +0100")
Message-ID: <87d2uxje6u.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Borislav,

On Fri, 15 Mar 2013 14:06:26 +0100, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
>
> Yeah,
>
> here's a refresh of the persistent events deal, accessing those is much
> cleaner now. Here's how:
>
> So kernel code initializes and enables the event at its convenience
> (during boot, whenever) and userspace goes and says:
>
> 	sys_perf_event_open(pattr,...)
>
> with pattr.persistent = 1. Userspace gets the persistent buffer file
> descriptor to read from. Without that, we get a normal perf file
> descriptor for the duration of the tracing.
>
> This saves all the diddling of trying to hand down file descriptors
> through debugfs or whatever. Instead, current perf code simply can use
> it.

Interesting, it'll helpful profiling boot-time behaviors.

So my question is how can an user know which persistent events are
available in her system?

Thanks,
Namhyung

>
> This is still RFC but things are starting to fall into place slowly. As
> always, any and all comments/suggestions are welcome.
>
> Borislav Petkov (3):
>   perf: Add persistent events
>   perf: Add persistent event facilities
>   MCE: Enable persistent event
>
>  arch/x86/kernel/cpu/mcheck/mce.c |  25 +++++++
>  include/linux/perf_event.h       |  14 +++-
>  include/uapi/linux/perf_event.h  |   3 +-
>  kernel/events/Makefile           |   2 +-
>  kernel/events/core.c             |  27 +++++---
>  kernel/events/internal.h         |   4 ++
>  kernel/events/persistent.c       | 141 +++++++++++++++++++++++++++++++++++++++
>  7 files changed, 202 insertions(+), 14 deletions(-)
>  create mode 100644 kernel/events/persistent.c
