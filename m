Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761199Ab3JPQwu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 12:52:50 -0400
Received: from mailout4.w2.samsung.com ([211.189.100.14]:35347 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761088Ab3JPQwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 12:52:46 -0400
X-AuditID: cbfec372-b7fe76d000003347-cc-525ec45c576b
Date: Wed, 16 Oct 2013 13:52:38 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: "Chen, Gong" <gong.chen@linux.intel.com>
Cc: tony.luck@intel.com, bp@alien8.de, joe@perches.com,
        naveen.n.rao@linux.vnet.ibm.com, arozansk@redhat.com,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/9] ACPI, CPER: Update cper info
Message-id: <20131016135238.6a4083ed@samsung.com>
In-reply-to: <1381935366-11731-3-git-send-email-gong.chen@linux.intel.com>
References: <1381935366-11731-1-git-send-email-gong.chen@linux.intel.com>
 <1381935366-11731-3-git-send-email-gong.chen@linux.intel.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.19; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsVy+t/hIN2YI3FBBpMeGFi0nfjNZvF5wz82
	i1vvbC1m33/MYrF8Xz+jxeVdc9gs7rc8Zbd4c+EeiwOHx/fWPhaPxXteMnnMOxno8eDQZhaP
	L6uuMXu833eVzePzJrkA9igum5TUnMyy1CJ9uwSujEW3LrIVvJ/DWPGyYT9jA+Oe+i5GTg4J
	AROJpn8P2CBsMYkL99YD2VwcQgJLGCV23JoN5XQzSUycPhusikVAVWLW4X9MIDabgJHEq8YW
	VhBbREBH4sGm1YwgDcwCqxgl3rzZDpYQFrCQeHjwK5jNK2AoMWX+d6BBHBycAl4SezbmQCzo
	ZJSY1d7HAhKXEHCS2DrVF6JcUOLH5HssIDazgJbE5m1NrBC2vMTmNW+ZJzAKzEJSNgtJ2Swk
	ZQsYmVcxipYWJxcUJ6XnGuoVJ+YWl+al6yXn525ihMRA0Q7GZxusDjEKcDAq8fDOWB4XJMSa
	WFZcmXuIUYKDWUmE99NWoBBvSmJlVWpRfnxRaU5q8SFGJg5OqQZG3zd1X4Tk2VjP9vKctdtg
	O9O89J2/+I+Ub8xiFw5X8VV/2exz9lfqo1C7ZxcevxQx8DlRLsT7k81Q5Zl55+r3jy1sU2Xb
	L9erqT1L2LXGK5fjh8jcK+lzbZW1bXg+LL6hlbGq/qCpGbtZ0sfvV299vM5bI7klKi32RXDO
	98vH9FMdWf+KHnBTYinOSDTUYi4qTgQANp6d1l8CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, 16 Oct 2013 10:55:59 -0400
"Chen, Gong" <gong.chen@linux.intel.com> escreveu:

> To prepare for the following patches and make related
> definition more clear, update some definitions about CPER.
> 
> v2 -> v1: Update some more definitions suggested by Boris
> 
> Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>

Reviewed-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

> ---
>  drivers/acpi/apei/apei-internal.h | 12 ++++----
>  drivers/acpi/apei/cper.c          | 58 +++++++++++++++++++--------------------
>  drivers/acpi/apei/ghes.c          | 54 ++++++++++++++++++------------------
>  include/acpi/actbl1.h             | 14 +++++-----
>  include/acpi/ghes.h               |  2 +-
>  include/linux/cper.h              |  2 +-
>  6 files changed, 71 insertions(+), 71 deletions(-)
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
>  	     (void *)section - (void *)estatus < estatus->data_length;	\
>  	     section = (void *)(section+1) + section->error_data_length)
>  
> -static inline u32 apei_estatus_len(struct acpi_hest_generic_status *estatus)
> +static inline u32 cper_estatus_len(struct acpi_generic_status *estatus)
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
>  
>  int apei_osc_setup(void);
>  #endif
> diff --git a/drivers/acpi/apei/cper.c b/drivers/acpi/apei/cper.c
> index f827f02..eb5f6d6 100644
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
> @@ -73,7 +73,7 @@ static const char *cper_severity_str(unsigned int severity)
>   * printed, with @pfx is printed at the beginning of each line.
>   */
>  void cper_print_bits(const char *pfx, unsigned int bits,
> -		     const char *strs[], unsigned int strs_size)
> +		     const char * const strs[], unsigned int strs_size)
>  {
>  	int i, len = 0;
>  	const char *str;
> @@ -98,32 +98,32 @@ void cper_print_bits(const char *pfx, unsigned int bits,
>  		printk("%s\n", buf);
>  }
>  
> -static const char *cper_proc_type_strs[] = {
> +static const char * const cper_proc_type_strs[] = {
>  	"IA32/X64",
>  	"IA64",
>  };
>  
> -static const char *cper_proc_isa_strs[] = {
> +static const char * const cper_proc_isa_strs[] = {
>  	"IA32",
>  	"IA64",
>  	"X64",
>  };
>  
> -static const char *cper_proc_error_type_strs[] = {
> +static const char * const cper_proc_error_type_strs[] = {
>  	"cache error",
>  	"TLB error",
>  	"bus error",
>  	"micro-architectural error",
>  };
>  
> -static const char *cper_proc_op_strs[] = {
> +static const char * const cper_proc_op_strs[] = {
>  	"unknown or generic",
>  	"data read",
>  	"data write",
>  	"instruction execution",
>  };
>  
> -static const char *cper_proc_flag_strs[] = {
> +static const char * const cper_proc_flag_strs[] = {
>  	"restartable",
>  	"precise IP",
>  	"overflow",
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
> +static const char * const cper_estatus_section_flag_strs[] = {
>  	"primary",
>  	"containment warning",
>  	"reset",
> -	"threshold exceeded",
> +	"error threshold exceeded",
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
>  
> -int apei_estatus_check_header(const struct acpi_hest_generic_status *estatus)
> +int cper_estatus_check_header(const struct acpi_generic_status *estatus)
>  {
>  	if (estatus->data_length &&
> -	    estatus->data_length < sizeof(struct acpi_hest_generic_data))
> +	    estatus->data_length < sizeof(struct acpi_generic_data))
>  		return -EINVAL;
>  	if (estatus->raw_data_length &&
>  	    estatus->raw_data_offset < sizeof(*estatus) + estatus->data_length)
> @@ -374,19 +374,19 @@ int apei_estatus_check_header(const struct acpi_hest_generic_status *estatus)
>  
>  	return 0;
>  }
> -EXPORT_SYMBOL_GPL(apei_estatus_check_header);
> +EXPORT_SYMBOL_GPL(cper_estatus_check_header);
>  
> -int apei_estatus_check(const struct acpi_hest_generic_status *estatus)
> +int cper_estatus_check(const struct acpi_generic_status *estatus)
>  {
> -	struct acpi_hest_generic_data *gdata;
> +	struct acpi_generic_data *gdata;
>  	unsigned int data_len, gedata_len;
>  	int rc;
>  
> -	rc = apei_estatus_check_header(estatus);
> +	rc = cper_estatus_check_header(estatus);
>  	if (rc)
>  		return rc;
>  	data_len = estatus->data_length;
> -	gdata = (struct acpi_hest_generic_data *)(estatus + 1);
> +	gdata = (struct acpi_generic_data *)(estatus + 1);
>  	while (data_len >= sizeof(*gdata)) {
>  		gedata_len = gdata->error_data_length;
>  		if (gedata_len > data_len - sizeof(*gdata))
> @@ -399,4 +399,4 @@ int apei_estatus_check(const struct acpi_hest_generic_status *estatus)
>  
>  	return 0;
>  }
> -EXPORT_SYMBOL_GPL(apei_estatus_check);
> +EXPORT_SYMBOL_GPL(cper_estatus_check);
> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
> index 8ec37bb..0db6e4f 100644
> --- a/drivers/acpi/apei/ghes.c
> +++ b/drivers/acpi/apei/ghes.c
> @@ -75,13 +75,13 @@
>  #define GHES_ESTATUS_CACHE_LEN(estatus_len)			\
>  	(sizeof(struct ghes_estatus_cache) + (estatus_len))
>  #define GHES_ESTATUS_FROM_CACHE(estatus_cache)			\
> -	((struct acpi_hest_generic_status *)			\
> +	((struct acpi_generic_status *)				\
>  	 ((struct ghes_estatus_cache *)(estatus_cache) + 1))
>  
>  #define GHES_ESTATUS_NODE_LEN(estatus_len)			\
>  	(sizeof(struct ghes_estatus_node) + (estatus_len))
> -#define GHES_ESTATUS_FROM_NODE(estatus_node)				\
> -	((struct acpi_hest_generic_status *)				\
> +#define GHES_ESTATUS_FROM_NODE(estatus_node)			\
> +	((struct acpi_generic_status *)				\
>  	 ((struct ghes_estatus_node *)(estatus_node) + 1))
>  
>  bool ghes_disable;
> @@ -378,17 +378,17 @@ static int ghes_read_estatus(struct ghes *ghes, int silent)
>  	ghes->flags |= GHES_TO_CLEAR;
>  
>  	rc = -EIO;
> -	len = apei_estatus_len(ghes->estatus);
> +	len = cper_estatus_len(ghes->estatus);
>  	if (len < sizeof(*ghes->estatus))
>  		goto err_read_block;
>  	if (len > ghes->generic->error_block_length)
>  		goto err_read_block;
> -	if (apei_estatus_check_header(ghes->estatus))
> +	if (cper_estatus_check_header(ghes->estatus))
>  		goto err_read_block;
>  	ghes_copy_tofrom_phys(ghes->estatus + 1,
>  			      buf_paddr + sizeof(*ghes->estatus),
>  			      len - sizeof(*ghes->estatus), 1);
> -	if (apei_estatus_check(ghes->estatus))
> +	if (cper_estatus_check(ghes->estatus))
>  		goto err_read_block;
>  	rc = 0;
>  
> @@ -409,7 +409,7 @@ static void ghes_clear_estatus(struct ghes *ghes)
>  	ghes->flags &= ~GHES_TO_CLEAR;
>  }
>  
> -static void ghes_handle_memory_failure(struct acpi_hest_generic_data *gdata, int sev)
> +static void ghes_handle_memory_failure(struct acpi_generic_data *gdata, int sev)
>  {
>  #ifdef CONFIG_ACPI_APEI_MEMORY_FAILURE
>  	unsigned long pfn;
> @@ -438,10 +438,10 @@ static void ghes_handle_memory_failure(struct acpi_hest_generic_data *gdata, int
>  }
>  
>  static void ghes_do_proc(struct ghes *ghes,
> -			 const struct acpi_hest_generic_status *estatus)
> +			 const struct acpi_generic_status *estatus)
>  {
>  	int sev, sec_sev;
> -	struct acpi_hest_generic_data *gdata;
> +	struct acpi_generic_data *gdata;
>  
>  	sev = ghes_severity(estatus->error_severity);
>  	apei_estatus_for_each_section(estatus, gdata) {
> @@ -496,7 +496,7 @@ static void ghes_do_proc(struct ghes *ghes,
>  
>  static void __ghes_print_estatus(const char *pfx,
>  				 const struct acpi_hest_generic *generic,
> -				 const struct acpi_hest_generic_status *estatus)
> +				 const struct acpi_generic_status *estatus)
>  {
>  	static atomic_t seqno;
>  	unsigned int curr_seqno;
> @@ -513,12 +513,12 @@ static void __ghes_print_estatus(const char *pfx,
>  	snprintf(pfx_seq, sizeof(pfx_seq), "%s{%u}" HW_ERR, pfx, curr_seqno);
>  	printk("%s""Hardware error from APEI Generic Hardware Error Source: %d\n",
>  	       pfx_seq, generic->header.source_id);
> -	apei_estatus_print(pfx_seq, estatus);
> +	cper_estatus_print(pfx_seq, estatus);
>  }
>  
>  static int ghes_print_estatus(const char *pfx,
>  			      const struct acpi_hest_generic *generic,
> -			      const struct acpi_hest_generic_status *estatus)
> +			      const struct acpi_generic_status *estatus)
>  {
>  	/* Not more than 2 messages every 5 seconds */
>  	static DEFINE_RATELIMIT_STATE(ratelimit_corrected, 5*HZ, 2);
> @@ -540,15 +540,15 @@ static int ghes_print_estatus(const char *pfx,
>   * GHES error status reporting throttle, to report more kinds of
>   * errors, instead of just most frequently occurred errors.
>   */
> -static int ghes_estatus_cached(struct acpi_hest_generic_status *estatus)
> +static int ghes_estatus_cached(struct acpi_generic_status *estatus)
>  {
>  	u32 len;
>  	int i, cached = 0;
>  	unsigned long long now;
>  	struct ghes_estatus_cache *cache;
> -	struct acpi_hest_generic_status *cache_estatus;
> +	struct acpi_generic_status *cache_estatus;
>  
> -	len = apei_estatus_len(estatus);
> +	len = cper_estatus_len(estatus);
>  	rcu_read_lock();
>  	for (i = 0; i < GHES_ESTATUS_CACHES_SIZE; i++) {
>  		cache = rcu_dereference(ghes_estatus_caches[i]);
> @@ -571,19 +571,19 @@ static int ghes_estatus_cached(struct acpi_hest_generic_status *estatus)
>  
>  static struct ghes_estatus_cache *ghes_estatus_cache_alloc(
>  	struct acpi_hest_generic *generic,
> -	struct acpi_hest_generic_status *estatus)
> +	struct acpi_generic_status *estatus)
>  {
>  	int alloced;
>  	u32 len, cache_len;
>  	struct ghes_estatus_cache *cache;
> -	struct acpi_hest_generic_status *cache_estatus;
> +	struct acpi_generic_status *cache_estatus;
>  
>  	alloced = atomic_add_return(1, &ghes_estatus_cache_alloced);
>  	if (alloced > GHES_ESTATUS_CACHE_ALLOCED_MAX) {
>  		atomic_dec(&ghes_estatus_cache_alloced);
>  		return NULL;
>  	}
> -	len = apei_estatus_len(estatus);
> +	len = cper_estatus_len(estatus);
>  	cache_len = GHES_ESTATUS_CACHE_LEN(len);
>  	cache = (void *)gen_pool_alloc(ghes_estatus_pool, cache_len);
>  	if (!cache) {
> @@ -603,7 +603,7 @@ static void ghes_estatus_cache_free(struct ghes_estatus_cache *cache)
>  {
>  	u32 len;
>  
> -	len = apei_estatus_len(GHES_ESTATUS_FROM_CACHE(cache));
> +	len = cper_estatus_len(GHES_ESTATUS_FROM_CACHE(cache));
>  	len = GHES_ESTATUS_CACHE_LEN(len);
>  	gen_pool_free(ghes_estatus_pool, (unsigned long)cache, len);
>  	atomic_dec(&ghes_estatus_cache_alloced);
> @@ -619,7 +619,7 @@ static void ghes_estatus_cache_rcu_free(struct rcu_head *head)
>  
>  static void ghes_estatus_cache_add(
>  	struct acpi_hest_generic *generic,
> -	struct acpi_hest_generic_status *estatus)
> +	struct acpi_generic_status *estatus)
>  {
>  	int i, slot = -1, count;
>  	unsigned long long now, duration, period, max_period = 0;
> @@ -751,7 +751,7 @@ static void ghes_proc_in_irq(struct irq_work *irq_work)
>  	struct llist_node *llnode, *next;
>  	struct ghes_estatus_node *estatus_node;
>  	struct acpi_hest_generic *generic;
> -	struct acpi_hest_generic_status *estatus;
> +	struct acpi_generic_status *estatus;
>  	u32 len, node_len;
>  
>  	llnode = llist_del_all(&ghes_estatus_llist);
> @@ -765,7 +765,7 @@ static void ghes_proc_in_irq(struct irq_work *irq_work)
>  		estatus_node = llist_entry(llnode, struct ghes_estatus_node,
>  					   llnode);
>  		estatus = GHES_ESTATUS_FROM_NODE(estatus_node);
> -		len = apei_estatus_len(estatus);
> +		len = cper_estatus_len(estatus);
>  		node_len = GHES_ESTATUS_NODE_LEN(len);
>  		ghes_do_proc(estatus_node->ghes, estatus);
>  		if (!ghes_estatus_cached(estatus)) {
> @@ -784,7 +784,7 @@ static void ghes_print_queued_estatus(void)
>  	struct llist_node *llnode;
>  	struct ghes_estatus_node *estatus_node;
>  	struct acpi_hest_generic *generic;
> -	struct acpi_hest_generic_status *estatus;
> +	struct acpi_generic_status *estatus;
>  	u32 len, node_len;
>  
>  	llnode = llist_del_all(&ghes_estatus_llist);
> @@ -797,7 +797,7 @@ static void ghes_print_queued_estatus(void)
>  		estatus_node = llist_entry(llnode, struct ghes_estatus_node,
>  					   llnode);
>  		estatus = GHES_ESTATUS_FROM_NODE(estatus_node);
> -		len = apei_estatus_len(estatus);
> +		len = cper_estatus_len(estatus);
>  		node_len = GHES_ESTATUS_NODE_LEN(len);
>  		generic = estatus_node->generic;
>  		ghes_print_estatus(NULL, generic, estatus);
> @@ -843,7 +843,7 @@ static int ghes_notify_nmi(unsigned int cmd, struct pt_regs *regs)
>  #ifdef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
>  		u32 len, node_len;
>  		struct ghes_estatus_node *estatus_node;
> -		struct acpi_hest_generic_status *estatus;
> +		struct acpi_generic_status *estatus;
>  #endif
>  		if (!(ghes->flags & GHES_TO_CLEAR))
>  			continue;
> @@ -851,7 +851,7 @@ static int ghes_notify_nmi(unsigned int cmd, struct pt_regs *regs)
>  		if (ghes_estatus_cached(ghes->estatus))
>  			goto next;
>  		/* Save estatus for further processing in IRQ context */
> -		len = apei_estatus_len(ghes->estatus);
> +		len = cper_estatus_len(ghes->estatus);
>  		node_len = GHES_ESTATUS_NODE_LEN(len);
>  		estatus_node = (void *)gen_pool_alloc(ghes_estatus_pool,
>  						      node_len);
> @@ -923,7 +923,7 @@ static int ghes_probe(struct platform_device *ghes_dev)
>  
>  	rc = -EIO;
>  	if (generic->error_block_length <
> -	    sizeof(struct acpi_hest_generic_status)) {
> +	    sizeof(struct acpi_generic_status)) {
>  		pr_warning(FW_BUG GHES_PFX "Invalid error block length: %u for generic hardware error source: %d\n",
>  			   generic->error_block_length,
>  			   generic->header.source_id);
> diff --git a/include/acpi/actbl1.h b/include/acpi/actbl1.h
> index 0bd750e..556c83ee 100644
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
> +#define ACPI_GEN_ERR_UC			BIT(0)
> +#define ACPI_GEN_ERR_CE			BIT(1)
> +#define ACPI_GEN_ERR_MULTI_UC		BIT(2)
> +#define ACPI_GEN_ERR_MULTI_CE		BIT(3)
> +#define ACPI_GEN_ERR_COUNT_SHIFT	(0xFF<<4) /* 8 bits, error count */
>  
>  /* Generic Error Data entry */
>  
> -struct acpi_hest_generic_data {
> +struct acpi_generic_data {
>  	u8 section_type[16];
>  	u32 error_severity;
>  	u16 revision;
> diff --git a/include/acpi/ghes.h b/include/acpi/ghes.h
> index 720446c..dfd60d0 100644
> --- a/include/acpi/ghes.h
> +++ b/include/acpi/ghes.h
> @@ -14,7 +14,7 @@
>  
>  struct ghes {
>  	struct acpi_hest_generic *generic;
> -	struct acpi_hest_generic_status *estatus;
> +	struct acpi_generic_status *estatus;
>  	u64 buffer_paddr;
>  	unsigned long flags;
>  	union {
> diff --git a/include/linux/cper.h b/include/linux/cper.h
> index c230494..09ebe21 100644
> --- a/include/linux/cper.h
> +++ b/include/linux/cper.h
> @@ -389,6 +389,6 @@ struct cper_sec_pcie {
>  
>  u64 cper_next_record_id(void);
>  void cper_print_bits(const char *prefix, unsigned int bits,
> -		     const char *strs[], unsigned int strs_size);
> +		     const char * const strs[], unsigned int strs_size);
>  
>  #endif


-- 

Cheers,
Mauro
