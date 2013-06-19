Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935099Ab3FSUe2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 16:34:28 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:41813 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934714Ab3FSUe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 16:34:26 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linaro-kernel@lists.linaro.org, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <clark.williams@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] sched/nohz: add sysctl control over sched_tick_max_deferment
In-Reply-To: <20130619184238.GD21522@somewhere.redhat.com> (Frederic
	Weisbecker's message of "Wed, 19 Jun 2013 20:42:40 +0200")
References: <1371599913-1232-1-git-send-email-khilman@linaro.org>
	<20130619184238.GD21522@somewhere.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
Date: Wed, 19 Jun 2013 13:34:23 -0700
Message-ID: <87ehbx6drk.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker <fweisbec@gmail.com> writes:

> On Tue, Jun 18, 2013 at 04:58:28PM -0700, Kevin Hilman wrote:
>> Allow sysctl override of sched_tick_max_deferment in order to ease
>> finding/fixing the remaining issues with full nohz.
>> 
>> The value to be written is in jiffies, and -1 means the max deferment
>> is disabled (scheduler_tick_max_deferment() returns KTIME_MAX.)
>> 
>> Cc: Frederic Weisbecker <fweisbec@gmail.com>
>> Signed-off-by: Kevin Hilman <khilman@linaro.org>
>
> This looks like a useful thing but I wonder if a debugfs file would
> be more appropriate than sysctl.
>
> The scheduler tick max deferment is supposed to be a temporary
> hack so we probably don't want to bring a real user ABI for that.

I wondered about that as well, but I wasn't sure if the existing knobs
under CONFIG_SCHED_DEBUG (sched_min_granularity_ns, sched_latency_ns,
etc.) are considered permanant ABI, or optional debugging tools.

This new option is inside CONFIG_SCHED_DEBUG along with the others, but
if debugfs is preferred I can move it there.  It seems strange though to
just have this knob in debugfs and the rest in sysctl under
CONFIG_SCHED_DEBUG.

Thanks,

Kevin


