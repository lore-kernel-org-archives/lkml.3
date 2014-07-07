Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365AbaGGVHS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 17:07:18 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:59289 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751345AbaGGVHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 17:07:16 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Lv Zheng <lv.zheng@intel.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>, Lv Zheng <zetalog@gmail.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Len Brown <lenb@kernel.org>, sfi-devel@simplefirmware.org
Subject: Re: [PATCH v2 5/7] ACPI/SFI: Fix wrong <acpi/acpi.h> inclusion in SFI/ACPI wrapper - table definitions.
Date: Mon, 07 Jul 2014 23:25:20 +0200
Message-ID: <6888009.veyX2bKRlF@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <aebcb30aa6db54f92fcdf55f94462da15121886d.1404706299.git.lv.zheng@intel.com>
References: <cover.1387336613.git.lv.zheng@intel.com> <cover.1404706298.git.lv.zheng@intel.com> <aebcb30aa6db54f92fcdf55f94462da15121886d.1404706299.git.lv.zheng@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 07, 2014 12:17:28 PM Lv Zheng wrote:
> This patch removes <acpi/acpi.h> inclusions from <linux/sfi_acpi.h> as
> <linux/acpi.h> has already included it for CONFIG_ACPI=n builds.

So are patches [1-4/5] only needed to fix this particular issue?

> Cc: Len Brown <lenb@kernel.org>
> Cc: sfi-devel@simplefirmware.org
> Signed-off-by: Lv Zheng <lv.zheng@intel.com>
> ---
>  include/linux/sfi_acpi.h |    3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/include/linux/sfi_acpi.h b/include/linux/sfi_acpi.h
> index 4723bbf..a6e555c 100644
> --- a/include/linux/sfi_acpi.h
> +++ b/include/linux/sfi_acpi.h
> @@ -63,8 +63,6 @@
>  #include <linux/sfi.h>
>  
>  #ifdef CONFIG_SFI
> -#include <acpi/acpi.h>	/* FIXME: inclusion should be removed */
> -
>  extern int sfi_acpi_table_parse(char *signature, char *oem_id,
>  				char *oem_table_id,
>  				int (*handler)(struct acpi_table_header *));
> @@ -78,7 +76,6 @@ static inline int __init acpi_sfi_table_parse(char *signature,
>  	return sfi_acpi_table_parse(signature, NULL, NULL, handler);
>  }
>  #else /* !CONFIG_SFI */
> -
>  static inline int sfi_acpi_table_parse(char *signature, char *oem_id,
>  				char *oem_table_id,
>  				int (*handler)(struct acpi_table_header *))
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
