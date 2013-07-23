Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934146Ab3GWTpu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 15:45:50 -0400
Received: from mail-qe0-f43.google.com ([209.85.128.43]:34458 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933618Ab3GWTps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 15:45:48 -0400
Date: Tue, 23 Jul 2013 15:45:40 -0400
From: Tejun Heo <tj@kernel.org>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        akpm@linux-foundation.org, trenn@suse.de, yinghai@kernel.org,
        jiang.liu@huawei.com, wency@cn.fujitsu.com, laijs@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, izumi.taku@jp.fujitsu.com,
        mgorman@suse.de, minchan@kernel.org, mina86@mina86.com,
        gong.chen@linux.intel.com, vasilis.liaskovitis@profitbricks.com,
        lwoodman@redhat.com, riel@redhat.com, jweiner@redhat.com,
        prarit@redhat.com, zhangyanfei@cn.fujitsu.com, yanghy@cn.fujitsu.com,
        x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 08/21] x86, acpi: Also initialize signature and length
 when parsing root table.
Message-ID: <20130723194540.GM21100@mtj.dyndns.org>
References: <1374220774-29974-1-git-send-email-tangchen@cn.fujitsu.com>
 <1374220774-29974-9-git-send-email-tangchen@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374220774-29974-9-git-send-email-tangchen@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 03:59:21PM +0800, Tang Chen wrote:
> @@ -514,6 +514,7 @@ acpi_tb_install_table(acpi_physical_address address,
>  	 * fully mapped later (in verify table). In any case, we must
>  	 * unmap the header that was mapped above.
>  	 */
> +	table_desc = &acpi_gbl_root_table_list.tables[table_index];
>  	final_table = acpi_tb_table_override(table, table_desc);
>  	if (!final_table) {
>  		final_table = table;	/* There was no override */

Is this chunk correct?  Why is @table_desc being assigned twice in
this function?

> +	/*
> +	 * Also initialize the table entries here, so that later we can use them
> +	 * to find SRAT at very eraly time to reserve hotpluggable memory.
                                ^ typo
Thanks.

-- 
tejun
