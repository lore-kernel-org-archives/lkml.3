Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993AbaKDHXR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 02:23:17 -0500
Received: from casper.infradead.org ([85.118.1.10]:34472 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbaKDHXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 02:23:15 -0500
Date: Tue, 4 Nov 2014 08:23:08 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Pawel Moll <pawel.moll@arm.com>
Cc: Richard Cochran <richardcochran@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christopher Covington <cov@codeaurora.org>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH v3 1/3] perf: Use monotonic clock as a source for
 timestamps
Message-ID: <20141104072308.GE10501@worktop.programming.kicks-ass.net>
References: <1415060918-19954-1-git-send-email-pawel.moll@arm.com>
 <1415060918-19954-2-git-send-email-pawel.moll@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415060918-19954-2-git-send-email-pawel.moll@arm.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 12:28:36AM +0000, Pawel Moll wrote:

> +int sysctl_perf_sample_time_clk_id = CLOCK_MONOTONIC;

const ?

>  /*
>   * perf samples are done in some very critical code paths (NMIs).
>   * If they take too much CPU time, the system can lock up and not
> @@ -324,7 +326,7 @@ extern __weak const char *perf_pmu_name(void)
>  
>  static inline u64 perf_clock(void)
>  {
> -	return local_clock();
> +	return ktime_get_mono_fast_ns();
>  }

Do we maybe want to make it boot-time switchable back to local_clock for
people with bad systems and or backwards compat issues?

Everybody using Core2 and older will very much not want to have this
unless they've got a very good reason for wanting it.
