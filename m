Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280AbbAEIru (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 03:47:50 -0500
Received: from mga14.intel.com ([192.55.52.115]:7894 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753123AbbAEIrs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 03:47:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="436520232"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
CC: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "devel@acpica.org" <devel@acpica.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 3/3] ACPICA: Remove use of __DATE__ macro
Thread-Topic: [PATCH 3/3] ACPICA: Remove use of __DATE__ macro
Thread-Index: AQHQFfmq6YwEecfkn02ZwABJi6oKXZyxW9iA
Date: Mon, 5 Jan 2015 08:47:43 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E88026AACD9@SHSMSX101.ccr.corp.intel.com>
References: <1418381488-25123-1-git-send-email-linux@rasmusvillemoes.dk>
 <1418381488-25123-3-git-send-email-linux@rasmusvillemoes.dk>
In-Reply-To: <1418381488-25123-3-git-send-email-linux@rasmusvillemoes.dk>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> From: Rasmus Villemoes [mailto:linux@rasmusvillemoes.dk]
> Sent: Friday, December 12, 2014 6:51 PM
> To: Zheng, Lv
> Cc: Rasmus Villemoes; linux-acpi@vger.kernel.org; devel@acpica.org; linux-kernel@vger.kernel.org
> Subject: [PATCH 3/3] ACPICA: Remove use of __DATE__ macro
> 
> The macro __DATE__ and friends is not allowed in the kernel. Also,
> including the build time in output doesn't seem to provide any value.
> 

Could you confirm that it is not useful even for the user tools?
Please perform the following commands in the kernel source tree
1. stay in tools folder
2. type "make acpi"
3. type "./power/acpi/acpidump -v"

Thanks and best regards
-Lv

> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> ---
>  drivers/acpi/acpica/acapps.h | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/acpi/acpica/acapps.h b/drivers/acpi/acpica/acapps.h
> index 3d2c88289da9..f72826176ebe 100644
> --- a/drivers/acpi/acpica/acapps.h
> +++ b/drivers/acpi/acpica/acapps.h
> @@ -64,15 +64,15 @@
>  /* Macros for signons and file headers */
> 
>  #define ACPI_COMMON_SIGNON(utility_name) \
> -	"\n%s\n%s version %8.8X%s [%s]\n%s\n\n", \
> +	"\n%s\n%s version %8.8X%s\n%s\n\n", \
>  	ACPICA_NAME, \
> -	utility_name, ((u32) ACPI_CA_VERSION), ACPI_WIDTH, __DATE__, \
> +	utility_name, ((u32) ACPI_CA_VERSION), ACPI_WIDTH, \
>  	ACPICA_COPYRIGHT
> 
>  #define ACPI_COMMON_HEADER(utility_name, prefix) \
> -	"%s%s\n%s%s version %8.8X%s [%s]\n%s%s\n%s\n", \
> +	"%s%s\n%s%s version %8.8X%s\n%s%s\n%s\n", \
>  	prefix, ACPICA_NAME, \
> -	prefix, utility_name, ((u32) ACPI_CA_VERSION), ACPI_WIDTH, __DATE__, \
> +	prefix, utility_name, ((u32) ACPI_CA_VERSION), ACPI_WIDTH, \
>  	prefix, ACPICA_COPYRIGHT, \
>  	prefix
> 
> --
> 2.1.3

