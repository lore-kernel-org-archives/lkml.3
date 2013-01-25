Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773Ab3AYUqe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 15:46:34 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:55973 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068Ab3AYUqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 15:46:30 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Rientjes <rientjes@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Kristen C. Accardi" <kristen.c.accardi@intel.com>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] sysfs: Fix build when sysfs is disabled
Date: Fri, 25 Jan 2013 21:52:35 +0100
Message-ID: <2337783.BBmzZI9Lts@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc4; KDE/4.9.5; x86_64; ; )
In-Reply-To: <alpine.DEB.2.00.1301251211410.3815@chino.kir.corp.google.com>
References: <3307415.pdOY6ovZLa@vostro.rjw.lan> <1511541.AH8DLsNQJH@vostro.rjw.lan> <alpine.DEB.2.00.1301251211410.3815@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 25, 2013 12:13:59 PM David Rientjes wrote:
> "sysfs: Functions for adding/removing symlinks to/from attribute groups" 
> causes a build failure when CONFIG_SYSFS is disabled:
> 
> drivers/acpi/power.c: In function 'acpi_power_hide_list':
> drivers/acpi/power.c:463: error: implicit declaration of function 'sysfs_remove_link_from_group'
> drivers/acpi/power.c: In function 'acpi_power_expose_list':
> drivers/acpi/power.c:486: error: implicit declaration of function 'sysfs_add_link_to_group'
> 
> We need to define empty functions for this config to avoid ifdefs in the 
> code.

Can you please send me the .config that triggered those errors?  It will be
useful for future build testing.

Thanks,
Rafael


> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  include/linux/sysfs.h | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
> --- a/include/linux/sysfs.h
> +++ b/include/linux/sysfs.h
> @@ -330,6 +330,18 @@ static inline void sysfs_unmerge_group(struct kobject *kobj,
>  {
>  }
>  
> +static inline int sysfs_add_link_to_group(struct kobject *kobj,
> +		const char *group_name, struct kobject *target,
> +		const char *link_name)
> +{
> +	return 0;
> +}
> +
> +static inline void sysfs_remove_link_from_group(struct kobject *kobj,
> +		const char *group_name, const char *link_name)
> +{
> +}
> +
>  static inline void sysfs_notify(struct kobject *kobj, const char *dir,
>  				const char *attr)
>  {
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
