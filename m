Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751483AbaESWSB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 18:18:01 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:64759 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751253AbaESWR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 18:17:59 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Lv Zheng <lv.zheng@intel.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>, Lv Zheng <zetalog@gmail.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Enrico Etxe Arte <goitizena.generoa@gmail.com>
Subject: Re: [PATCH v3 2/2] ACPI: Fix the issue that the DSDT local copy is conflict with the customized DSDT.
Date: Tue, 20 May 2014 00:34:54 +0200
Message-ID: <7468570.jHKW67l4I5@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <e10c2a17e698dd9a2594320388b8aa4da6c28418.1399880919.git.lv.zheng@intel.com>
References: <cover.1396925060.git.lv.zheng@intel.com> <e10c2a17e698dd9a2594320388b8aa4da6c28418.1399880919.git.lv.zheng@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 12, 2014 03:50:16 PM Lv Zheng wrote:
> This patch fixes the following issue:
> If DSDT is customized, no local DSDT copy is needed.
> 
> Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=69711
> Signed-off-by: Lv Zheng <lv.zheng@intel.com>
> Signed-off-by: Enrico Etxe Arte <goitizena.generoa@gmail.com>
> Cc: <stable@vger.kernel.org> # 2.6.35.x: aa2110cb: ACPI: add boot option acpi=copy_dsdt to fix corrupt DSDT

Queued up for 3.16, thanks!

> ---
>  drivers/acpi/bus.c |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
> index 610261a..cfd2318 100644
> --- a/drivers/acpi/bus.c
> +++ b/drivers/acpi/bus.c
> @@ -52,6 +52,12 @@ struct proc_dir_entry *acpi_root_dir;
>  EXPORT_SYMBOL(acpi_root_dir);
>  
>  #ifdef CONFIG_X86
> +#ifdef CONFIG_ACPI_CUSTOM_DSDT
> +static inline int set_copy_dsdt(const struct dmi_system_id *id)
> +{
> +	return 0;
> +}
> +#else
>  static int set_copy_dsdt(const struct dmi_system_id *id)
>  {
>  	printk(KERN_NOTICE "%s detected - "
> @@ -59,6 +65,7 @@ static int set_copy_dsdt(const struct dmi_system_id *id)
>  	acpi_gbl_copy_dsdt_locally = 1;
>  	return 0;
>  }
> +#endif
>  
>  static struct dmi_system_id dsdt_dmi_table[] __initdata = {
>  	/*
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
