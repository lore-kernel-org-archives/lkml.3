Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145Ab3JQKOy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 06:14:54 -0400
Received: from mailout4.w2.samsung.com ([211.189.100.14]:59086 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899Ab3JQKOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 06:14:52 -0400
X-AuditID: cbfec372-b7fe76d000003347-bf-525fb89bf0bc
Date: Thu, 17 Oct 2013 07:14:45 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: "Chen, Gong" <gong.chen@linux.intel.com>
Cc: tony.luck@intel.com, bp@alien8.de, joe@perches.com,
        naveen.n.rao@linux.vnet.ibm.com, arozansk@redhat.com,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/9] DMI: Parse memory device (type 17) in SMBIOS
Message-id: <20131017071445.1716ed3b@samsung.com>
In-reply-to: <1381935366-11731-6-git-send-email-gong.chen@linux.intel.com>
References: <1381935366-11731-1-git-send-email-gong.chen@linux.intel.com>
 <1381935366-11731-6-git-send-email-gong.chen@linux.intel.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.19; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsVy+t/hYN3ZO+KDDI50slq0nfjNZvF5wz82
	i1vvbC1m33/MYrF8Xz+jxeVdc9gs7rc8Zbd4c+EeiwOHx/fWPhaPxXteMnnMOxno8eDQZhaP
	L6uuMXu833eVzePzJrkA9igum5TUnMyy1CJ9uwSujMXvH7IWTNGt+DL3D2MD426VLkZODgkB
	E4krh/4xQdhiEhfurWfrYuTiEBJYwiix5+EKdginh0ni/ZP5rCBVLAKqEhtX/2AEsdkEjCRe
	NbaAxUUEdCQebFrNCNLALLCKUeLNm+1gCWEBD4nfZy6ygdi8AoYSTy6+AYtzCnhJnNi+gxFi
	QyejxP2v/4EcDqA7nCS2TvWFqBeU+DH5HguIzSygJbF5WxMrhC0vsXnNW+YJjAKzkJTNQlI2
	C0nZAkbmVYyipcXJBcVJ6bmGesWJucWleel6yfm5mxghMVC0g/HZBqtDjAIcjEo8vDOWxwUJ
	sSaWFVfmHmKU4GBWEuHduT4+SIg3JbGyKrUoP76oNCe1+BAjEwenVANjSiRf4dPPCVc9xY+E
	WPo8c1TK1XxxZd29oEdThX4cfi2w/I1w56rt9Xs6fkRdePWolI8hYE4PU+GprsM8YTJrHn01
	+danb87NNl3IQnvH1CnbS/umnpacl6kueMdg08Lr5f0Xg0Xm+P0/JRJwYHmgdUzuJR3TfpY7
	kdYlKUEitQ+KteZc+mipxFKckWioxVxUnAgArRhSmV8CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, 16 Oct 2013 10:56:02 -0400
"Chen, Gong" <gong.chen@linux.intel.com> escreveu:

> This patch adds a new interface to decode memory device (type 17)
> to help error reporting on DIMMs.
> 
> Original-author: Tony Luck <tony.luck@intel.com>
> Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
> Acked-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>

Reviewed-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

> ---
>  arch/ia64/kernel/setup.c    |  1 +
>  arch/x86/kernel/setup.c     |  1 +
>  drivers/firmware/dmi_scan.c | 60 +++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/dmi.h         |  5 ++++
>  4 files changed, 67 insertions(+)
> 
> diff --git a/arch/ia64/kernel/setup.c b/arch/ia64/kernel/setup.c
> index 4fc2e95..d86669b 100644
> --- a/arch/ia64/kernel/setup.c
> +++ b/arch/ia64/kernel/setup.c
> @@ -1063,6 +1063,7 @@ check_bugs (void)
>  static int __init run_dmi_scan(void)
>  {
>  	dmi_scan_machine();
> +	dmi_memdev_walk();
>  	dmi_set_dump_stack_arch_desc();
>  	return 0;
>  }
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index f0de629..918d489 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -993,6 +993,7 @@ void __init setup_arch(char **cmdline_p)
>  		efi_init();
>  
>  	dmi_scan_machine();
> +	dmi_memdev_walk();
>  	dmi_set_dump_stack_arch_desc();
>  
>  	/*
> diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
> index fa0affb..59579a7 100644
> --- a/drivers/firmware/dmi_scan.c
> +++ b/drivers/firmware/dmi_scan.c
> @@ -25,6 +25,13 @@ static int dmi_initialized;
>  /* DMI system identification string used during boot */
>  static char dmi_ids_string[128] __initdata;
>  
> +static struct dmi_memdev_info {
> +	const char *device;
> +	const char *bank;
> +	u16 handle;
> +} *dmi_memdev;
> +static int dmi_memdev_nr;
> +
>  static const char * __init dmi_string_nosave(const struct dmi_header *dm, u8 s)
>  {
>  	const u8 *bp = ((u8 *) dm) + dm->length;
> @@ -322,6 +329,42 @@ static void __init dmi_save_extended_devices(const struct dmi_header *dm)
>  	dmi_save_one_device(*d & 0x7f, dmi_string_nosave(dm, *(d - 1)));
>  }
>  
> +static void __init count_mem_devices(const struct dmi_header *dm, void *v)
> +{
> +	if (dm->type != DMI_ENTRY_MEM_DEVICE)
> +		return;
> +	dmi_memdev_nr++;
> +}
> +
> +static void __init save_mem_devices(const struct dmi_header *dm, void *v)
> +{
> +	const char *d = (const char *)dm;
> +	static int nr;
> +
> +	if (dm->type != DMI_ENTRY_MEM_DEVICE)
> +		return;
> +	if (nr >= dmi_memdev_nr) {
> +		pr_warn(FW_BUG "Too many DIMM entries in SMBIOS table\n");
> +		return;
> +	}
> +	dmi_memdev[nr].handle = dm->handle;
> +	dmi_memdev[nr].device = dmi_string(dm, d[0x10]);
> +	dmi_memdev[nr].bank = dmi_string(dm, d[0x11]);
> +	nr++;
> +}
> +
> +void __init dmi_memdev_walk(void)
> +{
> +	if (!dmi_available)
> +		return;
> +
> +	if (dmi_walk_early(count_mem_devices) == 0 && dmi_memdev_nr) {
> +		dmi_memdev = dmi_alloc(sizeof(*dmi_memdev) * dmi_memdev_nr);
> +		if (dmi_memdev)
> +			dmi_walk_early(save_mem_devices);
> +	}
> +}
> +
>  /*
>   *	Process a DMI table entry. Right now all we care about are the BIOS
>   *	and machine entries. For 2.5 we should pull the smbus controller info
> @@ -815,3 +858,20 @@ bool dmi_match(enum dmi_field f, const char *str)
>  	return !strcmp(info, str);
>  }
>  EXPORT_SYMBOL_GPL(dmi_match);
> +
> +void dmi_memdev_name(u16 handle, const char **bank, const char **device)
> +{
> +	int n;
> +
> +	if (dmi_memdev == NULL)
> +		return;
> +
> +	for (n = 0; n < dmi_memdev_nr; n++) {
> +		if (handle == dmi_memdev[n].handle) {
> +			*bank = dmi_memdev[n].bank;
> +			*device = dmi_memdev[n].device;
> +			break;
> +		}
> +	}
> +}
> +EXPORT_SYMBOL_GPL(dmi_memdev_name);
> diff --git a/include/linux/dmi.h b/include/linux/dmi.h
> index b6eb7a0..f820f0a 100644
> --- a/include/linux/dmi.h
> +++ b/include/linux/dmi.h
> @@ -99,6 +99,7 @@ extern const char * dmi_get_system_info(int field);
>  extern const struct dmi_device * dmi_find_device(int type, const char *name,
>  	const struct dmi_device *from);
>  extern void dmi_scan_machine(void);
> +extern void dmi_memdev_walk(void);
>  extern void dmi_set_dump_stack_arch_desc(void);
>  extern bool dmi_get_date(int field, int *yearp, int *monthp, int *dayp);
>  extern int dmi_name_in_vendors(const char *str);
> @@ -107,6 +108,7 @@ extern int dmi_available;
>  extern int dmi_walk(void (*decode)(const struct dmi_header *, void *),
>  	void *private_data);
>  extern bool dmi_match(enum dmi_field f, const char *str);
> +extern void dmi_memdev_name(u16 handle, const char **bank, const char **device);
>  
>  #else
>  
> @@ -115,6 +117,7 @@ static inline const char * dmi_get_system_info(int field) { return NULL; }
>  static inline const struct dmi_device * dmi_find_device(int type, const char *name,
>  	const struct dmi_device *from) { return NULL; }
>  static inline void dmi_scan_machine(void) { return; }
> +static inline void dmi_memdev_walk(void) { }
>  static inline void dmi_set_dump_stack_arch_desc(void) { }
>  static inline bool dmi_get_date(int field, int *yearp, int *monthp, int *dayp)
>  {
> @@ -133,6 +136,8 @@ static inline int dmi_walk(void (*decode)(const struct dmi_header *, void *),
>  	void *private_data) { return -1; }
>  static inline bool dmi_match(enum dmi_field f, const char *str)
>  	{ return false; }
> +static inline void dmi_memdev_name(u16 handle, const char **bank,
> +		const char **device) { }
>  static inline const struct dmi_system_id *
>  	dmi_first_match(const struct dmi_system_id *list) { return NULL; }
>  


-- 

Cheers,
Mauro
