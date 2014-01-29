Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006AbaA2AGh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 19:06:37 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:57601 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755606AbaA2AGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 19:06:36 -0500
Date: Tue, 28 Jan 2014 16:06:30 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] nohz: ensure users are aware boot CPU is not NO_HZ_FULL
Message-ID: <20140129000630.GT9012@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1390929049-17758-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390929049-17758-1-git-send-email-paul.gortmaker@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14012900-0928-0000-0000-000005CB83B2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 12:10:49PM -0500, Paul Gortmaker wrote:
> This bit of information is in the Kconfig help text:
> 
>   Note the boot CPU will still be kept outside the range to
>   handle the timekeeping duty.
> 
> However neither the variable NO_HZ_FULL_ALL, or the prompt
> convey this important detail, so lets add it to the prompt
> to make it more explicitly obvious to the average user.
> 
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  kernel/time/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
> index 3ce6e8c5f3fc..76a1fbef1fd8 100644
> --- a/kernel/time/Kconfig
> +++ b/kernel/time/Kconfig
> @@ -124,7 +124,7 @@ config NO_HZ_FULL
>  endchoice
> 
>  config NO_HZ_FULL_ALL
> -       bool "Full dynticks system on all CPUs by default"
> +       bool "Full dynticks system on all (but boot) CPUs by default"
>         depends on NO_HZ_FULL
>         help
>           If the user doesn't pass the nohz_full boot option to
> -- 
> 1.8.5.2
> 

