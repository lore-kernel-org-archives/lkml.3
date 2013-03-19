Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912Ab3CSStS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 14:49:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:49879 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753640Ab3CSStR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 14:49:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,873,1355126400"; 
   d="scan'208";a="281824249"
From: "Moore, Robert" <robert.moore@intel.com>
To: Linn Crosetto <linn@hp.com>, "Zheng, Lv" <lv.zheng@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] acpi: remove length check for large registers
Thread-Topic: [PATCH] acpi: remove length check for large registers
Thread-Index: AQHOIbdMN2cdaTqtwUOalnqmcDRsBJitYScw
Date: Tue, 19 Mar 2013 18:48:58 +0000
Message-ID: <94F2FBAB4432B54E8AACC7DFDE6C92E36F48A3FB@ORSMSX101.amr.corp.intel.com>
References: <1363377367-12813-1-git-send-email-linn@hp.com>
In-Reply-To: <1363377367-12813-1-git-send-email-linn@hp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linn,

We will integrate this change into ACPICA for the next release, later in March 2013.
Thanks,
Bob


> -----Original Message-----
> From: Linn Crosetto [mailto:linn@hp.com]
> Sent: Friday, March 15, 2013 12:56 PM
> To: rjw@sisk.pl; Moore, Robert; ming.m.lin@intel.com; Zheng, Lv; linux-
> acpi@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org; Linn Crosetto
> Subject: [PATCH] acpi: remove length check for large registers
> 
> The legacy bit width field in the Generic Address Structure is 1 byte,
> limiting the reportable register width to 255 bits. Larger registers will
> cause a length mismatch warning to be printed in acpi_tb_validate_fadt().
> 
> To avoid the warning, disable the length mismatch check for registers
> larger than 255 bits.
> 
> Signed-off-by: Linn Crosetto <linn@hp.com>
> ---
>  drivers/acpi/acpica/tbfadt.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/acpi/acpica/tbfadt.c b/drivers/acpi/acpica/tbfadt.c
> index 74181bf..e87abcd 100644
> --- a/drivers/acpi/acpica/tbfadt.c
> +++ b/drivers/acpi/acpica/tbfadt.c
> @@ -561,6 +561,7 @@ static void acpi_tb_validate_fadt(void)
>  		 * legacy length field and the corresponding 64-bit X length
> field.
>  		 */
>  		if (address64->address &&
> +		    ACPI_MUL_8(length) <= ACPI_UINT8_MAX &&
>  		    (address64->bit_width != ACPI_MUL_8(length))) {
>  			ACPI_BIOS_WARNING((AE_INFO,
>  					   "32/64X length mismatch in FADT/%s:
> %u/%u",
> --
> 1.7.11.3

