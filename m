Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837AbaD0VWW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 17:22:22 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:62706 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751307AbaD0VWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 17:22:20 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Lv Zheng <lv.zheng@intel.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>, Lv Zheng <zetalog@gmail.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2 5/5] ACPICA: Remove deprecated _LINUX definitions for ACPICA.
Date: Sun, 27 Apr 2014 23:38:46 +0200
Message-ID: <2215223.yYQsuKoaSF@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <8e6c90efc629b463709aef5da4957e916fdc0437.1398232409.git.lv.zheng@intel.com>
References: <cover.1396930406.git.lv.zheng@intel.com> <cover.1398232408.git.lv.zheng@intel.com> <8e6c90efc629b463709aef5da4957e916fdc0437.1398232409.git.lv.zheng@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 23, 2014 02:54:22 PM Lv Zheng wrote:
> There are _LINUX defined so that when Linux kernel is compiled using broken
> compilers that having not __linux__ defined can still include
> <acpi/platform/aclinux.h> from <acpi/platform/acenv.h>.
> 
> This behavior is deprecated as all drivers/acpi/acpica files are compiled
> without including <linux/acpi.h>, thus without _LINUX defined.  As there is
> no issues encountered when we compile ACPICA code without _LINUX defined,
> it is OK to remove _LINUX from <linux/acpi.h> now.
> 
> Signed-off-by: Lv Zheng <lv.zheng@intel.com>
> ---
>  include/linux/acpi.h |    4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/include/linux/acpi.h b/include/linux/acpi.h
> index 7a8f2cd..9c559f7 100644
> --- a/include/linux/acpi.h
> +++ b/include/linux/acpi.h
> @@ -31,10 +31,6 @@
>  
>  #ifdef	CONFIG_ACPI
>  
> -#ifndef _LINUX
> -#define _LINUX
> -#endif
> -
>  #include <linux/list.h>
>  #include <linux/mod_devicetable.h>

What about <acpi/platform/acenv.h>?  Should it still check if _LINUX is defined
after this change?


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
