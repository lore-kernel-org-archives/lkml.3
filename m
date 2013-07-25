Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803Ab3GYGsa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 02:48:30 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:31934 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753052Ab3GYGsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 02:48:23 -0400
X-IronPort-AV: E=Sophos;i="4.89,741,1367942400"; 
   d="scan'208";a="8017091"
Message-ID: <51F0CACF.6030606@cn.fujitsu.com>
Date: Thu, 25 Jul 2013 14:50:55 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
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
References: <1374220774-29974-1-git-send-email-tangchen@cn.fujitsu.com> <1374220774-29974-9-git-send-email-tangchen@cn.fujitsu.com> <20130723194540.GM21100@mtj.dyndns.org>
In-Reply-To: <20130723194540.GM21100@mtj.dyndns.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/25 14:46:05,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/25 14:46:17,
	Serialize complete at 2013/07/25 14:46:17
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2013 03:45 AM, Tejun Heo wrote:
> On Fri, Jul 19, 2013 at 03:59:21PM +0800, Tang Chen wrote:
>> @@ -514,6 +514,7 @@ acpi_tb_install_table(acpi_physical_address address,
>>   	 * fully mapped later (in verify table). In any case, we must
>>   	 * unmap the header that was mapped above.
>>   	 */
>> +	table_desc =&acpi_gbl_root_table_list.tables[table_index];
>>   	final_table = acpi_tb_table_override(table, table_desc);
>>   	if (!final_table) {
>>   		final_table = table;	/* There was no override */
>
> Is this chunk correct?  Why is @table_desc being assigned twice in
> this function?

Oh, my mistake. The second assignment is redundant. Only the first one is
useful. Will remove the redundant assignment in this patch.

Thanks.

>
>> +	/*
>> +	 * Also initialize the table entries here, so that later we can use them
>> +	 * to find SRAT at very eraly time to reserve hotpluggable memory.
>                                  ^ typo
> Thanks.
>
