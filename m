Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756901Ab3HFXDs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 19:03:48 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:35923 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756800Ab3HFXDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 19:03:46 -0400
Message-ID: <1375830154.10300.200.camel@misato.fc.hp.com>
Subject: Re: [PATCH v2 RESEND 04/18] acpi: Introduce acpi_verify_initrd() to
 check if a table is invalid.
From: Toshi Kani <toshi.kani@hp.com>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: robert.moore@intel.com, lv.zheng@intel.com, rjw@sisk.pl, lenb@kernel.org,
        tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        akpm@linux-foundation.org, tj@kernel.org, trenn@suse.de,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        izumi.taku@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org,
        mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com,
        zhangyanfei@cn.fujitsu.com, yanghy@cn.fujitsu.com, x86@kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-acpi@vger.kernel.org
Date: Tue, 06 Aug 2013 17:02:34 -0600
In-Reply-To: <1375434877-20704-5-git-send-email-tangchen@cn.fujitsu.com>
References: <1375434877-20704-1-git-send-email-tangchen@cn.fujitsu.com>
	 <1375434877-20704-5-git-send-email-tangchen@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-08-02 at 17:14 +0800, Tang Chen wrote:
> In acpi_initrd_override(), it checks several things to ensure the
> table it found is valid. In later patches, we need to do these check
> somewhere else. So this patch introduces a common function
> acpi_verify_initrd() to do all these checks, and reuse it in different

Typo: acpi_verify_initrd() -> acpi_verify_table()

-Toshi


> places. The function will be used in the subsequent patches.
> 
> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
> Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
> Acked-by: Toshi Kani <toshi.kani@hp.com>
> Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>  drivers/acpi/osl.c |   86 +++++++++++++++++++++++++++++++++++++---------------
>  1 files changed, 61 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
> index 3b8bab2..0043e9f 100644
> --- a/drivers/acpi/osl.c
> +++ b/drivers/acpi/osl.c
> @@ -572,9 +572,68 @@ static const char * const table_sigs[] = {
>  /* Must not increase 10 or needs code modification below */
>  #define ACPI_OVERRIDE_TABLES 10
>  
> +/*******************************************************************************
> + *
> + * FUNCTION:    acpi_verify_table
> + *
> + * PARAMETERS:  File               - The initrd file
> + *              Path               - Path to acpi overriding tables in cpio file
> + *              Signature          - Signature of the table
> + *
> + * RETURN:      0 if it passes all the checks, -EINVAL if any check fails.
> + *
> + * DESCRIPTION: Check if an acpi table found in initrd is invalid.
> + *              @signature can be NULL. If it is NULL, the function will check
> + *              if the table signature matches any signature in table_sigs[].
> + *
> + ******************************************************************************/
> +int __init acpi_verify_table(struct cpio_data *file,
 :


