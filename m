Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757517AbaEIVi7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 17:38:59 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:65457 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756553AbaEIVi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 17:38:57 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] kernel/power/hibernate.c: convert simple_strtoul to kstrtoul
Date: Fri, 09 May 2014 23:55:39 +0200
Message-ID: <13472444.sHWql5LHCk@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140509200903.2917158bfbe26723226122c5@skynet.be>
References: <20140509200903.2917158bfbe26723226122c5@skynet.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 09, 2014 08:09:03 PM Fabian Frederick wrote:
> 
> Inspired-By: Andrew Morton <akpm@linux-foundation.org>
> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Queued up for 3.16, thanks!

> ---
>  kernel/power/hibernate.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
> index f4f2073..66332b6 100644
> --- a/kernel/power/hibernate.c
> +++ b/kernel/power/hibernate.c
> @@ -1109,7 +1109,10 @@ static int __init resumewait_setup(char *str)
>  
>  static int __init resumedelay_setup(char *str)
>  {
> -	resume_delay = simple_strtoul(str, NULL, 0);
> +	int rc = kstrtoul(str, 0, (unsigned long *)&resume_delay);
> +
> +	if (rc)
> +		return rc;
>  	return 1;
>  }
>  
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
