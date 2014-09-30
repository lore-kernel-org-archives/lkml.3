Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273AbaI3PwX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 11:52:23 -0400
Received: from mga14.intel.com ([192.55.52.115]:32591 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159AbaI3PwV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 11:52:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="393635453"
From: "Moore, Robert" <robert.moore@intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Zhang, Rui" <rui.zhang@intel.com>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: RE: [PATCH 4/5] ACPICA: Introduce acpi_enable_all_wakeup_gpes()
Thread-Topic: [PATCH 4/5] ACPICA: Introduce acpi_enable_all_wakeup_gpes()
Thread-Index: AQHP3ELF3USyxg353ki32PStj86fCJwZ1ELg
Date: Tue, 30 Sep 2014 15:52:16 +0000
Message-ID: <94F2FBAB4432B54E8AACC7DFDE6C92E37D20AA35@ORSMSX112.amr.corp.intel.com>
References: <1622293.rpSt5UtDk3@vostro.rjw.lan>
 <4021848.ZWdxDcq97A@vostro.rjw.lan>
In-Reply-To: <4021848.ZWdxDcq97A@vostro.rjw.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8UFqTvg023264

If you need it, sure.
Let me know when there is an ACPICA version


> -----Original Message-----
> From: Rafael J. Wysocki [mailto:rjw@rjwysocki.net]
> Sent: Monday, September 29, 2014 5:26 PM
> To: ACPI Devel Maling List; Moore, Robert
> Cc: Linux Kernel Mailing List; Zhang, Rui; Linux PM list
> Subject: [PATCH 4/5] ACPICA: Introduce acpi_enable_all_wakeup_gpes()
> 
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Add a routine for host OSes to enable all wakeup GPEs and disable all of
> the non-wakeup ones at the same time.
> 
> It will be used for the handling of GPE wakeup from suspend-to-idle in
> Linux.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
> 
> Bob, please let me know if I can fast-track this one.
> 
> ---
>  drivers/acpi/acpica/evxfgpe.c |   32 ++++++++++++++++++++++++++++++++
>  include/acpi/acpixf.h         |    1 +
>  2 files changed, 33 insertions(+)
> 
> Index: linux-pm/drivers/acpi/acpica/evxfgpe.c
> ===================================================================
> --- linux-pm.orig/drivers/acpi/acpica/evxfgpe.c
> +++ linux-pm/drivers/acpi/acpica/evxfgpe.c
> @@ -596,6 +596,38 @@ acpi_status acpi_enable_all_runtime_gpes
> 
>  ACPI_EXPORT_SYMBOL(acpi_enable_all_runtime_gpes)
> 
> +/**********************************************************************
> +********
> + *
> + * FUNCTION:    acpi_enable_all_wakeup_gpes
> + *
> + * PARAMETERS:  None
> + *
> + * RETURN:      Status
> + *
> + * DESCRIPTION: Enable all "wakeup" GPEs and disable all of the other
> GPEs, in
> + *              all GPE blocks.
> + *
> +
> +***********************************************************************
> +*******/
> +
> +acpi_status acpi_enable_all_wakeup_gpes(void) {
> +	acpi_status status;
> +
> +	ACPI_FUNCTION_TRACE(acpi_enable_all_wakeup_gpes);
> +
> +	status = acpi_ut_acquire_mutex(ACPI_MTX_EVENTS);
> +	if (ACPI_FAILURE(status)) {
> +		return_ACPI_STATUS(status);
> +	}
> +
> +	status = acpi_hw_enable_all_wakeup_gpes();
> +	(void)acpi_ut_release_mutex(ACPI_MTX_EVENTS);
> +
> +	return_ACPI_STATUS(status);
> +}
> +
> +ACPI_EXPORT_SYMBOL(acpi_enable_all_wakeup_gpes)
> +
> 
> /*************************************************************************
> ******
>   *
>   * FUNCTION:    acpi_install_gpe_block
> Index: linux-pm/include/acpi/acpixf.h
> ===================================================================
> --- linux-pm.orig/include/acpi/acpixf.h
> +++ linux-pm/include/acpi/acpixf.h
> @@ -692,6 +692,7 @@ ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_sta
>  						     *event_status))
>  ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status acpi_disable_all_gpes(void))
> ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status
> acpi_enable_all_runtime_gpes(void))
> +ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status
> +acpi_enable_all_wakeup_gpes(void))
> 
>  ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status
>  				acpi_get_gpe_device(u32 gpe_index,

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
