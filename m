Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168AbaAINSG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 08:18:06 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:50366 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751060AbaAINRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 08:17:55 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: " Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        " H. Peter Anvin" <hpa@linux.intel.com>,
        Len Brown <len.brown@intel.com>, Len Brown <lenb@kernel.org>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] intel_idle: close avn_cstates array with correct marker
Date: Thu, 09 Jan 2014 14:31:45 +0100
Message-ID: <5913087.iUSSiA9xVP@vostro.rjw.lan>
User-Agent: KMail/4.11.3 (Linux/3.13.0-rc6+; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1389252628-1033-2-git-send-email-jiang.liu@linux.intel.com>
References: <1389252628-1033-1-git-send-email-jiang.liu@linux.intel.com> <1389252628-1033-2-git-send-email-jiang.liu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 09, 2014 03:30:27 PM Jiang Liu wrote:
> Close avn_cstates array with correct marker to avoid overflow
> in function intel_idle_cpu_init().
> 
> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> Cc: <stable@vger.kernel.org> # 3.13

Why did you mark it for 3.13-stable?  3.13 hasn't been released yet, so this
can be pushed for 3.13 still.

Is the problem present in 3.13-rc?  If so, has it been introduced by any
recent commits or was it there before?  In which case, do we need this patch
in stable as well?

Rafael


> ---
>  drivers/idle/intel_idle.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
> index 6f456f0..797ed29 100644
> --- a/drivers/idle/intel_idle.c
> +++ b/drivers/idle/intel_idle.c
> @@ -329,7 +329,7 @@ static struct cpuidle_state atom_cstates[] = {
>  	{
>  		.enter = NULL }
>  };
> -static struct cpuidle_state avn_cstates[] __initdata = {
> +static struct cpuidle_state avn_cstates[] = {
>  	{
>  		.name = "C1-AVN",
>  		.desc = "MWAIT 0x00",
> @@ -344,6 +344,8 @@ static struct cpuidle_state avn_cstates[] __initdata = {
>  		.exit_latency = 15,
>  		.target_residency = 45,
>  		.enter = &intel_idle },
> +	{
> +		.enter = NULL }
>  };
>  
>  /**
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
