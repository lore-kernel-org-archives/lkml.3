Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751389Ab3IQEcx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 00:32:53 -0400
Received: from nbd.name ([46.4.11.11]:57313 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130Ab3IQEcv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 00:32:51 -0400
Message-ID: <5237DB62.2060303@phrozen.org>
Date: Tue, 17 Sep 2013 06:32:34 +0200
From: John Crispin <john@phrozen.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org
Subject: Re: [PATCH 28/28] mips: use common of_flat_dt_get_machine_name
References: <1379372965-22359-1-git-send-email-robherring2@gmail.com> <1379372965-22359-29-git-send-email-robherring2@gmail.com>
In-Reply-To: <1379372965-22359-29-git-send-email-robherring2@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/09/13 01:09, Rob Herring wrote:
> From: Rob Herring<rob.herring@calxeda.com>
>
> Convert mips to use the common of_flat_dt_get_machine_name function.
>
> Signed-off-by: Rob Herring<rob.herring@calxeda.com>
> Cc: Ralf Baechle<ralf@linux-mips.org>
> Cc: linux-mips@linux-mips.org
> ---


Acked-by: John Crispin <blogic@openwrt.org>


Thanks for this series ...



>   arch/mips/kernel/prom.c | 15 +--------------
>   1 file changed, 1 insertion(+), 14 deletions(-)
>
> diff --git a/arch/mips/kernel/prom.c b/arch/mips/kernel/prom.c
> index 0b2485f..3c3b0df 100644
> --- a/arch/mips/kernel/prom.c
> +++ b/arch/mips/kernel/prom.c
> @@ -47,24 +47,11 @@ void * __init early_init_dt_alloc_memory_arch(u64 size, u64 align)
>   	return __alloc_bootmem(size, align, __pa(MAX_DMA_ADDRESS));
>   }
>
> -int __init early_init_dt_scan_model(unsigned long node,	const char *uname,
> -				    int depth, void *data)
> -{
> -	if (!depth) {
> -		char *model = of_get_flat_dt_prop(node, "model", NULL);
> -
> -		if (model)
> -			mips_set_machine_name(model);
> -	}
> -	return 0;
> -}
> -
>   void __init __dt_setup_arch(struct boot_param_header *bph)
>   {
>   	if (!early_init_dt_scan(bph))
>   		return;
>
> -	/* try to load the mips machine name */
> -	of_scan_flat_dt(early_init_dt_scan_model, NULL);
> +	mips_set_machine_name(of_flat_dt_get_machine_name());
>   }
>   #endif

