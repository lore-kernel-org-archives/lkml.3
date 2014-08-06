Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461AbaHFURI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 16:17:08 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:63155 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752343AbaHFURF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 16:17:05 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Hans Wennborg <hans@hanshq.net>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/15] cpufreq: fix decimal printf format specifiers prefixed with 0x
Date: Wed, 06 Aug 2014 22:35:46 +0200
Message-ID: <1494298.av10nJMuYA@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1407300108-32186-1-git-send-email-hans@hanshq.net>
References: <1407300108-32186-1-git-send-email-hans@hanshq.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 05, 2014 09:41:48 PM Hans Wennborg wrote:
> The prefix suggests the number should be printed in hex, so use
> the %x specifier to do that.
> 
> Found by using regex suggested by Joe Perches.
> 
> Signed-off-by: Hans Wennborg <hans@hanshq.net>

This triggers a build warning related to the formats.  Care to fix up?

> ---
>  drivers/cpufreq/speedstep-smi.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/cpufreq/speedstep-smi.c b/drivers/cpufreq/speedstep-smi.c
> index 8635eec..fda9beb 100644
> --- a/drivers/cpufreq/speedstep-smi.c
> +++ b/drivers/cpufreq/speedstep-smi.c
> @@ -324,8 +324,8 @@ static int __init speedstep_init(void)
>  		return -ENODEV;
>  	}
>  
> -	pr_debug("signature:0x%.8ulx, command:0x%.8ulx, "
> -		"event:0x%.8ulx, perf_level:0x%.8ulx.\n",
> +	pr_debug("signature:0x%.8lx, command:0x%.8lx, "
> +		"event:0x%.8lx, perf_level:0x%.8lx.\n",
>  		ist_info.signature, ist_info.command,
>  		ist_info.event, ist_info.perf_level);
>  
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
