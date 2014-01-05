Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142AbaAEXUO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 18:20:14 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:50982 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751454AbaAEXUM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 18:20:12 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org, josh@joshtriplett.org
Subject: Re: [PATCH 11/11] drivers: acpi: Include header file in debugfs.c and rectify prototype declaration in internal.h
Date: Mon, 06 Jan 2014 00:33:57 +0100
Message-ID: <1528697.GH1GrQaKgp@vostro.rjw.lan>
User-Agent: KMail/4.11.3 (Linux/3.13.0-rc6+; KDE/4.11.3; x86_64; ; )
In-Reply-To: <37de640470c91e2e54ab68a158e19dde3938f18a.1387271324.git.rashika.kheria@gmail.com>
References: <c676af6619fc5a84208740bfc7edcf56bb78ed4e.1387271324.git.rashika.kheria@gmail.com> <37de640470c91e2e54ab68a158e19dde3938f18a.1387271324.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, December 17, 2013 03:06:54 PM Rashika Kheria wrote:
> Include header file internal.h in debugfs.c and change the return
> value's type in header file internal.h.
> 
> This eliminates the following warning in debugfs.c:
> drivers/acpi/debugfs.c:16:13: warning: no previous prototype for ‘acpi_debugfs_init’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> ---
>  drivers/acpi/debugfs.c  |    3 +++
>  drivers/acpi/internal.h |    2 +-
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/acpi/debugfs.c b/drivers/acpi/debugfs.c
> index b55d6a2..96bcaf7 100644
> --- a/drivers/acpi/debugfs.c
> +++ b/drivers/acpi/debugfs.c
> @@ -6,6 +6,7 @@
>  #include <linux/init.h>
>  #include <linux/debugfs.h>
>  #include <acpi/acpi_drivers.h>
> +#include "internal.h"
>  
>  #define _COMPONENT		ACPI_SYSTEM_COMPONENT
>  ACPI_MODULE_NAME("debugfs");
> @@ -13,7 +14,9 @@ ACPI_MODULE_NAME("debugfs");
>  struct dentry *acpi_debugfs_dir;
>  EXPORT_SYMBOL_GPL(acpi_debugfs_dir);
>  
> +#ifdef  CONFIG_DEBUG_FS
>  void __init acpi_debugfs_init(void)
>  {
>  	acpi_debugfs_dir = debugfs_create_dir("acpi", NULL);
>  }
> +#endif

What about avoiding to build the entire debugfs.c for CONFIG_DEBUG_FS unset?

That surely would make sense? 

> diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
> index 8ef9787..c2e35bd 100644
> --- a/drivers/acpi/internal.h
> +++ b/drivers/acpi/internal.h
> @@ -63,7 +63,7 @@ void acpi_scan_hotplug_enabled(struct acpi_hotplug_profile *hotplug, bool val);
>  
>  #ifdef CONFIG_DEBUG_FS
>  extern struct dentry *acpi_debugfs_dir;
> -int acpi_debugfs_init(void);
> +void acpi_debugfs_init(void);
>  #else
>  static inline void acpi_debugfs_init(void) { return; }
>  #endif
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
