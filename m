Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932220AbaENNFX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 09:05:23 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:50834 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbaENNFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 09:05:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Chander Kashyap <chander.kashyap@linaro.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Chander Kashyap <k.chander@samsung.com>, lorenzo.pieralisi@arm.com,
        daniel.lezcano@linaro.org, rjw@rjwysocki.net, kgene.kim@samsung.com
Subject: Re: [PATCH v5 4/6] driver: cpuidle: cpuidle-big-little: init driver for Exynos5420
Date: Wed, 14 May 2014 15:04:51 +0200
Message-ID: <5587958.90ud9NuKXm@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1400054637-21505-5-git-send-email-chander.kashyap@linaro.org>
References: <ANuQgHGSPJ45tbrVppAVpOqF0OfHacPWfX=S5mOVxTPr66f7vg@mail.gmail.com> <1400054637-21505-1-git-send-email-chander.kashyap@linaro.org> <1400054637-21505-5-git-send-email-chander.kashyap@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:A3pOebyP09lrIKf0mjWFiEzcQOfe9egVOuBT6lTWLY7
 IhGz/w42pcW2oAqHaG5DATtLIQ1mN9UN86lcicrAD8Tmd55zLE
 mmYiAssNbSTtqAXaG9oTKgPmBkRdG7O8ocYsi/sYAY4lDlIpEr
 /yJbKjnxLKcqXn2otjRReki6dzOWiLn3WZy+UEK0aFZ/dzaoLb
 BkhSFQIPRmcPJ9mkJH1DdcNxxYXYfNFpUS+vv8rELQ9PDPWbfQ
 CTGurBqagaMDUlF3lCNrJpHGeRARU+hLxNx+10LWborLaQNT/R
 VAAeFTpAn2clqX1YWIk4rLn+CP0mno8edFEPycn5Xxp0wzfl7M
 jLLmzHK5RPJsu1Kj19z4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 May 2014 13:33:55 Chander Kashyap wrote:
> 
> diff --git a/drivers/cpuidle/cpuidle-big_little.c b/drivers/cpuidle/cpuidle-big_little.c
> index 4cd02bd..344d79fa 100644
> --- a/drivers/cpuidle/cpuidle-big_little.c
> +++ b/drivers/cpuidle/cpuidle-big_little.c
> @@ -165,6 +165,7 @@ static int __init bl_idle_driver_init(struct cpuidle_driver *drv, int cpu_id)
>  
>  static const struct of_device_id compatible_machine_match[] = {
>         { .compatible = "arm,vexpress,v2p-ca15_a7" },
> +       { .compatible = "samsung,exynos5420" },
>         {},
>  };

Does the cpuidle-big_little driver actually care about the platform?
If not, it would be good to add a generic string here as well, for
future platforms to match.

It still makes sense to list both the generic string and the platform
specific one though, in case we have to work around subtle differences.

	Arnd
