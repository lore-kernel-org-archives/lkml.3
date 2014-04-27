Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042AbaD0VRO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 17:17:14 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:52876 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751307AbaD0VRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 17:17:12 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Lv Zheng <lv.zheng@intel.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>, Lv Zheng <zetalog@gmail.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2 1/5] ACPICA: OSL: Add direct inclusion of extra header.
Date: Sun, 27 Apr 2014 23:33:38 +0200
Message-ID: <3997362.yjEHqV8nv6@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <43884d194fd55ca9124078d3374ec4cf4a8026ef.1398232408.git.lv.zheng@intel.com>
References: <cover.1396930406.git.lv.zheng@intel.com> <cover.1398232408.git.lv.zheng@intel.com> <43884d194fd55ca9124078d3374ec4cf4a8026ef.1398232408.git.lv.zheng@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 23, 2014 02:53:52 PM Lv Zheng wrote:
> This is a linuxized result of an ACPICA commit to upgrade the extra
> header mechanism.
> 
> This patch enhances the extra header solution to allow Linux to use
> ACPI_USE_NATIVE_INTERFACE_HEADER and the file name can be automatically
> replaced during ACPICA release process. Using this way, the rest of the
> ACPICA users needn't know the name of the extra header file. Lv Zheng.
> 
> Signed-off-by: Lv Zheng <lv.zheng@intel.com>
> ---
>  include/acpi/acpi.h |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/acpi/acpi.h b/include/acpi/acpi.h
> index ca0cb60..682398b 100644
> --- a/include/acpi/acpi.h
> +++ b/include/acpi/acpi.h
> @@ -62,8 +62,8 @@
>  #include <acpi/acrestyp.h>		/* Resource Descriptor structs */
>  #include <acpi/acpiosxf.h>		/* OSL interfaces (ACPICA-to-OS) */
>  #include <acpi/acpixf.h>		/* ACPI core subsystem external interfaces */
> -#ifdef ACPI_NATIVE_INTERFACE_HEADER
> -#include ACPI_NATIVE_INTERFACE_HEADER
> +#ifdef ACPI_USE_NATIVE_INTERFACE_HEADER
> +#include <acpi/acpi_opt.h>
>  #endif
>  
>  #endif				/* __ACPI_H__ */

Well, I still think there's a better way.

Introduce <acpi/platform/acenvex.h> into ACPICA and put this into it:

#if defined(_LINUX) || defined(__linux__)
#include <acpi/platform/aclinuxex.h>

#endif

and then move stuff you want in acpi/acpi_opt.h into acpi/platform/aclinuxex.h.

Then, you'll have in acpi.h:

#include <acpi/acrestyp.h>		/* Resource Descriptor structs */
#include <acpi/acpiosxf.h>		/* OSL interfaces (ACPICA-to-OS) */
#include <acpi/acpixf.h>		/* ACPI core subsystem external interfaces */
#include <acpi/platform/acenvex.h>	/* Extra environment-specific items */


That should work I suppose, shouldn't it?


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
