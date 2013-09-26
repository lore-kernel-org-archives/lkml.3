Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385Ab3IZQv6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 12:51:58 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:44078 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911Ab3IZQvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 12:51:55 -0400
Message-ID: <52446618.7070703@gmail.com>
Date: Fri, 27 Sep 2013 00:51:36 +0800
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
Subject: Re: [PATCH v5 2/6] memblock: Introduce bottom-up allocation mode
References: <5241D897.1090905@gmail.com> <5241D9A4.4080305@gmail.com> <20130926144516.GD3482@htj.dyndns.org> <524454BE.4030602@gmail.com>
In-Reply-To: <524454BE.4030602@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2013 11:37 PM, Zhang Yanfei wrote:
> Hello tejun,
> 
> Thanks for your quick comments first:)
> 
> On 09/26/2013 10:45 PM, Tejun Heo wrote:
>> Hello,
>>
>> On Wed, Sep 25, 2013 at 02:27:48AM +0800, Zhang Yanfei wrote:
>>> +#ifdef CONFIG_MOVABLE_NODE
>>> +static inline void memblock_set_bottom_up(bool enable)
>>> +{
>>> +	memblock.bottom_up = enable;
>>> +}
>>> +
>>> +static inline bool memblock_bottom_up(void)
>>> +{
>>> +	return memblock.bottom_up;
>>> +}
>>
>> Can you please explain what this is for here?
> 
> OK, will do.

I write the function description here so you could give your
comments still in this version.

/*
 * Set the allocation direction to bottom-up or top-down.
 */
static inline void memblock_set_bottom_up(bool enable)
{
        memblock.bottom_up = enable;
}


/*
 * Check if the allocation direction is bottom-up or not.
 * if this is true, that said, the boot option "movablenode"
 * has been specified, and memblock will allocate memory
 * just near the kernel image.
 */
static inline bool memblock_bottom_up(void)
{
        return memblock.bottom_up;
}

Thanks.

-- 
Thanks.
Zhang Yanfei
