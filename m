Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487AbaAFAyi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 19:54:38 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:54556 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752015AbaAFAyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 19:54:35 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk
Subject: Re: [PATCH] cpufreq: arm-big-little: Make driver dependent on CONFIG_BIG_LITTLE
Date: Mon, 06 Jan 2014 02:08:21 +0100
Message-ID: <39696841.2xGCnmPGdl@vostro.rjw.lan>
User-Agent: KMail/4.11.3 (Linux/3.13.0-rc6+; KDE/4.11.3; x86_64; ; )
In-Reply-To: <a76f7b6a290d9174a24e15b13df21f53e3f5655f.1388736624.git.viresh.kumar@linaro.org>
References: <a76f7b6a290d9174a24e15b13df21f53e3f5655f.1388736624.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 03, 2014 03:51:39 PM Viresh Kumar wrote:
> arm_big_little cpufreq driver is only used for ARM bigLITTLE platforms and hence
> must be dependent on CONFIG_BIG_LITTLE.
> 
> This was highlighted by Russell earlier when he reported this issue:
> 
> drivers/built-in.o: In function `bL_cpufreq_set_rate':
> powercap_sys.c:(.text+0x5ed9a0): undefined reference to `bL_switch_request_cb'
> 
> Reported-by: Russell King <linux@arm.linux.org.uk>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Queued up for 3.14, thanks!

> ---
>  drivers/cpufreq/Kconfig.arm | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
> index 456ba5e..3275e9c 100644
> --- a/drivers/cpufreq/Kconfig.arm
> +++ b/drivers/cpufreq/Kconfig.arm
> @@ -4,7 +4,7 @@
>  
>  config ARM_BIG_LITTLE_CPUFREQ
>  	tristate "Generic ARM big LITTLE CPUfreq driver"
> -	depends on ARM && ARM_CPU_TOPOLOGY && HAVE_CLK
> +	depends on ARM && BIG_LITTLE && ARM_CPU_TOPOLOGY && HAVE_CLK
>  	select PM_OPP
>  	help
>  	  This enables the Generic CPUfreq driver for ARM big.LITTLE platforms.
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
