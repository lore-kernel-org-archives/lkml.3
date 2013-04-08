Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935420Ab3DHK0V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 06:26:21 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:45591 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936643Ab3DHK0T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 06:26:19 -0400
Message-ID: <51629B3D.4080905@ti.com>
Date: Mon, 8 Apr 2013 15:56:05 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Prabhakar lad <prabhakar.csengg@gmail.com>
CC: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        LMML <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] media: davinci: vpss: enable vpss clocks
References: <1364903044-13752-1-git-send-email-prabhakar.csengg@gmail.com> <1364903044-13752-2-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1364903044-13752-2-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/2/2013 5:14 PM, Prabhakar lad wrote:
> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> 
> By default the VPSS clocks were enabled in capture driver
> for davinci family which creates duplicates for dm355/dm365/dm644x.
> This patch adds support to enable the VPSS clocks in VPSS driver,
> which avoids duplication of code and also adding clock aliases.
> 
> This patch uses PM runtime API to enable/disable instead common clock
> framework. con_ids for master and slave clocks of vpss is added in pm_domain

Common clock framework in not (yet) used on DaVinci, so this is misleading.

> diff --git a/arch/arm/mach-davinci/pm_domain.c b/arch/arm/mach-davinci/pm_domain.c
> index c90250e..445b10b 100644
> --- a/arch/arm/mach-davinci/pm_domain.c
> +++ b/arch/arm/mach-davinci/pm_domain.c
> @@ -53,7 +53,7 @@ static struct dev_pm_domain davinci_pm_domain = {
>  
>  static struct pm_clk_notifier_block platform_bus_notifier = {
>  	.pm_domain = &davinci_pm_domain,
> -	.con_ids = { "fck", NULL, },
> +	.con_ids = { "fck", "master", "slave", NULL, },

NULL is sentinel so you can drop the ',' after that. Apart from that,
for the mach-davinci parts:

Acked-by: Sekhar Nori <nsekhar@ti.com>

Thanks,
Sekhar
