Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932958Ab3GPQMe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 12:12:34 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:48984 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932183Ab3GPQMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 12:12:32 -0400
Date: Tue, 16 Jul 2013 18:12:29 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] nohz: Do not warn about unstable tsc unless user uses
 nohz_full
Message-ID: <20130716161227.GB17900@somewhere.redhat.com>
References: <20130715170859.GA25570@redhat.com>
 <20130715171800.GD6442@somewhere>
 <20130715172423.GA27745@redhat.com>
 <20130715173848.GA1066@redhat.com>
 <1373914182.17876.165.camel@gandalf.local.home>
 <20130716010538.GD13562@somewhere>
 <1373984532.17876.276.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373984532.17876.276.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 10:22:12AM -0400, Steven Rostedt wrote:
> If the user enables CONFIG_NO_HZ_FULL and runs the kernel on a machine
> with an unstable TSC, it will produce a WARN_ON dump as well as taint
> the kernel. This is a bit extreme for a kernel that just enables a
> feature but doesn't use it.
> 
> The warning should only happen if the user tries to use the feature by
> either adding nohz_full to the kernel command line, or by enabling
> CONFIG_NO_HZ_FULL_ALL that makes nohz used on all CPUs at boot up. Note,
> this second feature should not (yet) be used by distros or anyone that
> doesn't care if NO_HZ is used or not.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index 6960172..6f47049 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -182,7 +182,8 @@ static bool can_stop_full_tick(void)
>  		 * Don't allow the user to think they can get
>  		 * full NO_HZ with this machine.
>  		 */
> -		WARN_ONCE(1, "NO_HZ FULL will not work with unstable sched clock");
> +		WARN_ONCE(have_nohz_full_mask,
> +			  "NO_HZ FULL will not work with unstable sched clock");

Seems good, indeed the warning and taint can be justified if the user filled the
nohz_full mask.

Ok I'll apply this and let the last word to Ingo in a pull request.

Thanks.

>  		return false;
>  	}
>  #endif
> 
> 
