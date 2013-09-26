Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292Ab3IZPqa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 11:46:30 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:39352 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912Ab3IZPq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 11:46:29 -0400
Message-ID: <524456C3.4000904@gmail.com>
Date: Thu, 26 Sep 2013 23:46:11 +0800
From: Zhang Yanfei <zhangyanfei.yes@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607 Thunderbird/10.0.5
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: "Rafael J . Wysocki" <rjw@sisk.pl>, lenb@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, mingo@elte.hu,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Toshi Kani <toshi.kani@hp.com>, Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Thomas Renninger <trenn@suse.de>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>, Wen Congyang <wency@cn.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, isimatu.yasuaki@jp.fujitsu.com,
        izumi.taku@jp.fujitsu.com, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>, mina86@mina86.com,
        gong.chen@linux.intel.com, vasilis.liaskovitis@profitbricks.com,
        lwoodman@redhat.com, Rik van Riel <riel@redhat.com>,
        jweiner@redhat.com, prarit@redhat.com,
        "x86@kernel.org" <x86@kernel.org>, linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>, linux-acpi@vger.kernel.org,
        imtangchen@gmail.com, Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: Re: [PATCH v5 5/6] x86, acpi, crash, kdump: Do reserve_crashkernel()
 after SRAT is parsed
References: <5241D897.1090905@gmail.com> <5241DB3A.6090002@gmail.com> <20130926144958.GG3482@htj.dyndns.org>
In-Reply-To: <20130926144958.GG3482@htj.dyndns.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2013 10:49 PM, Tejun Heo wrote:
> On Wed, Sep 25, 2013 at 02:34:34AM +0800, Zhang Yanfei wrote:
>> From: Tang Chen <tangchen@cn.fujitsu.com>
>>
>> Memory reserved for crashkernel could be large. So we should not allocate
>> this memory bottom up from the end of kernel image.
>>
>> When SRAT is parsed, we will be able to know whihc memory is hotpluggable,
>> and we can avoid allocating this memory for the kernel. So reorder
>> reserve_crashkernel() after SRAT is parsed.
>>
>> Acked-by: Tejun Heo <tj@kernel.org>
> 
> So, I was hoping to hear from you on how you tested it when I wrote
> the previous comment - the "provided..." part.
> 

This function is actually used for kexec/kdump. So After applying 
this patch, booting the kernel, this reservation is successful and
the kdump service starts successfully.

Thanks.

-- 
Thanks.
Zhang Yanfei
