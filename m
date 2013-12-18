Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751413Ab3LRGbg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 01:31:36 -0500
Received: from mga03.intel.com ([143.182.124.21]:33484 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014Ab3LRGbe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 01:31:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,505,1384329600"; 
   d="scan'208";a="446129347"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: Rashika Kheria <rashika.kheria@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Moore, Robert" <robert.moore@intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        Len Brown <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "devel@acpica.org" <devel@acpica.org>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>
Subject: RE: [PATCH 06/11] drivers: acpi: Add appropriate ifdef conditions
 in exdump.c
Thread-Topic: [PATCH 06/11] drivers: acpi: Add appropriate ifdef conditions
 in exdump.c
Thread-Index: AQHO+wnNeAIysFFG7k+M//I9PliVaZpZfh1g
Date: Wed, 18 Dec 2013 06:31:22 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E8802498846@SHSMSX101.ccr.corp.intel.com>
References: <c676af6619fc5a84208740bfc7edcf56bb78ed4e.1387271324.git.rashika.kheria@gmail.com>
 <150a5858e78dc6eabfa11b5d52ce97998b807225.1387271324.git.rashika.kheria@gmail.com>
In-Reply-To: <150a5858e78dc6eabfa11b5d52ce97998b807225.1387271324.git.rashika.kheria@gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rBI6VgrY007882

Hi,

I think this patch is useless.
It is possible to include dump code into Linux kernel for debugging purposes.
Thus we should do cleanup in different way for them.

Thanks
-Lv

> From: Rashika Kheria [mailto:rashika.kheria@gmail.com]
> Sent: Tuesday, December 17, 2013 5:24 PM
> 
> Enclose functions acpi_ex_dump_namespace_node() and
> acpi_ex_dump_object_descriptor() in appropriate ifdef condition of
> ACPI_FUTURE_USAGE in file acpica/exdump.c.
> 
> This eliminates the following warnings in exdump.c:
> drivers/acpi/acpica/exdump.c:809:6: warning: no previous prototype for â€˜acpi_ex_dump_namespace_nodeâ€™ [-Wmissing-prototypes]
> drivers/acpi/acpica/exdump.c:995:1: warning: no previous prototype for â€˜acpi_ex_dump_object_descriptorâ€™ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> ---
>  drivers/acpi/acpica/exdump.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/acpi/acpica/exdump.c b/drivers/acpi/acpica/exdump.c
> index 4d046fa..3cd2817 100644
> --- a/drivers/acpi/acpica/exdump.c
> +++ b/drivers/acpi/acpica/exdump.c
> @@ -54,6 +54,7 @@ ACPI_MODULE_NAME("exdump")
>   * The following routines are used for debug output only
>   */
>  #if defined(ACPI_DEBUG_OUTPUT) || defined(ACPI_DEBUGGER)
> +#ifdef  ACPI_FUTURE_USAGE
>  /* Local prototypes */
>  static void acpi_ex_out_string(char *title, char *value);
> 
> @@ -68,6 +69,7 @@ static void acpi_ex_dump_reference_obj(union acpi_operand_object *obj_desc);
>  static void
>  acpi_ex_dump_package_obj(union acpi_operand_object *obj_desc,
>  			 u32 level, u32 index);
> +#endif
> 
>  /*******************************************************************************
>   *
> @@ -210,6 +212,7 @@ static struct acpi_exdump_info acpi_ex_dump_bank_field[5] = {
>  	{ACPI_EXD_POINTER, ACPI_EXD_OFFSET(bank_field.bank_obj), "Bank Object"}
>  };
> 
> +#ifdef  ACPI_FUTURE_USAGE
>  static struct acpi_exdump_info acpi_ex_dump_index_field[5] = {
>  	{ACPI_EXD_INIT, ACPI_EXD_TABLE_SIZE(acpi_ex_dump_bank_field), NULL},
>  	{ACPI_EXD_FIELD, 0, NULL},
> @@ -218,6 +221,7 @@ static struct acpi_exdump_info acpi_ex_dump_index_field[5] = {
>  	 "Index Object"},
>  	{ACPI_EXD_POINTER, ACPI_EXD_OFFSET(index_field.data_obj), "Data Object"}
>  };
> +#endif
> 
>  static struct acpi_exdump_info acpi_ex_dump_reference[8] = {
>  	{ACPI_EXD_INIT, ACPI_EXD_TABLE_SIZE(acpi_ex_dump_reference), NULL},
> @@ -287,6 +291,7 @@ static struct acpi_exdump_info acpi_ex_dump_node[5] = {
> 
>  /* Dispatch table, indexed by object type */
> 
> +#ifdef  ACPI_FUTURE_USAGE
>  static struct acpi_exdump_info *acpi_ex_dump_info[] = {
>  	NULL,
>  	acpi_ex_dump_integer,
> @@ -444,6 +449,7 @@ acpi_ex_dump_object(union acpi_operand_object *obj_desc,
>  		count--;
>  	}
>  }
> +#endif
> 
>  /*******************************************************************************
>   *
> @@ -785,6 +791,7 @@ acpi_ex_dump_operands(union acpi_operand_object **operands,
>   *
>   ******************************************************************************/
> 
> +#ifdef  ACPI_FUTURE_USAGE
>  static void acpi_ex_out_string(char *title, char *value)
>  {
>  	acpi_os_printf("%20s : %s\n", title, value);
> @@ -1042,5 +1049,6 @@ acpi_ex_dump_object_descriptor(union acpi_operand_object *obj_desc, u32 flags)
>  	acpi_ex_dump_object(obj_desc, acpi_ex_dump_info[obj_desc->common.type]);
>  	return_VOID;
>  }
> +#endif
> 
>  #endif
> --
> 1.7.9.5

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
