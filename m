Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756436AbaELMA7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 08:00:59 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:49889 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755885AbaELMA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 08:00:58 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: dirk.brandewie@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
Subject: Re: [PATCH 3/5] intel_pstate: Fix fixed point rounding macro
Date: Mon, 12 May 2014 14:17:43 +0200
Message-ID: <10396519.O9MHslF7EE@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1399579047-5792-4-git-send-email-dirk.j.brandewie@intel.com>
References: <1399579047-5792-1-git-send-email-dirk.j.brandewie@intel.com> <1399579047-5792-4-git-send-email-dirk.j.brandewie@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 08, 2014 12:57:25 PM dirk.brandewie@gmail.com wrote:
> From: Dirk Brandewie <dirk.j.brandewie@intel.com>
> 
> Change the FP_ROUNDUP macro to add 0.5 in fixed point representation
> instead of 1.0

It would be good to say why exactly it is a problem too.  I guess it overflows
sometimes, right?

> Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
> ---
>  drivers/cpufreq/intel_pstate.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
> index eab8ccf..bb20881 100644
> --- a/drivers/cpufreq/intel_pstate.c
> +++ b/drivers/cpufreq/intel_pstate.c
> @@ -43,7 +43,7 @@
>  #define FRAC_BITS 6
>  #define int_tofp(X) ((int64_t)(X) << FRAC_BITS)
>  #define fp_toint(X) ((X) >> FRAC_BITS)
> -#define FP_ROUNDUP(X) ((X) += 1 << FRAC_BITS)
> +#define FP_ROUNDUP(X) ((X) += 1 << (FRAC_BITS-1))
>  
>  static inline int32_t mul_fp(int32_t x, int32_t y)
>  {
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
