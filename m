Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444Ab3LMI5W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 03:57:22 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:51702 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231Ab3LMI5U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 03:57:20 -0500
X-Originating-IP: 50.43.14.201
Date: Fri, 13 Dec 2013 00:57:14 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, Cliff Whickman <cpw@sgi.com>,
        Robin Holt <robinmholt@gmail.com>
Subject: Re: [PATCH 3/5] drivers: misc: Mark functions as static in xpc_main.c
Message-ID: <20131213085713.GC4386@leaf>
References: <40521f78bafae3cc4e796c540d3c497d79eeb63e.1386915618.git.rashika.kheria@gmail.com>
 <247d6936184150df6f885ad656dae7412aaf6260.1386915618.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <247d6936184150df6f885ad656dae7412aaf6260.1386915618.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 12:24:05PM +0530, Rashika Kheria wrote:
> This patch marks the function xpc_init() and xpc_exit() as static in
> sgi-xp/xpc_main.c because they are not used outside this file.
> 
> Thus, it also eliminates the following warnings in sgi-xp/xpc_main.c:
> drivers/misc/sgi-xp/xpc_main.c:1231:1: warning: no previous prototype for ‘xpc_init’ [-Wmissing-prototypes]
> drivers/misc/sgi-xp/xpc_main.c:1349:1: warning: no previous prototype for ‘xpc_exit’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  drivers/misc/sgi-xp/xpc_main.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/misc/sgi-xp/xpc_main.c b/drivers/misc/sgi-xp/xpc_main.c
> index 82dc574..5b1b10d 100644
> --- a/drivers/misc/sgi-xp/xpc_main.c
> +++ b/drivers/misc/sgi-xp/xpc_main.c
> @@ -1227,7 +1227,7 @@ xpc_system_die(struct notifier_block *nb, unsigned long event, void *_die_args)
>  	return NOTIFY_DONE;
>  }
>  
> -int __init
> +static int __init
>  xpc_init(void)
>  {
>  	int ret;
> @@ -1345,7 +1345,7 @@ out_1:
>  
>  module_init(xpc_init);
>  
> -void __exit
> +static void __exit
>  xpc_exit(void)
>  {
>  	xpc_do_exit(xpUnloading);
> -- 
> 1.7.9.5
> 
