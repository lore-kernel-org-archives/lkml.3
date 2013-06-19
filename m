Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965013Ab3FSSmr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 14:42:47 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:33107 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964914Ab3FSSmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 14:42:44 -0400
Date: Wed, 19 Jun 2013 20:42:40 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Kevin Hilman <khilman@linaro.org>
Cc: linaro-kernel@lists.linaro.org, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <clark.williams@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] sched/nohz: add sysctl control over
 sched_tick_max_deferment
Message-ID: <20130619184238.GD21522@somewhere.redhat.com>
References: <1371599913-1232-1-git-send-email-khilman@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371599913-1232-1-git-send-email-khilman@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 04:58:28PM -0700, Kevin Hilman wrote:
> Allow sysctl override of sched_tick_max_deferment in order to ease
> finding/fixing the remaining issues with full nohz.
> 
> The value to be written is in jiffies, and -1 means the max deferment
> is disabled (scheduler_tick_max_deferment() returns KTIME_MAX.)
> 
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Kevin Hilman <khilman@linaro.org>

This looks like a useful thing but I wonder if a debugfs file would
be more appropriate than sysctl.

The scheduler tick max deferment is supposed to be a temporary
hack so we probably don't want to bring a real user ABI for that.

I believe sysctl is for permanent ABIs, right?
