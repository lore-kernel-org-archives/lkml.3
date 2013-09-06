Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758693Ab3IFDKa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 23:10:30 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:38634 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753734Ab3IFDK1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 23:10:27 -0400
X-IronPort-AV: E=Sophos;i="4.90,850,1371052800"; 
   d="scan'208";a="8431753"
Message-ID: <52294758.7030801@cn.fujitsu.com>
Date: Fri, 06 Sep 2013 11:09:12 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
CC: rjw@sisk.pl, lenb@kernel.org, tglx@linutronix.de, mingo@elte.hu,
        hpa@zytor.com, akpm@linux-foundation.org, tj@kernel.org, trenn@suse.de,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        izumi.taku@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org,
        mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com,
        zhangyanfei@cn.fujitsu.com, x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 10/11] x86, mem-hotplug: Support initialize page tables
 from low to high.
References: <1377596268-31552-1-git-send-email-tangchen@cn.fujitsu.com> <1377596268-31552-11-git-send-email-tangchen@cn.fujitsu.com> <20130905133027.GA23038@hacker.(null)> <52293118.8080707@cn.fujitsu.com> <20130906021653.GA1062@hacker.(null)>
In-Reply-To: <20130906021653.GA1062@hacker.(null)>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/06 11:08:12,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/06 11:08:14,
	Serialize complete at 2013/09/06 11:08:14
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wanpeng,

On 09/06/2013 10:16 AM, Wanpeng Li wrote:
......
>>>> +#ifdef CONFIG_MOVABLE_NODE
>>>> +	unsigned long kernel_end;
>>>> +
>>>> +	if (movablenode_enable_srat&&
>>>> +	    memblock.current_order == MEMBLOCK_ORDER_LOW_TO_HIGH) {
>>>
>>> I think memblock.current_order == MEMBLOCK_ORDER_LOW_TO_HIGH is always
>>> true if config MOVABLE_NODE and movablenode_enable_srat == true if PATCH
>>> 11/11 is applied.
>>
>> memblock.current_order == MEMBLOCK_ORDER_LOW_TO_HIGH is true here if
>> MOVABLE_NODE
>> is configured, and it will be reset after SRAT is parsed. But
>> movablenode_enable_srat
>> could only be true when users specify movablenode boot option in the
>> kernel commandline.
>
> You are right.
>
> I mean the change should be:
>
> +#ifdef CONFIG_MOVABLE_NODE
> +       unsigned long kernel_end;
> +
> +       if (movablenode_enable_srat) {
>
> The is unnecessary to check memblock.current_order since it is always true
> if movable_node is configured and movablenode_enable_srat is true.
>

But I think, memblock.current_order is set outside init_mem_mapping(). And
the path in the if statement could only be run when current order is from
low to high. So I think it is safe to check it here.

I prefer to keep it at least in the next version patch-set. If others also
think it is unnecessary, I'm OK with removing the checking. :)

Thanks. :)
