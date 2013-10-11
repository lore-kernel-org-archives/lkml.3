Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932076Ab3JKJGl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 05:06:41 -0400
Received: from mail.skyhub.de ([78.46.96.112]:39071 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528Ab3JKJGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 05:06:37 -0400
Date: Fri, 11 Oct 2013 11:06:30 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Chen, Gong" <gong.chen@linux.intel.com>
Cc: tony.luck@intel.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 2/8] ACPI, CPER: Update cper info
Message-ID: <20131011090630.GB5925@pd.tnic>
References: <1381473166-29303-1-git-send-email-gong.chen@linux.intel.com>
 <1381473166-29303-3-git-send-email-gong.chen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1381473166-29303-3-git-send-email-gong.chen@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 02:32:40AM -0400, Chen, Gong wrote:
> To satisfy the necessary of following patches and make related definition

"To prepare for the following patches... " you mean?

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

[ … ]

> diff --git a/drivers/acpi/apei/cper.c b/drivers/acpi/apei/cper.c
> index f827f02..b2e4134 100644
> --- a/drivers/acpi/apei/cper.c
> +++ b/drivers/acpi/apei/cper.c
> @@ -5,7 +5,7 @@
>   *	Author: Huang Ying <ying.huang@intel.com>
>   *
>   * CPER is the format used to describe platform hardware error by
> - * various APEI tables, such as ERST, BERT and HEST etc.
> + * various tables, such as ERST, BERT and HEST etc.
>   *
>   * For more information about CPER, please refer to Appendix N of UEFI
>   * Specification version 2.3.
> @@ -248,7 +248,7 @@ static const char *cper_pcie_port_type_strs[] = {
>  };
>  
>  static void cper_print_pcie(const char *pfx, const struct cper_sec_pcie *pcie,
> -			    const struct acpi_hest_generic_data *gdata)
> +			    const struct acpi_generic_data *gdata)
>  {
>  	if (pcie->validation_bits & CPER_PCIE_VALID_PORT_TYPE)
>  		printk("%s""port_type: %d, %s\n", pfx, pcie->port_type,
> @@ -283,17 +283,17 @@ static void cper_print_pcie(const char *pfx, const struct cper_sec_pcie *pcie,
>  	pfx, pcie->bridge.secondary_status, pcie->bridge.control);
>  }
>  
> -static const char *apei_estatus_section_flag_strs[] = {
> +static const char *cper_estatus_section_flag_strs[] = {

"static const char * const" while at it.

Btw, please run your patches through checkpatch.pl - it does catch
things like that.

>  	"primary",
>  	"containment warning",
>  	"reset",
> -	"threshold exceeded",
> +	"error threshold exceeded",

Right, this string is user-visible so if we have to be absolutely
honest, the patch does add "functional changes" so you can remove the
statement from the commit message. :)

>  	"resource not accessible",
>  	"latent error",
>  };
>  
> -static void apei_estatus_print_section(
> -	const char *pfx, const struct acpi_hest_generic_data *gdata, int sec_no)
> +static void cper_estatus_print_section(
> +	const char *pfx, const struct acpi_generic_data *gdata, int sec_no)
>  {
>  	uuid_le *sec_type = (uuid_le *)gdata->section_type;
>  	__u16 severity;
> @@ -302,8 +302,8 @@ static void apei_estatus_print_section(
>  	printk("%s""section: %d, severity: %d, %s\n", pfx, sec_no, severity,
>  	       cper_severity_str(severity));
>  	printk("%s""flags: 0x%02x\n", pfx, gdata->flags);
> -	cper_print_bits(pfx, gdata->flags, apei_estatus_section_flag_strs,
> -			ARRAY_SIZE(apei_estatus_section_flag_strs));
> +	cper_print_bits(pfx, gdata->flags, cper_estatus_section_flag_strs,
> +			ARRAY_SIZE(cper_estatus_section_flag_strs));
>  	if (gdata->validation_bits & CPER_SEC_VALID_FRU_ID)
>  		printk("%s""fru_id: %pUl\n", pfx, (uuid_le *)gdata->fru_id);
>  	if (gdata->validation_bits & CPER_SEC_VALID_FRU_TEXT)
> @@ -339,34 +339,34 @@ err_section_too_small:
>  	pr_err(FW_WARN "error section length is too small\n");
>  }
>  
> -void apei_estatus_print(const char *pfx,
> -			const struct acpi_hest_generic_status *estatus)
> +void cper_estatus_print(const char *pfx,
> +			const struct acpi_generic_status *estatus)
>  {
> -	struct acpi_hest_generic_data *gdata;
> +	struct acpi_generic_data *gdata;
>  	unsigned int data_len, gedata_len;
>  	int sec_no = 0;
>  	__u16 severity;
>  
> -	printk("%s""APEI generic hardware error status\n", pfx);
> +	printk("%s""Generic Hardware Error Status\n", pfx);

Btw, what's the story with printk not using KERN_x levels in this file?
Why are we falling back to default printk levels for all printks here
and shouldn't we rather prioritize them by urgency into, say, KERN_ERR,
KERN_INFO, etc?

>  	severity = estatus->error_severity;
>  	printk("%s""severity: %d, %s\n", pfx, severity,
>  	       cper_severity_str(severity));
>  	data_len = estatus->data_length;
> -	gdata = (struct acpi_hest_generic_data *)(estatus + 1);
> +	gdata = (struct acpi_generic_data *)(estatus + 1);
>  	while (data_len >= sizeof(*gdata)) {
>  		gedata_len = gdata->error_data_length;
> -		apei_estatus_print_section(pfx, gdata, sec_no);
> +		cper_estatus_print_section(pfx, gdata, sec_no);
>  		data_len -= gedata_len + sizeof(*gdata);
>  		gdata = (void *)(gdata + 1) + gedata_len;
>  		sec_no++;
>  	}
>  }
> -EXPORT_SYMBOL_GPL(apei_estatus_print);
> +EXPORT_SYMBOL_GPL(cper_estatus_print);

[ ... ]

> diff --git a/include/acpi/actbl1.h b/include/acpi/actbl1.h
> index 0bd750e..3c62a0a 100644
> --- a/include/acpi/actbl1.h
> +++ b/include/acpi/actbl1.h
> @@ -596,7 +596,7 @@ struct acpi_hest_generic {
>  
>  /* Generic Error Status block */
>  
> -struct acpi_hest_generic_status {
> +struct acpi_generic_status {
>  	u32 block_status;
>  	u32 raw_data_offset;
>  	u32 raw_data_length;
> @@ -606,15 +606,15 @@ struct acpi_hest_generic_status {
>  
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

Those can simply use BIT().

> +#define ACPI_GEN_ERR_COUNT_SHIFT	(0xFF<<4) /* 8 bits, error count */

Other than the above nits, a patch which slims down struct names and
makes them more concrete is always welcome :)

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
