Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751206AbaCaTnH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 15:43:07 -0400
Received: from www.linutronix.de ([62.245.132.108]:36287 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbaCaTnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 15:43:05 -0400
Date: Mon, 31 Mar 2014 21:43:13 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Cyrill Gorcunov <gorcunov@openvz.org>
cc: linux-kernel@vger.kernel.org, shawn@churchofgit.com,
        akpm@linux-foundation.org, avagin@openvz.org, xemul@parallels.com
Subject: Re: [rfc 1/2] timerfd: Implement show_fdinfo method
In-Reply-To: <20140331175957.509391054@openvz.org>
Message-ID: <alpine.DEB.2.02.1403312134570.14882@ionos.tec.linutronix.de>
References: <20140331175407.400476950@openvz.org> <20140331175957.509391054@openvz.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Mar 2014, Cyrill Gorcunov wrote:
> For checkpoint/restore of timerfd files we need to know the clock
> type being used on timerfd creation. Thus implement show_fdinfo
> method where we print out the type.
> 
> Also to minimize the number of calls print out the ticks as well
> (thus one read of fdinfo entry would eliminate the need of doing
>  read() over timerfd itself).
> 
> CC: Shawn Landden <shawn@churchofgit.com>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: Andrey Vagin <avagin@openvz.org>
> CC: Pavel Emelyanov <xemul@parallels.com>
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> ---
>  fs/timerfd.c |    9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> Index: linux-2.6.git/fs/timerfd.c
> ===================================================================
> --- linux-2.6.git.orig/fs/timerfd.c
> +++ linux-2.6.git/fs/timerfd.c
> @@ -284,11 +284,20 @@ static ssize_t timerfd_read(struct file
>  	return res;
>  }
>  
> +static int timerfd_show(struct seq_file *m, struct file *file)
> +{
> +	struct timerfd_ctx *ctx = file->private_data;
> +
> +	return seq_printf(m, "clockid: %d ticks: %llu\n",
> +			  ctx->clockid, (unsigned long long)ctx->ticks);
> +}

And what gives you the flags which were used in timerfd_settime()
along with the remaining time to expiry and the interval?

Thanks,

	tglx


