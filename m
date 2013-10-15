Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933493Ab3JOSRz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 14:17:55 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:34880 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932555Ab3JOSRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 14:17:53 -0400
Date: Tue, 15 Oct 2013 23:47:23 +0530
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
To: "Chen, Gong" <gong.chen@linux.intel.com>
Cc: tony.luck@intel.com, bp@alien8.de, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 2/8] ACPI, CPER: Update cper info
Message-ID: <20131015181723.GC2777@naverao1-tp.ibm.com>
References: <1381473166-29303-1-git-send-email-gong.chen@linux.intel.com>
 <1381473166-29303-3-git-send-email-gong.chen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381473166-29303-3-git-send-email-gong.chen@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101518-7014-0000-0000-000003C403D8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/10/11 02:32AM, Chen Gong wrote:
> To satisfy the necessary of following patches and make related definition
> more clear, update some definitions about CPER. No functional changes.
> 
> Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
> ---
>  drivers/acpi/apei/apei-internal.h | 12 ++++-----
>  drivers/acpi/apei/cper.c          | 46 ++++++++++++++++-----------------
>  drivers/acpi/apei/ghes.c          | 54 +++++++++++++++++++--------------------
>  include/acpi/actbl1.h             | 14 +++++-----
>  include/acpi/ghes.h               |  2 +-
>  5 files changed, 64 insertions(+), 64 deletions(-)
> 
> diff --git a/drivers/acpi/apei/apei-internal.h b/drivers/acpi/apei/apei-internal.h
> index f220d64..21ba34a 100644
> --- a/drivers/acpi/apei/apei-internal.h
> +++ b/drivers/acpi/apei/apei-internal.h
> @@ -122,11 +122,11 @@ struct dentry;
>  struct dentry *apei_get_debugfs_dir(void);
>  
>  #define apei_estatus_for_each_section(estatus, section)			\
> -	for (section = (struct acpi_hest_generic_data *)(estatus + 1);	\
> +	for (section = (struct acpi_generic_data *)(estatus + 1);	\

This is a good one to rename, though I wonder if acpi_generic_error_data
is more appropriate?

>  	     (void *)section - (void *)estatus < estatus->data_length;	\
>  	     section = (void *)(section+1) + section->error_data_length)
>  
> -static inline u32 apei_estatus_len(struct acpi_hest_generic_status *estatus)
> +static inline u32 cper_estatus_len(struct acpi_generic_status *estatus)

Not sure I understand the rationale for these changes - we are still
dealing with ACPI/APEI generic error status/data structures. So, why
the cper_ prefix?

>  {
>  	if (estatus->raw_data_length)
>  		return estatus->raw_data_offset + \
> @@ -135,10 +135,10 @@ static inline u32 apei_estatus_len(struct acpi_hest_generic_status *estatus)
>  		return sizeof(*estatus) + estatus->data_length;
>  }
>  
> -void apei_estatus_print(const char *pfx,
> -			const struct acpi_hest_generic_status *estatus);
> -int apei_estatus_check_header(const struct acpi_hest_generic_status *estatus);
> -int apei_estatus_check(const struct acpi_hest_generic_status *estatus);
> +void cper_estatus_print(const char *pfx,
> +			const struct acpi_generic_status *estatus);
> +int cper_estatus_check_header(const struct acpi_generic_status *estatus);
> +int cper_estatus_check(const struct acpi_generic_status *estatus);

Same here. All the above functions work on ACPI structures...

>  /* Values for block_status flags above */
>  
> -#define ACPI_HEST_UNCORRECTABLE             (1)
> -#define ACPI_HEST_CORRECTABLE               (1<<1)
> -#define ACPI_HEST_MULTIPLE_UNCORRECTABLE    (1<<2)
> -#define ACPI_HEST_MULTIPLE_CORRECTABLE      (1<<3)
> -#define ACPI_HEST_ERROR_ENTRY_COUNT         (0xFF<<4)	/* 8 bits, error count */
> +#define ACPI_GEN_ERR_UC			(1)
> +#define ACPI_GEN_ERR_CE			(1<<1)
> +#define ACPI_GEN_ERR_MULTI_UC		(1<<2)
> +#define ACPI_GEN_ERR_MULTI_CE		(1<<3)
> +#define ACPI_GEN_ERR_COUNT_SHIFT	(0xFF<<4) /* 8 bits, error count */

I'd prefer ACPI_GENERIC_ERR_ since ACPI_GEN_ERR sounds far too much like
ACPI "Generated" :)


Thanks,
Naveen

