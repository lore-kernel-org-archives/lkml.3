Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266AbaGVXgM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 19:36:12 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:56537 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756817AbaGVXgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 19:36:11 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Mohammad Merajul Islam Molla <meraj.enigma@gmail.com>
Cc: linux-pm@vger.kernel.org, daniel.lezcano@linaro.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH] cpuidle: fix permission for driver name sysfs node
Date: Wed, 23 Jul 2014 01:54:35 +0200
Message-ID: <1636314.JDKxdToLsi@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1405171762-31119-1-git-send-email-meraj.enigma@gmail.com>
References: <1405171762-31119-1-git-send-email-meraj.enigma@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, July 12, 2014 07:29:22 PM Mohammad Merajul Islam Molla wrote:
> cpuidle driver name sysfs node is read-only. So permission should be 0444.
> 
> Signed-off-by: Mohammad Merajul Islam Molla <meraj.enigma@gmail.com>

Queued up for 3.17, thanks!

> ---
>  drivers/cpuidle/sysfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/cpuidle/sysfs.c b/drivers/cpuidle/sysfs.c
> index efe2f17..97c5903 100644
> --- a/drivers/cpuidle/sysfs.c
> +++ b/drivers/cpuidle/sysfs.c
> @@ -445,7 +445,7 @@ static void cpuidle_remove_state_sysfs(struct cpuidle_device *device)
>  
>  #define define_one_driver_ro(_name, show)                       \
>  	static struct cpuidle_driver_attr attr_driver_##_name = \
> -		__ATTR(_name, 0644, show, NULL)
> +		__ATTR(_name, 0444, show, NULL)
>  
>  struct cpuidle_driver_kobj {
>  	struct cpuidle_driver *drv;
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
