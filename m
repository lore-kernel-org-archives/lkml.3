Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342Ab3G2DcN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 23:32:13 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:45471 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752580Ab3G2DcJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 23:32:09 -0400
X-IronPort-AV: E=Sophos;i="4.89,766,1367942400"; 
   d="scan'208";a="8053013"
Message-ID: <51F5E31C.30000@cn.fujitsu.com>
Date: Mon, 29 Jul 2013 11:35:56 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: Re: [PATCH RFC nohz_full 1/7] nohz_full: Add Kconfig parameter for
 scalable detection of all-idle state
References: <20130726231848.GA12967@linux.vnet.ibm.com> <1374880764-14248-1-git-send-email-paulmck@linux.vnet.ibm.com>
In-Reply-To: <1374880764-14248-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/29 11:29:51,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/29 11:29:57,
	Serialize complete at 2013/07/29 11:29:57
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2013 07:19 AM, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> At least one CPU must keep the scheduling-clock tick running for
> timekeeping purposes whenever there is a non-idle CPU.  However, with
> the new nohz_full adaptive-idle machinery, it is difficult to distinguish
> between all CPUs really being idle as opposed to all non-idle CPUs being
> in adaptive-ticks mode.  This commit therefore adds a Kconfig parameter
> as a first step towards enabling a scalable detection of full-system
> idle state.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/time/Kconfig | 23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
> 
> diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
> index 70f27e8..a613c2a 100644
> --- a/kernel/time/Kconfig
> +++ b/kernel/time/Kconfig
> @@ -134,6 +134,29 @@ config NO_HZ_FULL_ALL
>  	 Note the boot CPU will still be kept outside the range to
>  	 handle the timekeeping duty.
>  
> +config NO_HZ_FULL_SYSIDLE
> +	bool "Detect full-system idle state for full dynticks system"
> +	depends on NO_HZ_FULL
> +	default n
> +	help
> +	 At least one CPU must keep the scheduling-clock tick running
> +	 for timekeeping purposes whenever there is a non-idle CPU,
> +	 where "non-idle" includes CPUs with a single runnable task
> +	 in adaptive-idle mode.  Because the underlying adaptive-tick
> +	 support cannot distinguish between all CPUs being idle and
> +	 all CPUs each running a single task in adaptive-idle mode,
> +	 the underlying support simply ensures that there is always
> +	 a CPU handling the scheduling-clock tick, whether or not all
> +	 CPUs are idle.  This Kconfig option enables scalable detection
> +	 of the all-CPUs-idle state, thus allowing the scheduling-clock
> +	 tick to be disabled when all CPUs are idle.  Note that scalable
> +	 detection of the all-CPUs-idle state means that larger systems
> +	 will be slower to declare the all-CPUs-idle state.
> +
> +	 Say Y if you would like to help debug all-CPUs-idle detection.

The code is needed only for debug?
I guess not.

> +
> +	 Say N if you are unsure.
> +
>  config NO_HZ
>  	bool "Old Idle dynticks config"
>  	depends on !ARCH_USES_GETTIMEOFFSET && GENERIC_CLOCKEVENTS

