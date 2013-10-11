Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758384Ab3JKQCR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 12:02:17 -0400
Received: from mail.skyhub.de ([78.46.96.112]:47998 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753396Ab3JKQCP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 12:02:15 -0400
Date: Fri, 11 Oct 2013 18:02:08 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Chen, Gong" <gong.chen@linux.intel.com>
Cc: tony.luck@intel.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 7/8] ACPI, APEI, CPER: Cleanup CPER memory error output
 format
Message-ID: <20131011160208.GL5925@pd.tnic>
References: <1381473166-29303-1-git-send-email-gong.chen@linux.intel.com>
 <1381473166-29303-8-git-send-email-gong.chen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1381473166-29303-8-git-send-email-gong.chen@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 02:32:45AM -0400, Chen, Gong wrote:
> Keep up only the most important fields for memory error
> reporting. The detail information will be moved to perf/trace
> interface.
> 
> Suggested-by: Tony Luck <tony.luck@intel.com>
> Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
> ---
>  drivers/acpi/apei/cper.c | 42 ++++++++++++++----------------------------
>  1 file changed, 14 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/acpi/apei/cper.c b/drivers/acpi/apei/cper.c
> index 2a4389f..567410e 100644
> --- a/drivers/acpi/apei/cper.c
> +++ b/drivers/acpi/apei/cper.c
> @@ -206,29 +206,29 @@ static void cper_print_mem(const char *pfx, const struct cper_sec_mem_err *mem)
>  		printk("%s""physical_address_mask: 0x%016llx\n",
>  		       pfx, mem->physical_addr_mask);
>  	if (mem->validation_bits & CPER_MEM_VALID_NODE)
> -		printk("%s""node: %d\n", pfx, mem->node);
> +		pr_debug("node: %d\n", mem->node);
>  	if (mem->validation_bits & CPER_MEM_VALID_CARD)
> -		printk("%s""card: %d\n", pfx, mem->card);
> +		pr_debug("card: %d\n", mem->card);
>  	if (mem->validation_bits & CPER_MEM_VALID_MODULE)
> -		printk("%s""module: %d\n", pfx, mem->module);
> +		pr_debug("module: %d\n", mem->module);
>  	if (mem->validation_bits & CPER_MEM_VALID_RANK_NUMBER)
> -		printk("%s""rank: %d\n", pfx, mem->rank);
> +		pr_debug("rank: %d\n", mem->rank);
>  	if (mem->validation_bits & CPER_MEM_VALID_BANK)
> -		printk("%s""bank: %d\n", pfx, mem->bank);
> +		pr_debug("bank: %d\n", mem->bank);
>  	if (mem->validation_bits & CPER_MEM_VALID_DEVICE)
> -		printk("%s""device: %d\n", pfx, mem->device);
> +		pr_debug("device: %d\n", mem->device);
>  	if (mem->validation_bits & CPER_MEM_VALID_ROW)
> -		printk("%s""row: %d\n", pfx, mem->row);
> +		pr_debug("row: %d\n", mem->row);
>  	if (mem->validation_bits & CPER_MEM_VALID_COLUMN)
> -		printk("%s""column: %d\n", pfx, mem->column);
> +		pr_debug("column: %d\n", mem->column);
>  	if (mem->validation_bits & CPER_MEM_VALID_BIT_POSITION)
> -		printk("%s""bit_position: %d\n", pfx, mem->bit_pos);
> +		pr_debug("bit_position: %d\n", mem->bit_pos);
>  	if (mem->validation_bits & CPER_MEM_VALID_REQUESTOR_ID)
> -		printk("%s""requestor_id: 0x%016llx\n", pfx, mem->requestor_id);
> +		pr_debug("requestor_id: 0x%016llx\n", mem->requestor_id);
>  	if (mem->validation_bits & CPER_MEM_VALID_RESPONDER_ID)
> -		printk("%s""responder_id: 0x%016llx\n", pfx, mem->responder_id);
> +		pr_debug("responder_id: 0x%016llx\n", mem->responder_id);
>  	if (mem->validation_bits & CPER_MEM_VALID_TARGET_ID)
> -		printk("%s""target_id: 0x%016llx\n", pfx, mem->target_id);
> +		pr_debug("target_id: 0x%016llx\n", mem->target_id);
>  	if (mem->validation_bits & CPER_MEM_VALID_ERROR_TYPE) {
>  		u8 etype = mem->error_type;
>  		printk("%s""error_type: %d, %s\n", pfx, etype,

Hmm, so this cper_print_mem is called for CPER_SEC_PLATFORM_MEM section
type.

With the change above, the other caller __ghes_print_estatus() won't see
the error messages if they're debug. Do we want that?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
