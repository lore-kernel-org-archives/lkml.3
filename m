Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075Ab3JRMjq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 08:39:46 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:45792 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537Ab3JRMjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 08:39:44 -0400
Message-ID: <52612BF1.30001@linux.vnet.ibm.com>
Date: Fri, 18 Oct 2013 18:09:13 +0530
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: "Chen, Gong" <gong.chen@linux.intel.com>, tony.luck@intel.com,
        bp@alien8.de, joe@perches.com, m.chehab@samsung.com
CC: arozansk@redhat.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/9] ACPI, CPER: Update cper info
References: <1382084624-10857-1-git-send-email-gong.chen@linux.intel.com> <1382084624-10857-3-git-send-email-gong.chen@linux.intel.com>
In-Reply-To: <1382084624-10857-3-git-send-email-gong.chen@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101812-5490-0000-0000-00000457E6B2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2013 01:53 PM, Chen, Gong wrote:
> To prepare for the following patches and make related
> definition more clear, update some definitions about CPER.
>
> v2 -> v1: Update some more definitions suggested by Boris
>
> Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
> Acked-by: Borislav Petkov <bp@suse.de>
> Reviewed-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> ---
>   drivers/acpi/apei/apei-internal.h | 12 ++++----
>   drivers/acpi/apei/cper.c          | 58 +++++++++++++++++++--------------------
>   drivers/acpi/apei/ghes.c          | 54 ++++++++++++++++++------------------
>   include/acpi/actbl1.h             | 14 +++++-----
>   include/acpi/ghes.h               |  2 +-
>   include/linux/cper.h              |  2 +-
>   6 files changed, 71 insertions(+), 71 deletions(-)
>
> diff --git a/drivers/acpi/apei/apei-internal.h b/drivers/acpi/apei/apei-internal.h
> index f220d64..21ba34a 100644
> --- a/drivers/acpi/apei/apei-internal.h
> +++ b/drivers/acpi/apei/apei-internal.h
> @@ -122,11 +122,11 @@ struct dentry;
>   struct dentry *apei_get_debugfs_dir(void);
>
>   #define apei_estatus_for_each_section(estatus, section)			\
> -	for (section = (struct acpi_hest_generic_data *)(estatus + 1);	\
> +	for (section = (struct acpi_generic_data *)(estatus + 1);	\
>   	     (void *)section - (void *)estatus < estatus->data_length;	\
>   	     section = (void *)(section+1) + section->error_data_length)
>
> -static inline u32 apei_estatus_len(struct acpi_hest_generic_status *estatus)
> +static inline u32 cper_estatus_len(struct acpi_generic_status *estatus)
>   {
>   	if (estatus->raw_data_length)
>   		return estatus->raw_data_offset + \
> @@ -135,10 +135,10 @@ static inline u32 apei_estatus_len(struct acpi_hest_generic_status *estatus)
>   		return sizeof(*estatus) + estatus->data_length;
>   }
>
> -void apei_estatus_print(const char *pfx,
> -			const struct acpi_hest_generic_status *estatus);
> -int apei_estatus_check_header(const struct acpi_hest_generic_status *estatus);
> -int apei_estatus_check(const struct acpi_hest_generic_status *estatus);
> +void cper_estatus_print(const char *pfx,
> +			const struct acpi_generic_status *estatus);
> +int cper_estatus_check_header(const struct acpi_generic_status *estatus);
> +int cper_estatus_check(const struct acpi_generic_status *estatus);

As stated previously, I am not convinced this makes sense since these 
functions act on ACPI stuctures.

- Naveen

