Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757103Ab3KHNGP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 08:06:15 -0500
Received: from multi.imgtec.com ([194.200.65.239]:42220 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756664Ab3KHNGN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 08:06:13 -0500
Message-ID: <527CE1C2.3030007@imgtec.com>
Date: Fri, 8 Nov 2013 13:06:10 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        linux-metag <linux-metag@vger.kernel.org>
Subject: Re: [PATCH v2 14/29] metag: use early_init_dt_scan
References: <1381163377-21044-1-git-send-email-robherring2@gmail.com> <1381163377-21044-15-git-send-email-robherring2@gmail.com>
In-Reply-To: <1381163377-21044-15-git-send-email-robherring2@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_11_08_13_06_11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/13 17:29, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> Convert metag to use new early_init_dt_scan function.
> 
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> Cc: James Hogan <james.hogan@imgtec.com>

Acked-by: James Hogan <james.hogan@imgtec.com>

Cheers
James

> ---
>  arch/metag/kernel/devtree.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/arch/metag/kernel/devtree.c b/arch/metag/kernel/devtree.c
> index 049af56..68c2fee 100644
> --- a/arch/metag/kernel/devtree.c
> +++ b/arch/metag/kernel/devtree.c
> @@ -43,18 +43,16 @@ void * __init early_init_dt_alloc_memory_arch(u64 size, u64 align)
>   */
>  struct machine_desc * __init setup_machine_fdt(void *dt)
>  {
> -	struct boot_param_header *devtree = dt;
>  	struct machine_desc *mdesc, *mdesc_best = NULL;
>  	unsigned int score, mdesc_score = ~1;
>  	unsigned long dt_root;
>  	const char *model;
>  
>  	/* check device tree validity */
> -	if (be32_to_cpu(devtree->magic) != OF_DT_HEADER)
> +	if (!early_init_dt_scan(dt))
>  		return NULL;
>  
>  	/* Search the mdescs for the 'best' compatible value match */
> -	initial_boot_params = devtree;
>  	dt_root = of_get_flat_dt_root();
>  
>  	for_each_machine_desc(mdesc) {
> @@ -90,9 +88,6 @@ struct machine_desc * __init setup_machine_fdt(void *dt)
>  		model = "<unknown>";
>  	pr_info("Machine: %s, model: %s\n", mdesc_best->name, model);
>  
> -	/* Retrieve various information from the /chosen node */
> -	of_scan_flat_dt(early_init_dt_scan_chosen, boot_command_line);
> -
>  	return mdesc_best;
>  
>  }
> 

