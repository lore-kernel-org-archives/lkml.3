Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885AbaBJQTo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 11:19:44 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:65049 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbaBJQTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 11:19:38 -0500
Date: Mon, 10 Feb 2014 17:19:34 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v2] nohz: ensure users are aware boot CPU is not
 NO_HZ_FULL
Message-ID: <20140210161933.GB21060@localhost.localdomain>
References: <52F3D583.9070208@windriver.com>
 <1391711781-7466-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391711781-7466-1-git-send-email-paul.gortmaker@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 06, 2014 at 01:36:21PM -0500, Paul Gortmaker wrote:
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

Paul, I guess I can keep your ack on this 2nd version?

> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

Applied, thanks a lot!

> ---
> 
> v2: use "CPU 0" instead of "boot CPU".
> 
>  kernel/time/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
> index 3ce6e8c5f3fc..f448513a45ed 100644
> --- a/kernel/time/Kconfig
> +++ b/kernel/time/Kconfig
> @@ -124,7 +124,7 @@ config NO_HZ_FULL
>  endchoice
>  
>  config NO_HZ_FULL_ALL
> -       bool "Full dynticks system on all CPUs by default"
> +       bool "Full dynticks system on all CPUs by default (except CPU 0)"
>         depends on NO_HZ_FULL
>         help
>           If the user doesn't pass the nohz_full boot option to
> -- 
> 1.8.5.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
