Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218AbaBTA3O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 19:29:14 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:50214 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751813AbaBTA3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 19:29:13 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: dirk.brandewie@gmail.com
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
Subject: Re: [PATCH v2] intel_pstate: Use LFM bus ratio as min ratio/P state
Date: Thu, 20 Feb 2014 01:44:04 +0100
Message-ID: <2338280.snAhRfpdt9@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1392834925-21648-1-git-send-email-dirk.j.brandewie@intel.com>
References: <5856987.3qKttR09W1@vostro.rjw.lan> <1392834925-21648-1-git-send-email-dirk.j.brandewie@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, February 19, 2014 10:35:25 AM dirk.brandewie@gmail.com wrote:
> From: Dirk Brandewie <dirk.j.brandewie@intel.com>
> 
> LFM (max efficiency ratio) is the max frequency at minimum voltage
> supported by the processor.  Using LFM as the minimum P state
> increases performmance without affecting power. By not using P states
> below LFM we avoid using P states that are less power efficient.
> 
> Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>

Thanks!  I've replaced the original changelog with the one above.

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
