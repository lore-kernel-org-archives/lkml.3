Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516AbaKTGrY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 01:47:24 -0500
Received: from mga02.intel.com ([134.134.136.20]:18815 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750848AbaKTGrW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 01:47:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,422,1413270000"; 
   d="scan'208";a="610931880"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
CC: Lv Zheng <zetalog@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Brown, Len" <len.brown@intel.com>
Subject: RE: [RFC PATCH v4] ACPICA/Events: Add support to ensure GPE is
 disabled by default for handlers.
Thread-Topic: [RFC PATCH v4] ACPICA/Events: Add support to ensure GPE is
 disabled by default for handlers.
Thread-Index: AQHQBI2TEyXhuOlswEmYCNoDLZLxDJxpEhsA
Date: Thu, 20 Nov 2014 06:47:16 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E88026A3E81@SHSMSX101.ccr.corp.intel.com>
References: <20141119121615.GA2514@node.dhcp.inet.fi>
 <ce3ab540463bc5d97e527f24ca7d7d82b2952fae.1416459350.git.lv.zheng@intel.com>
In-Reply-To: <ce3ab540463bc5d97e527f24ca7d7d82b2952fae.1416459350.git.lv.zheng@intel.com>
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

Hi, Kirill

Could also help to confirm if this patch can also fix the issue.
Please help to validate the 2 fix patchsets separately.

Thanks in advance.

Best regards
-Lv

> From: Zheng, Lv
> Sent: Thursday, November 20, 2014 2:45 PM
> 
> On some platforms, GPE is not disabled by default after ACPI hardware is
> enabled. This confuses GPE drivers. This patch adds support to disable GPE
> by default for GPE handler drivers.
> 
> Signed-off-by: Lv Zheng <lv.zheng@intel.com>
> Cc: Kirill A. Shutemov <kirill@shutemov.name>
> ---
>  drivers/acpi/acpica/evxface.c |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> Index: linux-acpica/drivers/acpi/acpica/evxface.c
> ===================================================================
> --- linux-acpica.orig/drivers/acpi/acpica/evxface.c
> +++ linux-acpica/drivers/acpi/acpica/evxface.c
> @@ -821,6 +821,14 @@ acpi_install_gpe_handler(acpi_handle gpe
>  	    ~(ACPI_GPE_XRUPT_TYPE_MASK | ACPI_GPE_DISPATCH_MASK);
>  	gpe_event_info->flags |= (u8)(type | ACPI_GPE_DISPATCH_HANDLER);
> 
> +	/*
> +	 * Make sure that the GPE is disabled by default for the GPE
> +	 * handler driver. It is expected that the GPE handler driver
> +	 * should invoke acpi_enable_gpe() after installing the GPE
> +	 * handler.
> +	 */
> +	(void)acpi_hw_low_set_gpe(gpe_event_info, ACPI_GPE_DISABLE);
> +
>  	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
> 
>  unlock_and_exit:
