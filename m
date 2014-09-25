Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966AbaIYXdG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 19:33:06 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:63121 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751987AbaIYXdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 19:33:03 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>, linux-pm@vger.kernel.org
Subject: Re: [PATCH 12/22] cpuidle: Replace strnicmp with strncasecmp
Date: Fri, 26 Sep 2014 01:52:53 +0200
Message-ID: <19635709.J0Hgc1vM0J@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1410900696-6481-13-git-send-email-linux@rasmusvillemoes.dk>
References: <1410900696-6481-1-git-send-email-linux@rasmusvillemoes.dk> <1410900696-6481-13-git-send-email-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 16, 2014 10:51:26 PM Rasmus Villemoes wrote:
> The kernel used to contain two functions for length-delimited,
> case-insensitive string comparison, strnicmp with correct semantics
> and a slightly buggy strncasecmp. The latter is the POSIX name, so
> strnicmp was renamed to strncasecmp, and strnicmp made into a wrapper
> for the new strncasecmp to avoid breaking existing users.
> 
> To allow the compat wrapper strnicmp to be removed at some point in
> the future, and to avoid the extra indirection cost, do
> s/strnicmp/strncasecmp/g.
> 
> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> Cc: linux-pm@vger.kernel.org
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>

Queued up for 3.18, thanks!

> ---
>  drivers/cpuidle/governor.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/cpuidle/governor.c b/drivers/cpuidle/governor.c
> index ca89412..fb9f511 100644
> --- a/drivers/cpuidle/governor.c
> +++ b/drivers/cpuidle/governor.c
> @@ -28,7 +28,7 @@ static struct cpuidle_governor * __cpuidle_find_governor(const char *str)
>  	struct cpuidle_governor *gov;
>  
>  	list_for_each_entry(gov, &cpuidle_governors, governor_list)
> -		if (!strnicmp(str, gov->name, CPUIDLE_NAME_LEN))
> +		if (!strncasecmp(str, gov->name, CPUIDLE_NAME_LEN))
>  			return gov;
>  
>  	return NULL;
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
