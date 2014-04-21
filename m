Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751217AbaDUFvu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 01:51:50 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:39479 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbaDUFvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 01:51:48 -0400
MIME-Version: 1.0
In-Reply-To: <1397728407-13909-1-git-send-email-geert+renesas@glider.be>
References: <1397728407-13909-1-git-send-email-geert+renesas@glider.be>
Date: Mon, 21 Apr 2014 11:21:48 +0530
Message-ID: <CAKohpon6BvgtwrHWQn8va49ZbNF0XbDDHf4ytP=vA5zudRYzgg@mail.gmail.com>
Subject: Re: [PATCH 1/3] cpufreq: ppc: Add missing #include <asm/smp.h>
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 April 2014 15:23, Geert Uytterhoeven <geert+renesas@glider.be> wrote:
> If CONFIG_SMP=n, <linux/smp.h> does not include <asm/smp.h>, causing:
>
> drivers/cpufreq/ppc-corenet-cpufreq.c: In function 'corenet_cpufreq_cpu_init':
> drivers/cpufreq/ppc-corenet-cpufreq.c:173:3: error: implicit declaration of function 'get_hard_smp_processor_id' [-Werror=implicit-function-declaration]
>
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  drivers/cpufreq/ppc-corenet-cpufreq.c |    2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/cpufreq/ppc-corenet-cpufreq.c b/drivers/cpufreq/ppc-corenet-cpufreq.c
> index b7e677be1df0..e78f9c806de4 100644
> --- a/drivers/cpufreq/ppc-corenet-cpufreq.c
> +++ b/drivers/cpufreq/ppc-corenet-cpufreq.c
> @@ -22,6 +22,8 @@
>  #include <linux/smp.h>
>  #include <sysdev/fsl_soc.h>
>
> +#include <asm/smp.h>
> +

Probably similar to what Srivatsa did:

+#include <asm/smp.h> /* Required for cpu_sibling_mask() in UP configs */

??
