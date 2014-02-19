Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491AbaBSAoL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 19:44:11 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:56042 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751587AbaBSAoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 19:44:09 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: dirk.brandewie@gmail.com
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
Subject: Re: [PATCH 4/5] intel_pstate: Use LFM bus ratio as min ratio/P state
Date: Wed, 19 Feb 2014 01:58:59 +0100
Message-ID: <5856987.3qKttR09W1@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1392228067-14817-5-git-send-email-dirk.j.brandewie@intel.com>
References: <1392228067-14817-1-git-send-email-dirk.j.brandewie@intel.com> <1392228067-14817-5-git-send-email-dirk.j.brandewie@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, February 12, 2014 10:01:06 AM dirk.brandewie@gmail.com wrote:
> From: Dirk Brandewie <dirk.j.brandewie@intel.com>
> 
> Using LFM ratio provides better perf/watt vs min ratio.
> 
> Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>

This changelog is particularly insufficient.

Can you please explain what's wrong with the previous calculation and how
the change makes it better?

> ---
>  drivers/cpufreq/intel_pstate.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
> index b80c03d..ff45ce1 100644
> --- a/drivers/cpufreq/intel_pstate.c
> +++ b/drivers/cpufreq/intel_pstate.c
> @@ -356,7 +356,7 @@ static int byt_get_min_pstate(void)
>  {
>  	u64 value;
>  	rdmsrl(BYT_RATIOS, value);
> -	return value & 0xFF;
> +	return (value >> 8) & 0xFF;
>  }
>  
>  static int byt_get_max_pstate(void)
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
