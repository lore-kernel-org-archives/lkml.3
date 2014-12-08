Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303AbaLHMm4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 07:42:56 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:53112 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754855AbaLHMmz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 07:42:55 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Richard Leitner <dev@g0hl1n.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: Re: [PATCH] misc: ioc4: fix variable may be used uninitialized warning
Date: Mon, 08 Dec 2014 13:42:47 +0100
Message-ID: <4066664.BgJJnCmQ3h@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141208132720.16356743@frodo>
References: <20141208132720.16356743@frodo>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
X-Provags-ID: V03:K0:VXU0MnpF6XG9SEEnW/m/T5U2yG6FTC5oFeNbdcCvPLWGRYggkYt
 rJWmvlXEruINcce6P91BXpXziN6tC2Gi3zzqWvIVPC/4kYT2tq+nTMLGKCSIpAsNns/eIrc
 JpRG95uxlfqTRjmSqiYG98/0veAZfbjCWmjnKS/bG4QzbATqMGR7pSbXnR02GYfdTeeKE0w
 jx5RX8TluHrbsp/HDhjXQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 December 2014 13:27:20 Richard Leitner wrote:
> Fix the following build warning:
> drivers/misc/ioc4.c: In function ‘ioc4_probe’:
> drivers/misc/ioc4.c:194:16: warning: ‘start’ may be used uninitialized
> in this function [-Wmaybe-uninitialized]
>   period = (end - start) /
>                 ^
> drivers/misc/ioc4.c:148:11: note: ‘start’ was declared here
>   uint64_t start, end, period;
>            ^
> 
> As far as I can tell 'start' cannot really be used uninitialized
> here, but for the sanity of gcc output explicitly initialize it.
> Same goes for the 'end' variable.
> 
> Signed-off-by: Richard Leitner <dev@g0hl1n.net>

Prabhakar Lad also sent a patch for this already, which was lacking
a good patch description. Your patch does this slightly better but
still fails to explain how you concluded it was safe and you don't
really explain why you initialize the 'end' variable that we don't
even get a warning about.

	Arnd

> ---
> Used gcc version was 4.9.1 (Debian 4.9.1-19)
> P.S.: I know I'm too late for 3.18 but hopefully it still helps.
> ---
>  drivers/misc/ioc4.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/misc/ioc4.c b/drivers/misc/ioc4.c
> index 3336ddc..7ec2733 100644
> --- a/drivers/misc/ioc4.c
> +++ b/drivers/misc/ioc4.c
> @@ -145,7 +145,7 @@ ioc4_clock_calibrate(struct ioc4_driver_data *idd)
>  	union ioc4_int_out int_out;
>  	union ioc4_gpcr gpcr;
>  	unsigned int state, last_state = 1;
> -	uint64_t start, end, period;
> +	uint64_t start = 0, end = 0, period;
>  	unsigned int count = 0;
>  
>  	/* Enable output */
> 

